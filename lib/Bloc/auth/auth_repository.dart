import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class AuthRepository {
  static const String _userKey = 'user_data';

  // Mock login - replace with Firebase later
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Invalid credentials');
    }

    // Return mock user based on email
    if (email.contains('teacher')) {
      return UserModel.mockTeacher();
    } else if (email.contains('student')) {
      return UserModel.mockStudent();
    } else {
      throw Exception('User not found');
    }
  }

  // Mock register
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      role: role,
      lastLogin: DateTime.now(),
    );
  }

  // Logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Clear stored user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Persist user data
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toJson().toString());
  }

  // Get cached user
  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      // Parse and return user
      // For now return null until proper JSON parsing
      return null;
    }
    return null;
  }
}