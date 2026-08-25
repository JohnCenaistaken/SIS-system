import 'package:flutter/material.dart';
import 'login_page.dart';

class LoginPageWrapper extends StatelessWidget {
  const LoginPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Show the login dialog immediately when this page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoginPage(),
      );
    });

    // Return an empty container as background
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}