import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  /// Cek apakah location service sudah enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Cek permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Cek dan request permission jika belum diizinkan
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah location service aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location service tidak aktif, minta user untuk mengaktifkan
      return false;
    }

    // Cek permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission ditolak
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permission ditolak permanent, arahkan ke settings
      return false;
    }

    // Permission granted
    return true;
  }

  /// Buka app settings untuk mengaktifkan permission
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Ambil current position
  Future<Position?> getCurrentPosition() async {
    try {
      // Cek permission dulu
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) {
        return null;
      }

      // Ambil position dengan accuracy tinggi
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Ambil latitude dan longitude dalam bentuk String
  Future<Map<String, String>?> getCoordinates() async {
    try {
      final position = await getCurrentPosition();
      
      if (position == null) {
        return null;
      }

      return {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      };
    } catch (e) {
      print('Error getting coordinates: $e');
      return null;
    }
  }

  /// Format koordinat untuk display (6 desimal)
  String formatCoordinate(double coordinate) {
    return coordinate.toStringAsFixed(6);
  }
}