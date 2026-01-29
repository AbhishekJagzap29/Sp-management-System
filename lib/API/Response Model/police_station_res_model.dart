import 'dart:convert';

PoliceStationResponseModel policeStationResponseModelFromJson(String str) =>
    PoliceStationResponseModel.fromJson(json.decode(str));

String policeStationResponseModelToJson(PoliceStationResponseModel data) =>
    json.encode(data.toJson());

class PoliceStationResponseModel {
  final String status;
  final int count;
  final List<PoliceStation> data;
  final String? message;

  PoliceStationResponseModel({
    required this.status,
    required this.count,
    required this.data,
    this.message,
  });

  factory PoliceStationResponseModel.fromJson(Map<String, dynamic> json) {
    return PoliceStationResponseModel(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
      data: json['data'] != null
          ? List<PoliceStation>.from(
              json['data'].map((x) => PoliceStation.fromJson(x)))
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

class PoliceStation {
  final int policeStationId;
  final String policeStationName;

  PoliceStation({
    required this.policeStationId,
    required this.policeStationName,
  });

  factory PoliceStation.fromJson(Map<String, dynamic> json) {
    return PoliceStation(
      policeStationId: json['police_station_id'] ?? 0,
      policeStationName: json['police_station_name'] ?? '',
    );
  }

  get name => null;

  Map<String, dynamic> toJson() => {
        'police_station_id': policeStationId,
        'police_station_name': policeStationName,
      };
}
