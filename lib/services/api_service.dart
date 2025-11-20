import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storageService = StorageService();

  /// GET Request
  Future<Map<String, dynamic>> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      String? token;
      if (requiresAuth) {
        token = await _storageService.getToken();
        if (token == null) {
          throw Exception('Token tidak ditemukan. Silakan login kembali.');
        }
      }

      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.get(
        url,
        headers: ApiConfig.headers(token: token),
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Pastikan perangkat terhubung ke jaringan.');
    } on TimeoutException {
      throw Exception('Request timeout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// POST Request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      String? token;
      if (requiresAuth) {
        token = await _storageService.getToken();
        if (token == null) {
          throw Exception('Token tidak ditemukan. Silakan login kembali.');
        }
      }

      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.post(
        url,
        headers: ApiConfig.headers(token: token),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Pastikan perangkat terhubung ke jaringan.');
    } on TimeoutException {
      throw Exception('Request timeout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// PUT Request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      String? token;
      if (requiresAuth) {
        token = await _storageService.getToken();
        if (token == null) {
          throw Exception('Token tidak ditemukan. Silakan login kembali.');
        }
      }

      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.put(
        url,
        headers: ApiConfig.headers(token: token),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Pastikan perangkat terhubung ke jaringan.');
    } on TimeoutException {
      throw Exception('Request timeout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// DELETE Request
  Future<Map<String, dynamic>> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      String? token;
      if (requiresAuth) {
        token = await _storageService.getToken();
        if (token == null) {
          throw Exception('Token tidak ditemukan. Silakan login kembali.');
        }
      }

      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.delete(
        url,
        headers: ApiConfig.headers(token: token),
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Pastikan perangkat terhubung ke jaringan.');
    } on TimeoutException {
      throw Exception('Request timeout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// Handle HTTP Response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    // Decode response body
    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Format response tidak valid dari server.');
    }

    // Handle berdasarkan status code
    if (statusCode >= 200 && statusCode < 300) {
      // Success (2xx)
      return data;
    } else if (statusCode == 401) {
      // Unauthorized
      throw Exception(data['message'] ?? 'Sesi telah berakhir. Silakan login kembali.');
    } else if (statusCode == 403) {
      // Forbidden
      throw Exception(data['message'] ?? 'Anda tidak memiliki akses.');
    } else if (statusCode == 404) {
      // Not Found
      throw Exception(data['message'] ?? 'Data tidak ditemukan.');
    } else if (statusCode == 422) {
      // Validation Error
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null) {
        final firstError = errors.values.first;
        final errorMessage = firstError is List ? firstError.first : firstError;
        throw Exception(errorMessage);
      }
      throw Exception(data['message'] ?? 'Validasi gagal.');
    } else if (statusCode >= 500) {
      // Server Error
      throw Exception('Terjadi kesalahan pada server. Silakan coba lagi nanti.');
    } else {
      // Other errors
      throw Exception(data['message'] ?? 'Terjadi kesalahan. Silakan coba lagi.');
    }
  }
}