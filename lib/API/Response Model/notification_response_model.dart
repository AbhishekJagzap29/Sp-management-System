import 'dart:convert';

NotificationResponseModel notificationResponseModelFromJson(String str) =>
    NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) =>
    json.encode(data.toJson());

class NotificationResponseModel {
  final List<NotificationModel> notifications;

  NotificationResponseModel({
    required this.notifications,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      notifications: json['result'] != null
          ? List<NotificationModel>.from(
              json['result'].map((x) => NotificationModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'result': List<dynamic>.from(notifications.map((x) => x.toJson())),
      };
}

class NotificationModel {
  final String title;
  final String message;
  final String date;
  final int? visitorId; 

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
    required this.visitorId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    dynamic visitorIdRaw = json['visitor_id'];

    int? visitorIdParsed;
    if (visitorIdRaw is int) {
      visitorIdParsed = visitorIdRaw;
    } else if (visitorIdRaw is String) {
      visitorIdParsed = int.tryParse(visitorIdRaw);
    } else {
      visitorIdParsed = null;
    }

    return NotificationModel(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      visitorId: visitorIdParsed, 
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'date': date,
        'visitor_id': visitorId,
      };
}



















// import 'dart:convert';

// NotificationResponseModel notificationResponseModelFromJson(String str) =>
//     NotificationResponseModel.fromJson(json.decode(str));

// String notificationResponseModelToJson(NotificationResponseModel data) =>
//     json.encode(data.toJson());

// class NotificationResponseModel {
//   final List<NotificationModel> notifications;

//   NotificationResponseModel({
//     required this.notifications,
//   });

//   factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
//     return NotificationResponseModel(
//       notifications: json['result'] != null
//           ? List<NotificationModel>.from(
//               json['result'].map((x) => NotificationModel.fromJson(x)))
//           : [],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'result': List<dynamic>.from(notifications.map((x) => x.toJson())),
//       };
// }
// class NotificationModel {
//   final String title;
//   final String message;
//   final String date;
//   final int? complaintId;  // Nullable for invalid or missing IDs

//   NotificationModel({
//     required this.title,
//     required this.message,
//     required this.date,
//     required this.complaintId,
//   });

//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     dynamic complaintIdRaw = json['complaint_id'];

//     int? complaintIdParsed;
//     if (complaintIdRaw is int) {
//       complaintIdParsed = complaintIdRaw;
//     } else if (complaintIdRaw is String) {
//       complaintIdParsed = int.tryParse(complaintIdRaw);
//     } else {
//       complaintIdParsed = null; // Handles 'false' or unexpected types
//     }

//     return NotificationModel(
//       title: json['title'] ?? '',
//       message: json['message'] ?? '',
//       date: json['date'] ?? '',
//       complaintId: complaintIdParsed,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'message': message,
//         'date': date,
//         'complaint_id': complaintId,
//       };
// }
