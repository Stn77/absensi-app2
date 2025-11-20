import '../config/api_config.dart';
import '../models/profile_response.dart';
import 'api_service.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  /// Get profile siswa
  /// Returns ProfileResponse dengan data user dan siswa lengkap
  /// Throws Exception jika gagal
  Future<ProfileResponse> getProfile() async {
    try {
      // Request ke API
      final response = await _apiService.get(
        ApiConfig.profile,
        requiresAuth: true,
      );

      // Parse response ke ProfileResponse model
      final profileResponse = ProfileResponse.fromJson(response);

      return profileResponse;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Refresh profile data
  /// Alias untuk getProfile untuk clarity
  Future<ProfileResponse> refreshProfile() async {
    return await getProfile();
  }
}