import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/API/Repo/auth_repo.dart';
import 'package:sp_manage_system/API/Response%20Model/login_response_model.dart';
import 'package:sp_manage_system/API/Response%20Model/register_response_model.dart';
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
import 'package:sp_manage_system/Screen/Utils/extension.dart';
import 'package:sp_manage_system/Screen/View/Auth%20Screen/oneSignal_service.dart';
import 'package:sp_manage_system/home_screen.dart';

class AuthController extends GetxController {
  final loginEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNOController = TextEditingController();
  final userTypeController = TextEditingController();
  final passWordController = TextEditingController();

  String selectType = 'Select Type';
  bool isVisible = false;
  bool isResVisible = false;

  ApiResponse _loginApiResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get loginApiResponse => _loginApiResponse;

  void changeUserType(String value) {
    selectType = value;
    update();
  }

  void isObSecure() {
    isVisible = !isVisible;
    update();
  }

  void resIsObSecure() {
    isResVisible = !isResVisible;
    update();
  }

  Future<void> userLogin({String? screen}) async {
    hideKeyBoard(Get.overlayContext!);

    if (loginEmailController.text.isEmpty && passwordController.text.isEmpty) {
      errorSnackBar("आवश्यक माहिती", 'कृपया लॉगिन तपशील भरा');
      return;
    } else if (loginEmailController.text.isEmpty) {
      errorSnackBar("आवश्यक माहिती", 'कृपया ई-मेल पत्ता भरा');
      return;
    } else if (passwordController.text.isEmpty) {
      errorSnackBar("आवश्यक माहिती", 'कृपया पासवर्ड भरा');
      return;
    }

    _loginApiResponse = ApiResponse.loading(message: 'लोड होत आहे...');
    update();

    try {
      // Fetch Player ID before login
      final playerId = await OneSignalService().getPlayerId();
      log("🎯 Player ID fetched at login: $playerId");

      Map<String, dynamic> body = {
        "db": ApiRouts.databaseName,
        "login": loginEmailController.text.trim(),
        "password": passwordController.text.trim(),
        "player_id": playerId ?? "",
      };

      log('body==========>>>>>> $body');

      LoginResponseModel response = await AuthRepo().loginRepo(body: body);
      _loginApiResponse = ApiResponse.complete(response);

      log('response==========>>>>>> $response');

      if (response.uid != null) {
        preferences.putString(SharedPreference.isLogin, "true");
        preferences.putBool(SharedPreference.isAdmin, response.isAdmin ?? false);
        preferences.putString(SharedPreference.userLoginData, jsonEncode(response));
        preferences.putString(SharedPreference.userId, response.uid.toString());
        preferences.putString(SharedPreference.userType, response.userType ?? "");
        preferences.putString(SharedPreference.userPassword, passwordController.text.trim());
        preferences.putString(SharedPreference.userName, response.username ?? '');
        preferences.putBool(SharedPreference.del_activity_users, response.del_activity_users ?? false);

        String userType = response.userType ?? "";

        if (userType == 'pi_officer' || userType == 'sp_officer' || userType == 'officer' || userType == 'admin') {
          Get.offAll(() => HomeScreen(userType: userType));
        } else {
          errorSnackBar("लॉगिन अयशस्वी", 'वापरकर्ता प्रकार ओळखला गेला नाही');
        }

        Future.delayed(const Duration(milliseconds: 500)).then((_) =>
            successSnackBar("यशस्वी", 'स्वागत आहे, लॉगिन यशस्वी झाले'));
      } else {
        errorSnackBar("लॉगिन अयशस्वी", 'कृपया योग्य वापरकर्तानाव आणि पासवर्ड टाका');
      }
    } catch (e) {
      _loginApiResponse = ApiResponse.error(message: e.toString());
      if (e.toString().contains("No Internet access")) {
        errorSnackBar("लॉगिन अयशस्वी", "कृपया इंटरनेट सुरू करा!");
      }
      log("_loginApiResponse=ERROR=>$e");
    }

    update();
  }

  ApiResponse _signupApiResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get signupApiResponse => _signupApiResponse;

