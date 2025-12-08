import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_map_widget.dart';
import 'package:latlong2/latlong.dart';

class LocationFilterDialog extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final double? initialRadiusKm;
  final Function(double latitude, double longitude, double radiusKm) onApply;
  final List<MapMarker>? markers;

  const LocationFilterDialog({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialRadiusKm,
    required this.onApply,
    this.markers,
  });

  @override
  State<LocationFilterDialog> createState() => _LocationFilterDialogState();
}

class _LocationFilterDialogState extends State<LocationFilterDialog> {
  late double _latitude;
  late double _longitude;
  late double _radiusKm;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLatitude ?? 39.9334; // Default: Ankara
    _longitude = widget.initialLongitude ?? 32.8597;
    _radiusKm = widget.initialRadiusKm ?? 10.0;
    if (kDebugMode) {
      debugPrint('🗺️ LocationFilterDialog initState - markers: ${widget.markers?.length ?? 0}');
      if (widget.markers != null && widget.markers!.isNotEmpty) {
        debugPrint('📍 First marker in dialog: ${widget.markers!.first.position.latitude}, ${widget.markers!.first.position.longitude}');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Konum servisleri kapalı. Lütfen açın.'),
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Konum izni reddedildi.'),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Konum izni kalıcı olarak reddedilmiş. Ayarlardan açın.'),
            ),
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Konum alınamadı: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _onLocationChanged(double latitude, double longitude, double radiusKm) {
    setState(() {
      _latitude = latitude;
      _longitude = longitude;
      _radiusKm = radiusKm;
    });
  }

  double _calculateCenterLatitude() {
    if (widget.markers == null || widget.markers!.isEmpty) {
      return _latitude;
    }
    final latitudes = widget.markers!.map((m) => m.position.latitude).toList();
    return (latitudes.reduce((a, b) => a + b) / latitudes.length);
  }

  double _calculateCenterLongitude() {
    if (widget.markers == null || widget.markers!.isEmpty) {
      return _longitude;
    }
    final longitudes = widget.markers!.map((m) => m.position.longitude).toList();
    return (longitudes.reduce((a, b) => a + b) / longitudes.length);
  }

  double _calculateOptimalRadius() {
    if (widget.markers == null || widget.markers!.isEmpty) {
      return _radiusKm;
    }
    // Calculate distance between all markers and find max
    double maxDistance = 0;
    for (int i = 0; i < widget.markers!.length; i++) {
      for (int j = i + 1; j < widget.markers!.length; j++) {
        final lat1 = widget.markers![i].position.latitude;
        final lon1 = widget.markers![i].position.longitude;
        final lat2 = widget.markers![j].position.latitude;
        final lon2 = widget.markers![j].position.longitude;
        
        // Haversine formula for distance
        final dLat = (lat2 - lat1) * 3.141592653589793 / 180.0;
        final dLon = (lon2 - lon1) * 3.141592653589793 / 180.0;
        final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(lat1 * math.pi / 180.0) *
            math.cos(lat2 * math.pi / 180.0) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
        final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
        final distance = (6371 * c).toDouble(); // Earth radius in km
        
        if (distance > maxDistance) {
          maxDistance = distance;
        }
      }
    }
    // Add 20% padding
    return (maxDistance * 1.2).clamp(5.0, 50.0);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.black,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF0B0B0B),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white12),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Konum Seç',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Map
            Expanded(
              child: Builder(
                builder: (context) {
                  if (kDebugMode) {
                    debugPrint('🗺️ LocationFilterDialog build - markers: ${widget.markers?.length ?? 0}');
                  }
                  return widget.markers != null && widget.markers!.isNotEmpty
                      ? LocationMapWidget(
                          initialLatitude: _calculateCenterLatitude(),
                          initialLongitude: _calculateCenterLongitude(),
                          initialRadiusKm: _calculateOptimalRadius(),
                          onLocationChanged: _onLocationChanged,
                          markers: widget.markers,
                        )
                      : LocationMapWidget(
                          initialLatitude: _latitude,
                          initialLongitude: _longitude,
                          initialRadiusKm: _radiusKm,
                          onLocationChanged: _onLocationChanged,
                          markers: widget.markers,
                        );
                },
              ),
            ),
            // Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCCFF00)),
                        foregroundColor: const Color(0xFFCCFF00),
                        backgroundColor: const Color(0xFF1E1E1E),
                      ),
                      icon: _isLoadingLocation
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFCCFF00)),
                            )
                          : const Icon(Icons.my_location),
                      label: const Text('Mevcut Konum'),
                      onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCCFF00),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        widget.onApply(_latitude, _longitude, _radiusKm);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Uygula'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


