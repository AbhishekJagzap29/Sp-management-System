import 'dart:developer';
import 'package:sp_manage_system/API/Response%20Model/notification_response_model.dart';
import 'package:sp_manage_system/API/Service/api_service.dart';
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';

class NotificationRepo {
  Map<String, String> header1 = {
    'Content-Type': 'application/json',
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };

  /// GET NOTIFICATION PROJECT DETAILS ::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> notificationRepo() async {
    var response = await APIService().getResponse(
      url: ApiRouts.notification,
      apiType: APIType.aPost,
      body: {},
      header: header1,
    );

    log('notificationResponseModel --- response>> $response');

    NotificationResponseModel notificationResponseModel =
        NotificationResponseModel.fromJson(response);

    return notificationResponseModel;
  }
  }

