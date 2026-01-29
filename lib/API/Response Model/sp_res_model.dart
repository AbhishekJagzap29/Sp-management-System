import 'dart:convert';

SpResponseModel spResponseModelFromJson(String str) =>
    SpResponseModel.fromJson(json.decode(str));

String spResponseModelToJson(SpResponseModel data) =>
    json.encode(data.toJson());

class SpResponseModel {
  final String status;
  final String message;
  final int totalSp;
  final List<SpOfficer> spOfficers;

  SpResponseModel({
    required this.status,
    required this.message,
    required this.totalSp,
    required this.spOfficers,
  });

  factory SpResponseModel.fromJson(Map<String, dynamic> json) {
    return SpResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      totalSp: json['total_sp'] ?? 0,
      spOfficers: json['sp_officers'] != null
          ? List<SpOfficer>.from(
              json['sp_officers'].map((x) => SpOfficer.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'total_sp': totalSp,
        'sp_officers': List<dynamic>.from(spOfficers.map((x) => x.toJson())),
      };
}

class SpOfficer {
  final int spId;
  final String spName;

  SpOfficer({
    required this.spId,
    required this.spName,
  });

  factory SpOfficer.fromJson(Map<String, dynamic> json) {
    return SpOfficer(
      spId: json['sp_id'] ?? 0,
      spName: json['sp_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'sp_id': spId,
        'sp_name': spName,
      };
}
