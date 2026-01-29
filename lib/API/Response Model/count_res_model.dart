import 'dart:convert';

StatusCountResponseModel statusCountResponseModelFromJson(String str) =>
    StatusCountResponseModel.fromJson(json.decode(str));

String statusCountResponseModelToJson(StatusCountResponseModel data) =>
    json.encode(data.toJson());

class StatusCountResponseModel {
  final String status;
  final String? message;
  final Map<String, dynamic> counts;

  StatusCountResponseModel({
    required this.status,
    this.message,
    required this.counts,
  });

  factory StatusCountResponseModel.fromJson(Map<String, dynamic> json) {
    // Accept both "counts" and "data" keys from API
    final raw = json['counts'] ?? json['data'] ?? {};

    Map<String, dynamic> normalized = {};
    if (raw is Map) {
      raw.forEach((key, value) {
        // normalize values to int when possible (controller expects ints)
        if (value is int) {
          normalized[key.toString()] = value;
        } else if (value is num) {
          normalized[key.toString()] = value.toInt();
        } else if (value is String) {
          normalized[key.toString()] = int.tryParse(value) ?? 0;
        } else {
          normalized[key.toString()] = value;
        }
      });
    }

    return StatusCountResponseModel(
      status: json['status'] ?? '',
      message: json['message'],
      counts: normalized,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "counts": counts,
      };
}
