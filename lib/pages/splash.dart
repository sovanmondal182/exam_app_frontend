import 'dart:async';
import 'package:exam_app/pages/home_page.dart';
import 'package:exam_app/pages/login_page.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final StudentStore _studentStore = StudentStore();

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    _studentStore.isLoggedIn ? HomePage() : LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  scale: 1,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          )),
    );
  }
}
