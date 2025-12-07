import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapWidget extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double initialRadiusKm;
  final Function(double latitude, double longitude, double radiusKm) onLocationChanged;
  final List<MapMarker>? markers;

  const LocationMapWidget({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.initialRadiusKm,
    required this.onLocationChanged,
    this.markers,
  });

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  late MapController _mapController;
  late LatLng _center;
  late double _radiusKm;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _center = LatLng(widget.initialLatitude, widget.initialLongitude);
    _radiusKm = widget.initialRadiusKm;
  }

  void _updateLocation() {
    widget.onLocationChanged(_center.latitude, _center.longitude, _radiusKm);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Map
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: _calculateZoom(_radiusKm),
              onTap: (tapPosition, point) {
                setState(() {
                  _center = point;
                });
                _updateLocation();
              },
            ),
            children: [
              // OpenStreetMap tiles
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ecommerce_app',
              ),
              // Circle overlay for radius
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _center,
                    radius: _radiusKm * 1000, // Convert km to meters
                    color: Colors.blue.withOpacity(0.2),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              // Center marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
              // Additional markers (shops, venues, etc.)
              if (widget.markers != null)
                MarkerLayer(
                  markers: widget.markers!.map((marker) {
                    return Marker(
                      point: marker.position,
                      width: 30,
                      height: 30,
                      child: marker.icon,
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
        // Radius slider
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Arama Yarıçapı: ${_radiusKm.toStringAsFixed(1)} km',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: _radiusKm,
                min: 1.0,
                max: 50.0,
                divisions: 49,
                label: '${_radiusKm.toStringAsFixed(1)} km',
                onChanged: (value) {
                  setState(() {
                    _radiusKm = value;
                    _mapController.move(_center, _calculateZoom(_radiusKm));
                  });
                  _updateLocation();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateZoom(double radiusKm) {
    // Calculate appropriate zoom level based on radius
    if (radiusKm <= 1) return 15.0;
    if (radiusKm <= 5) return 13.0;
    if (radiusKm <= 10) return 12.0;
    if (radiusKm <= 25) return 11.0;
    return 10.0;
  }
}

class MapMarker {
  final LatLng position;
  final Widget icon;

  MapMarker({
    required this.position,
    required this.icon,
  });
}


