import 'dart:developer';
import 'package:get/get.dart';
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/API/Repo/notification_repo.dart';
import 'package:sp_manage_system/API/Response%20Model/notification_response_model.dart';

class NotificationController extends GetxController {
  NotificationResponseModel? notificationData;

  ApiResponse _notificationResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get notificationResponse => _notificationResponse;

  Future<void> fetchNotifications() async {
    _notificationResponse =
        ApiResponse.loading(message: 'Fetching notifications...');
    update();

    try {
      var response = await NotificationRepo().notificationRepo();
      if (response is NotificationResponseModel) {
        response.notifications.sort((a, b) {
          DateTime da = DateTime.parse(a.date).toUtc();
          DateTime db = DateTime.parse(b.date).toUtc();
          return db.compareTo(da);
        });
        notificationData = response;
        _notificationResponse = ApiResponse.complete(response);
        log('Notifications fetched and sorted successfully');
      } else {
        _notificationResponse =
            ApiResponse.error(message: 'Invalid response format');
      }
    } catch (e) {
      _notificationResponse = ApiResponse.error(message: e.toString());
      log('Error fetching notifications: $e');
    }
    update();
  }
}
