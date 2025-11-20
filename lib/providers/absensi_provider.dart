import 'package:flutter/material.dart';
import '../models/absensi_response.dart';
import '../models/riwayat_absen_model.dart';
import '../services/absensi_service.dart';
import '../services/location_service.dart';

class AbsensiProvider extends ChangeNotifier {
  final AbsensiService _absensiService = AbsensiService();
  final LocationService _locationService = LocationService();

  // State
  List<RiwayatAbsenModel> _history = [];
  AbsensiResponse? _lastAbsensi;
  bool _isLoading = false;
  bool _isLoadingHistory = false;
  String? _errorMessage;
  String? _currentLatitude;
  String? _currentLongitude;
  bool _isGettingLocation = false;

  // Getters
  List<RiwayatAbsenModel> get history => _history;
  AbsensiResponse? get lastAbsensi => _lastAbsensi;
  bool get isLoading => _isLoading;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get errorMessage => _errorMessage;
  String? get currentLatitude => _currentLatitude;
  String? get currentLongitude => _currentLongitude;
  bool get isGettingLocation => _isGettingLocation;
  bool get hasLocation => _currentLatitude != null && _currentLongitude != null;

  /// Get current location
  Future<bool> getCurrentLocation() async {
    try {
      _errorMessage = null;
      _isGettingLocation = true;
      notifyListeners();

      // Cek permission
      final hasPermission = await _locationService.handleLocationPermission();
      
      if (!hasPermission) {
        _errorMessage = 'Permission lokasi ditolak. Silakan aktifkan di pengaturan.';
        _isGettingLocation = false;
        notifyListeners();
        return false;
      }

      // Get coordinates
      final coordinates = await _locationService.getCoordinates();

      if (coordinates == null) {
        _errorMessage = 'Gagal mendapatkan lokasi. Pastikan GPS aktif.';
        _isGettingLocation = false;
        notifyListeners();
        return false;
      }

      _currentLatitude = coordinates['latitude'];
      _currentLongitude = coordinates['longitude'];
      _isGettingLocation = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Error mengambil lokasi: ${e.toString()}';
      _isGettingLocation = false;
      notifyListeners();
      return false;
    }
  }

  /// Submit absensi
  Future<bool> submitAbsensi() async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      // Validasi koordinat
      if (_currentLatitude == null || _currentLongitude == null) {
        throw Exception('Lokasi belum tersedia. Silakan ambil lokasi terlebih dahulu.');
      }

      // Submit absensi
      final response = await _absensiService.submitAbsensi(
        latitude: _currentLatitude!,
        longitude: _currentLongitude!,
      );

      _lastAbsensi = response;
      _isLoading = false;
      
      // Refresh history setelah absen berhasil
      await loadHistory();

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load history absensi
  Future<bool> loadHistory() async {
    try {
      _errorMessage = null;
      _isLoadingHistory = true;
      notifyListeners();

      final history = await _absensiService.getHistory();

      _history = history;
      _isLoadingHistory = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoadingHistory = false;
      notifyListeners();
      return false;
    }
  }

  /// Refresh history
  Future<bool> refreshHistory() async {
    return await loadHistory();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear last absensi
  void clearLastAbsensi() {
    _lastAbsensi = null;
    notifyListeners();
  }

  /// Clear all data (saat logout)
  void clearAll() {
    _history = [];
    _lastAbsensi = null;
    _errorMessage = null;
    _isLoading = false;
    _isLoadingHistory = false;
    _currentLatitude = null;
    _currentLongitude = null;
    _isGettingLocation = false;
    notifyListeners();
  }

  /// Get formatted coordinates
  String getFormattedCoordinates() {
    if (_currentLatitude == null || _currentLongitude == null) {
      return 'Lokasi belum tersedia';
    }
    return 'Lat: $_currentLatitude, Long: $_currentLongitude';
  }

  /// Cek apakah sudah absen hari ini (datang)
  bool hasAbsenDatangToday() {
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    return _history.any((item) => 
      item.tanggal == todayString && item.jenis == 'datang'
    );
  }

  /// Cek apakah sudah absen hari ini (pulang)
  bool hasAbsenPulangToday() {
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    return _history.any((item) => 
      item.tanggal == todayString && item.jenis == 'pulang'
    );
  }

  /// Get status absen hari ini
  String getAbsenStatusToday() {
    if (hasAbsenPulangToday()) {
      return 'Sudah absen datang dan pulang';
    } else if (hasAbsenDatangToday()) {
      return 'Sudah absen datang';
    } else {
      return 'Belum absen hari ini';
    }
  }
}