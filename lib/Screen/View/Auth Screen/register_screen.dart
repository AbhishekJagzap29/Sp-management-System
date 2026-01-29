import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/API/Response%20Model/register_response_model.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/auth_controller.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  // ✅ Role selection
  bool isCitizen = false;
  bool isOfficer = false;
  bool isAdmin = false;

Future<void> _register() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    errorSnackBar('Error', 'Please fill all required fields');
    return;
  }

  final signupData = SignupRequestModel(
    name: name,
    email: email,
    password: password,
    citizen: isCitizen,
    officer: isOfficer,
    admin: isAdmin,
  );

  setState(() => _isLoading = true);

  final response = await authController.userSignup(signupData);

  setState(() => _isLoading = false);

  if (response != null && response.status == 'SUCCESS') {
    successSnackBar('Success', 'Signup completed');
    await Future.delayed(const Duration(milliseconds: 500));
    Get.offAll(() => const LoginScreen());
  } else {
    errorSnackBar('Failed', response?.message ?? 'Something went wrong');
  }
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
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 33, 96, 148)),
              onPressed: () => Get.back(),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildField(nameController, 'Full Name', Icons.person),
                      const SizedBox(height: 16),
                      _buildField(emailController, 'Email', Icons.email,
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildField(passwordController, 'Password', Icons.lock,
                          obscureText: true),
                      const SizedBox(height: 24),

                      // ✅ Role Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Role:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          CheckboxListTile(
                            value: isCitizen,
                            title: const Text("Citizen"),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) =>
                                setState(() => isCitizen = value ?? false),
                          ),
                          CheckboxListTile(
                            value: isOfficer,
                            title: const Text("Officer"),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) =>
                                setState(() => isOfficer = value ?? false),
                          ),
                          CheckboxListTile(
                            value: isAdmin,
                            title: const Text("Admin"),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) =>
                                setState(() => isAdmin = value ?? false),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  backgroundColor:
                                      const Color.fromARGB(255, 33, 96, 148),
                                ),
                                child: const Text('Register',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
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
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.blueGrey.shade50,
        filled: true,
      ),
    );
  }
}