  Future<SignupResponseModel?> userSignup(SignupRequestModel data) async {
    hideKeyBoard(Get.overlayContext!);

    if (data.name.isEmpty || data.email.isEmpty || data.password.isEmpty) {
      errorSnackBar("आवश्यक माहिती", 'कृपया सर्व फील्ड भरा');
      return null;
    } else {
      _signupApiResponse = ApiResponse.loading(message: 'नोंदणी सुरू आहे...');
      update();

      try {
        Map<String, dynamic> body = {
          "name": data.name.trim(),
          "email": data.email.trim(),
          "password": data.password.trim(),
          "citizen": data.citizen,
          "officer": data.officer,
          "admin": data.admin,
        };

        log('Signup body==========>>>>>> $body');

        SignupResponseModel response = await AuthRepo().signupRepo(body: body);
        _signupApiResponse = ApiResponse.complete(response);

        return response;
      } catch (e) {
        _signupApiResponse = ApiResponse.error(message: e.toString());
        log("_signupApiResponse=ERROR=>$e");
        return null;
      } finally {
        update();
      }
    }
  }
}

















// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/API/Apis/api_response.dart';
// import 'package:sp_manage_system/API/Repo/auth_repo.dart';
// import 'package:sp_manage_system/API/Response%20Model/login_response_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/register_response_model.dart';
// import 'package:sp_manage_system/API/Service/base_service.dart';
// import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';
// import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
// import 'package:sp_manage_system/Screen/Utils/extension.dart';
// import 'package:sp_manage_system/Screen/View/Auth%20Screen/oneSignal_service.dart';
// import 'package:sp_manage_system/home_screen.dart';

// class AuthController extends GetxController {
//   final loginEmailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final mobileNOController = TextEditingController();
//   final userTypeController = TextEditingController();
//   final passWordController = TextEditingController();

//   String selectType = 'Select Type';
//   bool isVisible = false;
//   bool isResVisible = false;

//   ApiResponse _loginApiResponse =
//       ApiResponse.initial(message: 'Initialization');
//   ApiResponse get loginApiResponse => _loginApiResponse;

//   void changeUserType(String value) {
//     selectType = value;
//     update();
//   }

//   void isObSecure() {
//     isVisible = !isVisible;
//     update();
//   }

//   void resIsObSecure() {
//     isResVisible = !isResVisible;
//     update();
//   }

//   Future<void> userLogin({String? screen}) async {
//     hideKeyBoard(Get.overlayContext!);

//     if (screen == "change_password") {
//       if (preferences.getString(SharedPreference.userName)?.isEmpty ?? true) {
//         errorSnackBar("आवश्यक माहिती", 'कृपया लॉगिन तपशील भरा');
//         return;
//       } else if (preferences
//               .getString(SharedPreference.userPassword)
//               ?.isEmpty ??
//           true) {
//         errorSnackBar("आवश्यक माहिती", 'कृपया पासवर्ड भरा');
//         return;
//       } else {
//         _loginApiResponse = ApiResponse.loading(message: 'लोड होत आहे...');
//         update();

//         try {
//           Map<String, dynamic> body = {
//             "db": ApiRouts.databaseName,
//             "login": preferences.getString(SharedPreference.userName),
//             "password": preferences.getString(SharedPreference.userPassword),
//           };

//           log('body==========>>>>>> $body');

//           LoginResponseModel response = await AuthRepo().loginRepo(body: body);
//           _loginApiResponse = ApiResponse.complete(response);
//           log('response==========>>>>>> $response');

//           if (response.uid != null) {
//             preferences.putString(
//                 SharedPreference.userLoginData, jsonEncode(response));
//             preferences.putString(
//                 SharedPreference.userId, response.uid.toString());
//             preferences.putString(
//                 SharedPreference.userType, response.userType ?? "");
//             preferences.putString(
//                 SharedPreference.userName, response.username ?? '');
//           } else {
//             errorSnackBar(
//                 "लॉगिन अयशस्वी", 'कृपया योग्य वापरकर्तानाव आणि पासवर्ड टाका');
//             preferences.logOut();
//           }
//         } catch (e) {
//           _loginApiResponse = ApiResponse.error(message: e.toString());
//           if (e.toString().contains("No Internet access")) {
//             errorSnackBar("लॉगिन अयशस्वी", "कृपया इंटरनेट सुरू करा!");
//           }
//           preferences.logOut();
//           log("_loginApiResponse=ERROR=>$e");
//         }

