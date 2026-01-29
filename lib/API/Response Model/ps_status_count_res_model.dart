// import 'dart:convert';

// PsStatusCountResponseModel psStatusCountResponseModelFromJson(String str) =>
//     PsStatusCountResponseModel.fromJson(json.decode(str));

// String psStatusCountResponseModelToJson(PsStatusCountResponseModel data) =>
//     json.encode(data.toJson());

// class PsStatusCountResponseModel {
//   final String status;
//   final Map<String, int> data;
//   final String? message;

//   PsStatusCountResponseModel({
//     required this.status,
//     required this.data,
//     this.message,
//   });

//   factory PsStatusCountResponseModel.fromJson(Map<String, dynamic> json) {
//     return PsStatusCountResponseModel(
//       status: json['status'] ?? '',
//       data: json['data'] != null
//           ? Map<String, int>.from(
//               (json['data'] as Map).map(
//                 (key, value) => MapEntry(key.toString(), value ?? 0),
//               ),
//             )
//           : {},
//       message: json['message'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data,
//         "message": message,
//       };
// }















// // import 'dart:convert';

// // PoliceStationResponseModel policeStationResponseModelFromJson(String str) =>
// //     PoliceStationResponseModel.fromJson(json.decode(str));

// // String policeStationResponseModelToJson(PoliceStationResponseModel data) =>
// //     json.encode(data.toJson());

// // class PoliceStationResponseModel {
// //   final String status;
// //   final String? message;
// //   final List<PoliceStationData> data;

// //   PoliceStationResponseModel({
// //     required this.status,
// //     this.message,
// //     required this.data,
// //   });

// //   factory PoliceStationResponseModel.fromJson(Map<String, dynamic> json) =>
// //       PoliceStationResponseModel(
// //         status: json["status"] ?? "",
// //         message: json["message"],
// //         data: json["data"] == null
// //             ? []
// //             : List<PoliceStationData>.from(
// //                 json["data"].map((x) => PoliceStationData.fromJson(x))),
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "status": status,
// //         "message": message,
// //         "data": List<dynamic>.from(data.map((x) => x.toJson())),
// //       };
// // }

// // class PoliceStationData {
// //   final int policeStationId;
// //   final String policeStationName;

// //   PoliceStationData({
// //     required this.policeStationId,
// //     required this.policeStationName,
// //   });

// //   factory PoliceStationData.fromJson(Map<String, dynamic> json) =>
// //       PoliceStationData(
// //         policeStationId: json["police_station_id"] ?? 0,
// //         policeStationName: json["police_station_name"] ?? "",
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "police_station_id": policeStationId,
// //         "police_station_name": policeStationName,
// //       };
// // }















// // import 'dart:convert';

// // PsStatusCountResponseModel psStatusCountResponseModelFromJson(String str) =>
// //     PsStatusCountResponseModel.fromJson(json.decode(str));

// // class PsStatusCountResponseModel {
// //   final String status;
// //   final String? message;
// //   final int? policeStationId;
// //   final String? policeStationName;
// //   final Map<String, int> counts;

// //   PsStatusCountResponseModel({
// //     required this.status,
// //     this.message,
// //     this.policeStationId,
// //     this.policeStationName,
// //     required this.counts,
// //   });

// //   factory PsStatusCountResponseModel.fromJson(Map<String, dynamic> json) {
// //     return PsStatusCountResponseModel(
// //       status: json['status'] ?? '',
// //       message: json['message'],
// //       policeStationId: json['police_station_id'],
// //       policeStationName: json['police_station_name'],
// //       counts: json['counts'] != null
// //           ? Map<String, int>.from(
// //               (json['counts'] as Map).map(
// //                 (key, value) => MapEntry(key.toString(), value ?? 0),
// //               ),
// //             )
// //           : {},
// //     );
// //   }
// // }
