import 'dart:convert';

TimeSlotResponseModel timeSlotResponseModelFromJson(String str) =>
    TimeSlotResponseModel.fromJson(json.decode(str));

String timeSlotResponseModelToJson(TimeSlotResponseModel data) =>
    json.encode(data.toJson());

class TimeSlotResponseModel {
  final String status;
  final int count;
  final List<TimeSlot> data;
  final String? message;

  TimeSlotResponseModel({
    required this.status,
    required this.count,
    required this.data,
    this.message,
  });

  factory TimeSlotResponseModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotResponseModel(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
      data: json['data'] != null
          ? List<TimeSlot>.from(
              json['data'].map((x) => TimeSlot.fromJson(x)))
          : [],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'count': count,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
        'message': message,
      };
}

class TimeSlot {
  final String value;
  final String label;  

  TimeSlot({
    required this.value,
    required this.label,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
      };
}
