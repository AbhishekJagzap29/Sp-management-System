import 'dart:convert';

SignupRequestModel signupRequestModelFromJson(String str) =>
    SignupRequestModel.fromJson(json.decode(str));

String signupRequestModelToJson(SignupRequestModel data) =>
    json.encode(data.toJson());

class SignupRequestModel {
  final String name;
  final String email;
  final String password;
  final bool citizen;
  final bool officer;
  final bool admin;

  SignupRequestModel({
    required this.name,
    required this.email,
    required this.password,
    this.citizen = true,
    this.officer = false,
    this.admin = false,
  });

  // Method to create an instance from JSON
  factory SignupRequestModel.fromJson(Map<String, dynamic> json) {
    return SignupRequestModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      citizen: json['citizen'] ?? false,
      officer: json['officer'] ?? false,
      admin: json['admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'citizen': citizen,
        'officer': officer,
        'admin': admin,
      };
}

class SignupResponseModel {
  final String status;
  final String? message;
  final int? userId;
  final List<String>? groups;

  SignupResponseModel({
    required this.status,
    this.message,
    this.userId,
    this.groups,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      status: json['status'],
      message: json['message'],
      userId: json['user_id'],
      groups: List<String>.from(json['groups'] ?? []),
    );
  }
}