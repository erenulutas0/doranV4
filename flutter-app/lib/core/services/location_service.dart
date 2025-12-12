import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSnapshot {
  final double latitude;
  final double longitude;
  final String? city;
  final DateTime updatedAt;

  LocationSnapshot({
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
    this.city,
  });
}

class LocationService {
  static const _kCity = 'loc_city';
  static const _kLat = 'loc_lat';
  static const _kLon = 'loc_lon';
  static const _kUpdatedMs = 'loc_updated_ms';
  static const _kAuthPromptedOnce = 'loc_auth_prompted_once';

  /// Read cached location (fast).
  static Future<LocationSnapshot?> getCached() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_kLat);
    final lon = prefs.getDouble(_kLon);
    final updated = prefs.getInt(_kUpdatedMs);
    if (lat == null || lon == null || updated == null) return null;
    return LocationSnapshot(
      latitude: lat,
      longitude: lon,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updated),
      city: prefs.getString(_kCity),
    );
  }

  static Future<void> setCached({
    required double latitude,
    required double longitude,
    String? city,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kLat, latitude);
    await prefs.setDouble(_kLon, longitude);
    await prefs.setInt(_kUpdatedMs, DateTime.now().millisecondsSinceEpoch);
    if (city != null && city.isNotEmpty) {
      await prefs.setString(_kCity, city);
    }
  }

  /// Logged-in users: prompt only once.
  static Future<bool> getAuthPromptedOnce() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kAuthPromptedOnce) ?? false;
  }

  static Future<void> setAuthPromptedOnce() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAuthPromptedOnce, true);
  }

  /// Request permission (optional) and fetch a location quickly.
  ///
  /// Speed strategy:
  /// - Use last known position first (instant if available)
  /// - Fallback to getCurrentPosition with medium accuracy + 2s timeout
  static Future<LocationSnapshot?> getFast({
    required bool requestPermission,
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermission) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        final city = _inferCity(last.latitude, last.longitude);
        await setCached(latitude: last.latitude, longitude: last.longitude, city: city);
        return LocationSnapshot(
          latitude: last.latitude,
          longitude: last.longitude,
          updatedAt: DateTime.now(),
          city: city,
        );
      }
    } catch (_) {
      // ignore
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 2),
      );
      final city = _inferCity(pos.latitude, pos.longitude);
      await setCached(latitude: pos.latitude, longitude: pos.longitude, city: city);
      return LocationSnapshot(
        latitude: pos.latitude,
        longitude: pos.longitude,
        updatedAt: DateTime.now(),
        city: city,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LocationService.getFast failed: $e');
      }
      return null;
    }
  }

  static String? _inferCity(double lat, double lon) {
    // Istanbul bounding box (simple heuristic)
    if (lat >= 40.5 && lat <= 41.5 && lon >= 28.0 && lon <= 29.5) {
      return 'Istanbul';
    }
    // Izmir bounding box
    if (lat >= 38.2 && lat <= 38.6 && lon >= 26.9 && lon <= 27.4) {
      return 'Izmir';
    }
    // Ankara bounding box
    if (lat >= 39.7 && lat <= 40.1 && lon >= 32.5 && lon <= 33.1) {
      return 'Ankara';
    }
    return null;
  }
}