//         update();
//         return;
//       }
//     }

//     // Default login flow
//     if (loginEmailController.text.isEmpty && passwordController.text.isEmpty) {
//       errorSnackBar("आवश्यक माहिती", 'कृपया लॉगिन तपशील भरा');
//     } else if (loginEmailController.text.isEmpty) {
//       errorSnackBar("आवश्यक माहिती", 'कृपया ई-मेल पत्ता भरा');
//     } else if (passwordController.text.isEmpty) {
//       errorSnackBar("आवश्यक माहिती", 'कृपया पासवर्ड भरा');
//     } else {
//       _loginApiResponse = ApiResponse.loading(message: 'लोड होत आहे...');
//       update();

//       try {
//         Map<String, dynamic> body = {
//           "db": ApiRouts.databaseName,
//           "login": loginEmailController.text.trim(),
//           "password": passwordController.text.trim(),
//         };

//         log('body==========>>>>>> $body');

//         LoginResponseModel response = await AuthRepo().loginRepo(body: body);
//         _loginApiResponse = ApiResponse.complete(response);

//         log('response==========>>>>>> $response');

//         if (response.uid != null) {
//           preferences.putString(SharedPreference.isLogin, "true");
//           preferences.putBool(
//               SharedPreference.isAdmin, response.isAdmin ?? false);
//           preferences.putString(
//               SharedPreference.userLoginData, jsonEncode(response));
//           preferences.putString(
//               SharedPreference.userId, response.uid.toString());
//           preferences.putString(
//               SharedPreference.userType, response.userType ?? "");
//           preferences.putString(
//               SharedPreference.userPassword, passwordController.text.trim());
//           preferences.putString(
//               SharedPreference.userName, response.username ?? '');
//           preferences.putBool(SharedPreference.del_activity_users,
//               response.del_activity_users ?? false);

//           String userType = response.userType ?? "";

//           if (userType == 'pi_officer' ||
//               userType == 'sp_officer' ||
//               userType == 'officer' ||
//               userType == 'admin') {
//             Get.offAll(() => HomeScreen(userType: userType));
//           } else {
//             errorSnackBar("लॉगिन अयशस्वी", 'वापरकर्ता प्रकार ओळखला गेला नाही');
//           }

//           Future.delayed(const Duration(milliseconds: 500)).then((_) =>
//               successSnackBar("यशस्वी", 'स्वागत आहे, लॉगिन यशस्वी झाले'));
//         } else {
//           errorSnackBar(
//               "लॉगिन अयशस्वी", 'कृपया योग्य वापरकर्तानाव आणि पासवर्ड टाका');
//         }
//       } catch (e) {
//         _loginApiResponse = ApiResponse.error(message: e.toString());
//         if (e.toString().contains("No Internet access")) {
//           errorSnackBar("लॉगिन अयशस्वी", "कृपया इंटरनेट सुरू करा!");
//         }
//         log("_loginApiResponse=ERROR=>$e");
//       }

//       update();
//     }
//   }

//   ApiResponse _signupApiResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get signupApiResponse => _signupApiResponse;

//   Future<SignupResponseModel?> userSignup(SignupRequestModel data) async {
//     hideKeyBoard(Get.overlayContext!);

//     if (data.name.isEmpty || data.email.isEmpty || data.password.isEmpty) {
//       errorSnackBar("आवश्यक माहिती", 'कृपया सर्व फील्ड भरा');
//       return null;
//     } else {
//       _signupApiResponse = ApiResponse.loading(message: 'नोंदणी सुरू आहे...');
//       update();

//       try {
//         Map<String, dynamic> body = {
//           "name": data.name.trim(),
//           "email": data.email.trim(),
//           "password": data.password.trim(),
//           "citizen": data.citizen,
//           "officer": data.officer,
//           "admin": data.admin,
//         };

//         log('Signup body==========>>>>>> $body');

//         SignupResponseModel response = await AuthRepo().signupRepo(body: body);
//         _signupApiResponse = ApiResponse.complete(response);

//         return response;
//       } catch (e) {
//         _signupApiResponse = ApiResponse.error(message: e.toString());
//         log("_signupApiResponse=ERROR=>$e");
//         return null;
//       } finally {
//         update();
//       }
//     }
//   }
// }

