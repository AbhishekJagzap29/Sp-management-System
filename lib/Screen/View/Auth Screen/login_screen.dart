

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/auth_controller.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/forgot_password.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());

  Future<void> _login() async {
    final username = authController.loginEmailController.text.trim();
    final password = authController.passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      errorSnackBar("आवश्यक माहिती", 'कृपया लॉगिन तपशील भरा');
      return;
    }
    await authController.userLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/PRPS.png',
                  height: 180,
                  width: 400,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 15),
                Text(
                  'पुन्हा स्वागत आहे',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'सुरू ठेवण्यासाठी लॉगिन करा',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 32),

                // Username
                TextField(
                  controller: authController.loginEmailController,
                  decoration: InputDecoration(
                    hintText: 'वापरकर्तानाव',
                    prefixIcon: Icon(Icons.person),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.blueGrey.shade50,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: authController.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'संकेतशब्द',
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.blueGrey.shade50,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  // child: TextButton(
                  //   onPressed: () {
                  //     Get.to(() => const ForgotPasswordScreen());
                  //   },
                  //   child: Text('संकेतशब्द विसरलात?'),
                  // ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'लॉगिन करा',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   // Text('नवीन वापरकर्ता?'),
                    // TextButton(
                    //   onPressed: () {
                    //     Get.to(() => const RegisterScreen());
                    //   },
                    //   child: Text('साइन अप करा'),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






