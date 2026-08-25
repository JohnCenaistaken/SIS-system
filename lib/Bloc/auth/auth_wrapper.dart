import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/pages/splash_page.dart';
import '../../pages/landing_page.dart';
import '../../pages/student_landing_page.dart';
import '../../pages/teacher_dashboard.dart';
import '../../providers/student_provider.dart';
import '../../providers/teacher_provider.dart';
import 'auth_provider.dart';
import 'auth_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _providerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Show splash while checking persisted auth on startup
    if (auth.isLoading) {
      _providerInitialized = false;
      return const SplashPage();
    }

    // Not logged in — always go to landing
    if (!auth.isLoggedIn) {
      _providerInitialized = false;
      return const LandingPage();
    }

    // Logged in but role somehow null — safe fallback
    if (auth.userRole == null) {
      _providerInitialized = false;
      return const LandingPage();
    }

    // Initialize the correct provider exactly once per session
    if (!_providerInitialized) {
      _providerInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        switch (auth.userRole!) {
          case UserRole.teacher:
            final teacherId = auth.userId;
            if (teacherId != null) {
              context.read<TeacherProvider>().initialize(teacherId);
            }
            break;
          case UserRole.student:
            final studentId = auth.userId;
            final classId = auth.classId;
            if (studentId != null && classId != null) {
              context
                  .read<StudentProvider>()
                  .initialize(studentId, classId);
            }
            break;
        }
      });
    }

    // Route to the correct page
    switch (auth.userRole!) {
      case UserRole.teacher:
        return const TeacherDashboard();
      case UserRole.student:
        return const StudentLandingPage();
    }
  }
}