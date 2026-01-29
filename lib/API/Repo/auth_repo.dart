
import 'dart:developer';

import 'package:sp_manage_system/API/Response%20Model/login_response_model.dart';
import 'package:sp_manage_system/API/Response%20Model/register_response_model.dart';
import 'package:sp_manage_system/API/Response%20Model/success_response_model.dart';
import 'package:sp_manage_system/API/Service/api_service.dart';
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';



class AuthRepo {
  Map<String, String> header = {
    'Content-Type': 'application/json',
  };
  Map<String, String> header1 = {
    'Content-Type': 'application/json',
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };

  /// LOGIN REPO

  Future<dynamic> loginRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.loginAPI,
      apiType: APIType.aPost,
      body: body,
      header: header,
    );

    log('loginResponseModel----123----response>> $response');

    LoginResponseModel loginResponseModel =
        LoginResponseModel.fromJson(response);

    log('loginResponseModel --- response>> $loginResponseModel');

    return loginResponseModel;
  }

  /// REGISTER REPO

Future<dynamic> signupRepo({Map<String, dynamic>? body}) async {
  var response = await APIService().getResponse(
    url: ApiRouts.registerAPI,
    apiType: APIType.aPost,
    body: body,
    header: header,
  );

  log('signupResponseModel --- response>> $response');

  SignupResponseModel signupResponseModel =
      SignupResponseModel.fromJson(response);

  log('signupResponseModel Parsed --- status: ${signupResponseModel.status}, message: ${signupResponseModel.message}');

  return signupResponseModel;
}


  /// ONE SIGNAL NOTIFICATION

  Future<dynamic> sendOneSignalData({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.oneSignal,
      apiType: APIType.aPost,
      body: body,
      header: header,
    );

    log('response --- response>> $response');

    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);

    log('successDataResponseModel --- response>> $successDataResponseModel');

    return successDataResponseModel;
  }
}
