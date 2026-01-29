import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/login_screen.dart';
import 'package:sp_manage_system/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 500)); 


    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getString('isLogin') == 'true';
    final userType = prefs.getString('userType');





    if (isLogin && userType != null) {
      Get.offAll(() => HomeScreen(userType: userType));
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
