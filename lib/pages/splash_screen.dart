import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(child: Text('📚 Peexsell Education', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)),
          const Center(child: Text(' Empowering Education one report at a time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
          const SizedBox(
            height: 60,
          ),
          Icon(Icons.accessible_forward_sharp),
          const SizedBox(
            height: 60,
          ),
          Icon(Icons.accessible_forward_sharp),
          const SizedBox(
            height: 120,
          ),
          MaterialButton(onPressed: (){

          },
          color: Colors.pink,
          )

        ],
      ),
    );
  }
}
