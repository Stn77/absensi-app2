class ApiConfig {
  // Base URL Laravel API
  static const String baseUrl = 'http://192.168.9.100:8077/api';

  // test endpoint
  // static const String testEndpoint = '/test-connect';
  
  // Auth Endpoints
  static const String login = '/absen/login';
  static const String logout = '/absen/logout';
  
  // User Endpoints
  static const String profile = '/user/profile';
  
  // Absensi Endpoints
  static const String absenSubmit = '/absen/submit';
  static const String absenHistory = '/absen/history';
  
  // Timeout Duration
  static const Duration timeout = Duration(seconds: 30);
  
  // Headers
  static Map<String, String> headers({String? token}) {
    final Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      header['Authorization'] = 'Bearer $token';
    }
    
    return header;
  }
}
