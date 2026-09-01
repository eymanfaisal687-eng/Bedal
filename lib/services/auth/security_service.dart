import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class SecurityService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Natively fetches the unique software identifier for fingerprint configuration
  Future<String> fetchSecureDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? "unknown_ios_signature";
      }
      return "anonymous_client";
    } catch (_) {
      return "fallback_anonymous_token";
    }
  }

  /// Simulates background regional geofencing lookups
  Future<bool> verifyJeddahGeofence(String deviceId) async {
    // Simulated backend server validation check delay
    await Future.delayed(const Duration(milliseconds: 1800));
    return true; // Set to false to test out 'Explore Mode' layout paths
  }
}
