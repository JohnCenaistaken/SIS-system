import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/pages/landing_page.dart';
import 'package:report_portal_boom/pages/login_page.dart';
import 'package:report_portal_boom/pages/teacher_dashboard.dart';
import 'package:report_portal_boom/pages/student_landing_page.dart';
import 'package:report_portal_boom/providers/landing_page_provider.dart';
import 'package:report_portal_boom/constants/app_theme.dart';
import 'package:report_portal_boom/providers/student_provider.dart';
import 'package:report_portal_boom/providers/teacher_provider.dart';

import 'Bloc/auth/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Set to false and bundle fonts as assets before production release
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LandingPageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Report Portal Boom',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/teacher_dashboard',
        routes: {
          '/landing': (context) => const LandingPage(),
          '/login': (context) => const LoginPage(),
          '/teacher_dashboard': (context) => const TeacherDashboard(),
          '/student_landing': (context) => const StudentLandingPage(),
        },

      ),
    );
  }
}