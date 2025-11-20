import 'package:intl/intl.dart';
import '../config/api_config.dart';
import '../models/absensi_response.dart';
import '../models/riwayat_absen_model.dart';
import 'api_service.dart';

class AbsensiService {
  final ApiService _apiService = ApiService();

  /// Submit absensi (datang atau pulang)
  /// Params:
  /// - latitude: koordinat latitude
  /// - longitude: koordinat longitude
  /// Returns AbsensiResponse jika berhasil
  /// Throws Exception jika gagal
  Future<AbsensiResponse> submitAbsensi({
    required String latitude,
    required String longitude,
  }) async {
    try {
      // Get current date and time
      final now = DateTime.now();
      final time = DateFormat('HH:mm:ss').format(now);
      final hari = _getDayNameInIndonesian(now.weekday);
      final tanggal = DateFormat('yyyy-MM-dd').format(now);

      // Request ke API
      final response = await _apiService.post(
        ApiConfig.absenSubmit,
        body: {
          'latitude': latitude,
          'longitude': longitude,
          'time': time,
          'hari': hari,
          'tanggal': tanggal,
        },
        requiresAuth: true,
      );

      // Parse response ke AbsensiResponse model
      final absensiResponse = AbsensiResponse.fromJson(response);

      return absensiResponse;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get history absensi
  /// Returns List<RiwayatAbsenModel>
  /// Throws Exception jika gagal
  Future<List<RiwayatAbsenModel>> getHistory() async {
    try {
      // Request ke API
      final response = await _apiService.get(
        ApiConfig.absenHistory,
        requiresAuth: true,
      );

      // Parse response
      final List<dynamic> data = response['data'];
      
      // Convert ke list of RiwayatAbsenModel
      final List<RiwayatAbsenModel> history = data
          .map((item) => RiwayatAbsenModel.fromJson(item))
          .toList();

      return history;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Helper: Get day name in Indonesian
  String _getDayNameInIndonesian(int weekday) {
    switch (weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return 'Unknown';
    }
  }

  /// Helper: Format date to Indonesian format
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Helper: Format time to HH:mm
  String formatTime(String timeString) {
    try {
      final time = DateFormat('HH:mm:ss').parse(timeString);
      return DateFormat('HH:mm').format(time);
    } catch (e) {
      return timeString;
    }
  }
}