import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/oneSignal_service.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/splash_screen.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OneSignalService().initOneSignal(); // ✅ Init OneSignal
  await preferences.init(); // ✅ Init SharedPreferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SP Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(seedColor: appColor),
      ),
      home: const SplashScreen(),
    );
  }
}
