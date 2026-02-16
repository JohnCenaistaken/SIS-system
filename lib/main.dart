import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/Components/premium_report_card.dart';
import 'package:report_portal_boom/Components/report_card.dart';
import 'package:report_portal_boom/Components/sample_report.dart';
import 'package:report_portal_boom/constants/app_theme.dart';
import 'package:report_portal_boom/models/report_model.dart';
import 'package:report_portal_boom/pages/home_page.dart';
import 'package:report_portal_boom/pages/landing_page.dart';
import 'package:report_portal_boom/pages/login_page.dart';
import 'package:report_portal_boom/pages/splash_screen.dart';
import 'package:report_portal_boom/pages/student_marks_entry.dart';
import 'package:report_portal_boom/pages/teacher_dashboard.dart';
import 'package:report_portal_boom/providers/landing_page_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: "AIzaSyAN3uJmT4LQDo6Pu6qnuSfx0Nnge185wLA",
        authDomain: "report-portal-13b31.firebaseapp.com",
        projectId: "report-portal-13b31",
        storageBucket: "report-portal-13b31.appspot.com",
        messagingSenderId: "366147980597",
        appId: "1:366147980597:web:7f784f955ea2ed5ccc907c",
        measurementId: "G-DNE2QTLE0Z"));

  try {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('test').doc('connection').set({
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'success'
    });
    print('🔥 Firebase connection successful!');
  } catch (e) {
    print('❌ Firebase connection failed: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LandingPageProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/landing',
        routes: {
          '/landing': (context) => const LandingPage(),
          '/splash': (context) => const SplashScreen(),
          '/student_mark_entry': (context) => const StudentMarkEntry(),
          '/login': (context) {
            // Show login as modal when accessed via route
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                builder: (context) => const LoginPage(),
              ).then((_) {
                // If dialog is closed and we're still on login route, go back
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              });
            });
            // Return a minimal scaffold that will be covered by the dialog
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          },
          '/home': (context) => const LandingPage(),
          '/premium_report': (context) => PremiumReportCard(report: sampleReport),
          '/report_generation_screen': (context) => const ReportGenerationScreen(),
          '/teacher_dashboard': (context) => const TeacherDashboard(),
          '/report_card_page': (context) => ReportCardPage(report: sampleReport),
        },
      ),
    );
  }
}