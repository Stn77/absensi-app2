import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // State
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Initialize - cek apakah user sudah login
  Future<void> initialize() async {
    try {
      _status = AuthStatus.initial;
      notifyListeners();

      final isLoggedIn = await _authService.isLoggedIn();

      if (isLoggedIn) {
        // User sudah login, ambil data user dari storage
        final userData = await _authService.getUserData();
        _user = UserModel(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          createdAt: '',
          updatedAt: '',
        );
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }

      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      // Reset error message
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      // Call auth service
      final response = await _authService.login(
        email: email,
        password: password,
      );

      // Update state
      _user = response.user;
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<bool> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Call auth service
      await _authService.logout();

      // Clear state
      _user = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
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

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Set loading state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}