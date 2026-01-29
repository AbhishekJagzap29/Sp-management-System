import 'dart:convert';

SuccessDataResponseModel successDataResponseModelFromJson(String str) =>
    SuccessDataResponseModel.fromJson(json.decode(str));

String successDataResponseModelToJson(SuccessDataResponseModel data) =>
    json.encode(data.toJson());

class SuccessDataResponseModel {
  String? status;
  String? message;

  SuccessDataResponseModel({
    this.status,
    this.message,
  });

  factory SuccessDataResponseModel.fromJson(Map<String, dynamic> json) =>
      SuccessDataResponseModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
