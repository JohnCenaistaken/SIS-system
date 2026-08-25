import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;
  UserRole? _userRole;
  bool _isLoggedIn = false;
  Map<String, String?> _userInfo = {};

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserRole? get userRole => _userRole;
  bool get isLoggedIn => _isLoggedIn;
  Map<String, String?> get userInfo => _userInfo;

  // Convenience getters — use these in providers and widgets
  String? get userId => _userInfo['id'];
  String? get classId => _userInfo['classId'];
  String get displayName => _userInfo['name'] ?? 'User';
  String get email => _userInfo['email'] ?? '';

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _isLoggedIn = await _authService.isLoggedIn();
    if (_isLoggedIn) {
      _userRole = await _authService.getUserRole();
      _userInfo = await _authService.getUserInfo();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _authService.login(email, password);
      if (success) {
        _isLoggedIn = true;
        _userRole = await _authService.getUserRole();
        _userInfo = await _authService.getUserInfo();
      } else {
        _error = 'Invalid email or password';
      }
      return success;
    } catch (e) {
      _error = 'An error occurred during login';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();

    _isLoggedIn = false;
    _userRole = null;
    _userInfo = {};
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}