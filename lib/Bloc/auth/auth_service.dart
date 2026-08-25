import 'package:shared_preferences/shared_preferences.dart';
import 'package:report_portal_boom/models/student_model.dart';
import 'package:report_portal_boom/models/teacher_model.dart';

import '../../services/mock_data_service.dart';

enum UserRole { student, teacher }

class AuthService {
  static const String _loggedInKey = 'is_logged_in';
  static const String _userRoleKey = 'user_role';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';       // ← new
  static const String _userClassIdKey = 'class_id'; // ← new (students only)

  // Mock credentials mapped to MockDatabase IDs
  static const Map<String, Map<String, String>> _mockCredentials = {
    'student@test.com': {
      'password': 'student123',
      'role': 'student',
      'id': 'STU-001',
    },
    'teacher@test.com': {
      'password': 'teacher123',
      'role': 'teacher',
      'id': 'TCH-001',
    },
  };

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final entry = _mockCredentials[email];
    if (entry == null || entry['password'] != password) return false;

    final role = entry['role']!;
    final id = entry['id']!;

    // Resolve display name and classId from MockDatabase
    String name = '';
    String classId = '';

    if (role == 'student') {
      try {
        final student = MockDatabase.students.firstWhere((s) => s.id == id);
        name = student.fullName;
        classId = student.classId;
      } catch (_) {
        name = 'Student';
      }
    } else {
      try {
        final teacher = MockDatabase.teachers.firstWhere((t) => t.id == id);
        name = teacher.fullName;
      } catch (_) {
        name = 'Teacher';
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_userRoleKey, role);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userIdKey, id);
    if (classId.isNotEmpty) {
      await prefs.setString(_userClassIdKey, classId);
    }

    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<UserRole?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString(_userRoleKey);
    if (roleString == 'student') return UserRole.student;
    if (roleString == 'teacher') return UserRole.teacher;
    return null;
  }

  Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_userEmailKey),
      'name': prefs.getString(_userNameKey),
      'role': prefs.getString(_userRoleKey),
      'id': prefs.getString(_userIdKey),
      'classId': prefs.getString(_userClassIdKey),
    };
  }
}