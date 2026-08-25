/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Bloc/auth/auth_provider.dart';
import 'Bloc/auth/auth_wrapper.dart';
import 'providers/landing_page_provider.dart';
import 'constants/app_theme.dart';

class AppBootstrap {
  static Widget initialize() {
    // Don't set allowRuntimeFetching to false, keep it as default
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LandingPageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Portal Boom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}*/
