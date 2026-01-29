// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class SendOtpService {
//   final url = Uri.parse(ApiRouts.sendOtpAPI);

//   Future<Map<String, dynamic>> sendOtp({
//     required String whatsappNumber,
//     required String name,
//     required int spId,
//     required int policeStationId,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse(ApiRouts.sendOtpAPI),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "whatsapp_number": whatsappNumber,
//           "name": name,
//           "sp_id": spId,
//           "police_station_id": policeStationId,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       return data;
//     } catch (e) {
//       return {"status": "error", "message": e.toString()};
//     }
//   }
// }

