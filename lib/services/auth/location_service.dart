// =========================================================================
// 🗺️ FILE: location_service.dart
// ROLE: Layer 1 Hardware GPS Interface & Spatial Translation Pipeline
// =========================================================================

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Fetches the live physical device coordinates and returns the user's campus city name.
  Future<String> getDeviceCityName() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Jeddah';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Jeddah';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return 'Jeddah';
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );

      // Geolocation spatial translation
      if (position.latitude > 20.0 && position.latitude < 23.0) {
        return 'Jeddah';
      } else if (position.latitude > 30.0 && position.latitude < 35.0) {
        return 'Islamabad';
      }

      return 'Jeddah';
    } catch (exception) {
      debugPrint('Location service notice: $exception');
      return 'Jeddah';
    }
  }
}
