import '../config/api_config.dart';
import '../models/login_response.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  /// Login dengan email dan password
  /// Returns LoginResponse jika berhasil
  /// Throws Exception jika gagal
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      // Request ke API
      final response = await _apiService.post(
        ApiConfig.login,
        body: {
          'email': email,
          'password': password,
        },
        requiresAuth: false, // Login tidak perlu auth
      );

      // Parse response ke LoginResponse model
      final loginResponse = LoginResponse.fromJson(response);

      // Simpan token dan user data ke storage
      await _storageService.saveToken(loginResponse.token);
      await _storageService.saveUserData(
        userId: loginResponse.user.id,
        userName: loginResponse.user.name,
        userEmail: loginResponse.user.email,
      );

      return loginResponse;
    } catch (e) {
      // Re-throw error untuk dihandle di provider/UI
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout - hapus token dari server dan local storage
  Future<void> logout() async {
    try {
      // Request logout ke API (akan menghapus token di server)
      await _apiService.post(
        ApiConfig.logout,
        requiresAuth: true,
      );

      // Hapus semua data local
      await _storageService.clearAll();
    } catch (e) {
      // Tetap hapus data local meskipun request gagal
      await _storageService.clearAll();
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Cek apakah user sudah login
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  /// Get current token
  Future<String?> getToken() async {
    return await _storageService.getToken();
  }

  /// Get user data dari storage
  Future<Map<String, dynamic>> getUserData() async {
    final userId = await _storageService.getUserId();
    final userName = await _storageService.getUserName();
    final userEmail = await _storageService.getUserEmail();

    return {
      'id': userId,
      'name': userName,
      'email': userEmail,
    };
  }
}