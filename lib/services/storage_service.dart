import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // FlutterSecureStorage untuk data sensitif seperti token
  final _secureStorage = const FlutterSecureStorage();
  
  // SharedPreferences untuk data non-sensitif
  static SharedPreferences? _prefs;
  
  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  
  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  // ===== TOKEN MANAGEMENT (Secure Storage) =====
  
  /// Simpan auth token (secure)
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }
  
  /// Ambil auth token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
  
  /// Hapus token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
  
  /// Cek apakah user sudah login (ada token)
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  // ===== USER DATA (SharedPreferences) =====
  
  /// Simpan user data
  Future<void> saveUserData({
    required int userId,
    required String userName,
    required String userEmail,
  }) async {
    await init();
    await _prefs!.setInt(_userIdKey, userId);
    await _prefs!.setString(_userNameKey, userName);
    await _prefs!.setString(_userEmailKey, userEmail);
  }
  
  /// Ambil user ID
  Future<int?> getUserId() async {
    await init();
    return _prefs!.getInt(_userIdKey);
  }
  
  /// Ambil user name
  Future<String?> getUserName() async {
    await init();
    return _prefs!.getString(_userNameKey);
  }
  
  /// Ambil user email
  Future<String?> getUserEmail() async {
    await init();
    return _prefs!.getString(_userEmailKey);
  }
  
  // ===== CLEAR ALL DATA =====
  
  /// Hapus semua data (logout)
  Future<void> clearAll() async {
    await init();
    await _secureStorage.deleteAll();
    await _prefs!.clear();
  }
}