import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool showOtpField = false;
  bool showPasswordFields = false;
  bool isLoading = false;

  void _getOtp() {
    final contact = contactController.text.trim();

    if (contact.isEmpty) {
      errorSnackBar('Error', 'Please enter your mobile number or email');
      return;
    }

    // Simulate sending OTP
    setState(() => showOtpField = true);
    successSnackBar('OTP Sent', 'OTP has been sent successfully');
  }

  void _verifyOtp() {
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      errorSnackBar('Error', 'Please enter the OTP');
      return;
    }

    // Simulate OTP verification
    setState(() => showPasswordFields = true);
    successSnackBar('OTP Verified', 'Reset your password');
  }

  void _submit() {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      errorSnackBar('Error', 'Please fill both password fields');
      return;
    }

    if (password != confirmPassword) {
      errorSnackBar('Error', 'Passwords do not match');
      return;
    }

    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);
      successSnackBar('Success', 'Password reset successfully');
      Get.offAll(() => const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 33, 96, 148)),
              onPressed: () => Get.back(),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                      children: [
              Image.asset(
                'assets/images/raipur_logo.jpg',
                height: 150,
                width: 250,
                fit: BoxFit.contain,
              ),
                      const SizedBox(height: 20),
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your registered email or mobile number',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _buildField(contactController, 'Email or Mobile Number', Icons.email_outlined),
                      const SizedBox(height: 16),
                      if (!showOtpField)
                        _buildButton('Get OTP', _getOtp),
                      if (showOtpField) ...[
                        _buildField(otpController, 'Enter OTP', Icons.sms),
                        const SizedBox(height: 16),
                        if (!showPasswordFields)
                          _buildButton('Verify OTP', _verifyOtp),
                      ],
                      if (showPasswordFields) ...[
                        _buildField(passwordController, 'New Password', Icons.lock_outline, obscureText: true),
                        const SizedBox(height: 16),
                        _buildField(confirmPasswordController, 'Re-enter Password', Icons.lock_outline, obscureText: true),
                        const SizedBox(height: 24),
                        isLoading
                            ? const CircularProgressIndicator()
                            : _buildButton('Submit', _submit),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.blueGrey.shade50,
        filled: true,
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

 
}
