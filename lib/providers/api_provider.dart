import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiProvider {
  // Fungsi untuk menguji koneksi ke endpoint test
  Future<bool> testConnection() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.testEndpoint}'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}