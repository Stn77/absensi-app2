import 'package:flutter/material.dart';
import '../models/siswa_model.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  // State
  UserModel? _user;
  SiswaModel? _siswa;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  SiswaModel? get siswa => _siswa;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _user != null && _siswa != null;

  /// Load profile data
  Future<bool> loadProfile() async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      // Call profile service
      final response = await _profileService.getProfile();

      // Update state
      _user = response.data.user;
      _siswa = response.data.siswa;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Refresh profile data
  Future<bool> refreshProfile() async {
    return await loadProfile();
  }

  /// Clear profile data (saat logout)
  void clearProfile() {
    _user = null;
    _siswa = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get full name siswa
  String getFullName() {
    return _siswa?.name ?? 'Tidak ada nama';
  }

  /// Get kelas dan jurusan formatted
  String getKelasJurusan() {
    if (_siswa == null) return '-';
    return '${_siswa!.kelas.name} ${_siswa!.jurusan.name}';
  }

  /// Get alamat atau default text
  String getAlamat() {
    return _siswa?.alamat ?? 'Belum diisi';
  }

  /// Get no telepon atau default text
  String getNoTelepon() {
    return _siswa?.noTelepon ?? 'Belum diisi';
  }

  /// Get NIK atau default text
  String getNik() {
    return _siswa?.nik ?? 'Belum diisi';
  }

  /// Get tempat tanggal lahir formatted
  String getTempatTanggalLahir() {
    if (_siswa == null) return 'Belum diisi';
    
    final tempat = _siswa!.tempatLahir ?? '-';
    final tanggal = _siswa!.tanggalLahir ?? '-';
    
    if (tempat == '-' && tanggal == '-') {
      return 'Belum diisi';
    }
    
    return '$tempat, $tanggal';
  }

  /// Get jenis kelamin atau default text
  String getJenisKelamin() {
    return _siswa?.jenisKelamin ?? 'Belum diisi';
  }
}