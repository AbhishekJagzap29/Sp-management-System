import 'package:get/get.dart';
import 'package:onesignal_flutter/src/defines.dart';
import 'package:sp_manage_system/API/Repo/auth_repo.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';



final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;
  static const String playerId = "playerId";  // ✅ add this

  init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const isLogin = "isLogin";
  static const isAdmin = "isAdmin";
  static const userLoginData = "userLoginData";
  static const sessionId = "sessionId";
  static const userType = "userType";
  static const userId = "userId";
  static const del_activity_users = "del_activity_users";
  static const userPassword = "userPassword";
  static const userName = "userName";


Future<void> logOut() async {
  await init();

  await _preferences?.remove(isLogin);
  await _preferences?.remove(userType);
  await _preferences?.remove(userLoginData);
  await _preferences?.remove(userId);
  await _preferences?.remove(userName);
  await _preferences?.remove(userPassword);
  await _preferences?.remove(isAdmin);
  await _preferences?.remove(del_activity_users);
  await _preferences?.remove(sessionId);  

  Get.offAll(() => const LoginScreen());
  successSnackBar("यशस्वी", "तुम्ही लॉगआउट झाला आहात");

 // successSnackBar("Success", "You've been logged out");
}

  Future<bool?> putString(String key, String value) async {
    return _preferences == null ? null : _preferences!.setString(key, value);
  }

  String? getString(String key, {String defValue = ""}) {
    return _preferences == null
        ? defValue
        : _preferences!.getString(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    return _preferences == null ? null : _preferences!.setInt(key, value);
  }

  int? getInt(String key, {int defValue = 0}) {
    return _preferences == null
        ? defValue
        : _preferences!.getInt(key) ?? defValue;
  }

  Future<bool?> putDouble(String key, double value) async {
    return _preferences == null ? null : _preferences!.setDouble(key, value);
  }

  double getDouble(String key, {double defValue = 0.0}) {
    return _preferences == null
        ? defValue
        : _preferences!.getDouble(key) ?? defValue;
  }

  Future<bool?> putBool(String key, bool value) async {
    return _preferences == null ? null : _preferences!.setBool(key, value);
  }

  bool? getBool(String key, {bool defValue = false}) {
    return _preferences == null
        ? defValue
        : _preferences!.getBool(key) ?? defValue;
  }

  Future<bool?> removePreference(String key) async {
    return _preferences?.remove(key);
  }

  static setAppId(String s) {}

  static promptUserForPushNotificationPermission() {}

  static getDeviceState() {}

  static disablePush(bool bool) {}

  static void setLogLevel(OSLogLevel verbose, OSLogLevel none) {}
  
}
