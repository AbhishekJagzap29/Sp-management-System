import 'dart:convert';                      //------------------------------corrected without history button
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';

class SpVisitorControllerForm extends GetxController {
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var visitorData = <String, dynamic>{}.obs;

  var isItarSelected = false.obs;

  // Display values
  var selectedNiyuktAdhikari = "".obs;
  var selectedOtherOfficer = "".obs;

  // Store IDs for API
  var selectedNiyuktAdhikariId = "".obs;
  var selectedOtherOfficerId = "".obs;

  var submitSuccess = false.obs;

  TextEditingController soochnaController = TextEditingController();

  var officers = <Map<String, dynamic>>[].obs;
  var otherOfficers = <Map<String, dynamic>>[].obs;

  Future<void> fetchVisitorForm(int visitorId) async {
    isLoading(true);
    try {
      final uri = Uri.parse(ApiRouts.getVisitorForm);
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"visitor_id": visitorId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          visitorData.value = Map<String, dynamic>.from(data['visitor_data'] ?? {});
          final policeStationId = visitorData['police_station_id'];
          if (policeStationId != null) await fetchOfficers(policeStationId);
        } else {
          Get.snackbar("Error", data['message'] ?? "डेटा लोड करण्यात अयशस्वी");
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOfficers(dynamic policeStationId) async {
    try {
      final stationId = policeStationId is int
          ? policeStationId
          : int.tryParse(policeStationId.toString());
      if (stationId == null) return;

      final uri = Uri.parse(ApiRouts.getOfficersByStation);
      final response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"police_station_id": stationId}));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        officers.value = List<Map<String, dynamic>>.from(data['officers'] ?? []);
      }
    } catch (e) {
      officers.clear();
    }
  }

  Future<void> fetchOtherOfficers() async {
    try {
      final uri = Uri.parse(ApiRouts.getAllOfficers);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        otherOfficers.value = List<Map<String, dynamic>>.from(data['officers'] ?? []);
      }
    } catch (e) {
      otherOfficers.clear();
    }
  }

  Future<void> submitForm(int visitorId) async {
    if (selectedNiyuktAdhikari.value.isEmpty &&
        selectedOtherOfficer.value.isEmpty) {
      errorSnackBar("त्रुटी", "कृपया नियुक्त किंवा इतर अधिकारी निवडा");
      return;
    }
    if (soochnaController.text.trim().isEmpty) {
      errorSnackBar("त्रुटी", "कृपया सूचना भरा");
      return;
    }

    isSubmitting(true);
    try {
      final body = {
        "visitor_id": visitorId,
        "officer_id": selectedNiyuktAdhikari.value == "इतर"
            ? int.parse(selectedOtherOfficerId.value)
            : int.parse(selectedNiyuktAdhikariId.value),
        "other_officer": selectedOtherOfficer.value.isNotEmpty
            ? selectedOtherOfficer.value
            : null,
        "feedback": soochnaController.text.trim(),
      };

      final uri = Uri.parse(ApiRouts.spForm);
      final response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          successSnackBar("यशस्वी", "फॉर्म यशस्वीरीत्या समाविष्ट झाला");
          submitSuccess.value = true;
        } else {
          errorSnackBar("त्रुटी", data['message'] ?? "सबमिट झाले नाही");
        }
      } else {
        errorSnackBar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
      }
    } catch (e) {
      errorSnackBar("त्रुटी", e.toString());
    } finally {
      isSubmitting(false);
    }
  }

  @override
  void onClose() {
    soochnaController.dispose();
    super.onClose();
  }
}























// // working code -------------------------------------------------- 25/09/2025--------11.25am----------
// // lib/Screen/View/Forms/sp_form_controller.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';
// import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/sp_officer_dashboard.dart';

// class SpVisitorControllerForm extends GetxController {

//   var isLoading = false.obs;
//   var isSubmitting = false.obs;
//   var visitorData = <String, dynamic>{}.obs;
//   // inside SpVisitorControllerForm
//   var isItarSelected = false.obs;
//   var selectedOtherOfficer = "".obs;


//   // Editable fields
//   var selectedNiyuktAdhikari = "".obs;
//   TextEditingController soochnaController = TextEditingController();

//   // Officer dropdown data (list of maps: {officer_id, officer_name, ...})
//   var officers = <Map<String, dynamic>>[].obs;

//   /// Fetch visitor details by ID and then fetch officers for the visitor's police station.
//   Future<void> fetchVisitorForm(int visitorId) async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.getVisitorForm);
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"visitor_id": visitorId}),
//       );

//       // Debug
//       // print("VisitorForm Response: ${response.statusCode} - ${response.body}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           visitorData.value = Map<String, dynamic>.from(data['visitor_data'] ?? {});

//           // load officers for police station (if provided)
//           final policeStationId = visitorData['police_station_id'];
//           if (policeStationId != null) {
//             await fetchOfficers(policeStationId);
//           }
//         } else {
//           Get.snackbar("Error", data['message'] ?? "डेटा लोड करण्यात अयशस्वी");
//         }
//       } else {
//         Get.snackbar("Error", "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   /// Fetch officers list by police station id
//   Future<void> fetchOfficers(dynamic policeStationId) async {
//     try {
//       // ensure id is int or parseable
//       final stationId = policeStationId is int ? policeStationId : int.tryParse(policeStationId.toString());
//       if (stationId == null) {
//         officers.clear();
//         return;
//       }

//       final uri = Uri.parse(ApiRouts.getOfficersByStation);
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"police_station_id": stationId}),
//       );

//       // Debug
//       // print("Officers API Response: ${response.statusCode} - ${response.body}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           final list = List<Map<String, dynamic>>.from(data['officers'] ?? []);
//           officers.value = list;
//         } else {
//           officers.clear();
//           Get.snackbar("Error", data['message'] ?? "अधिकारी उपलब्ध नाहीत");
//         }
//       } else {
//         Get.snackbar("Error", "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       officers.clear();
//       Get.snackbar("Error", e.toString());
//     }
//   }
  
//   /// Submit SP feedback
// Future<void> submitForm(int visitorId) async {
//   if (selectedNiyuktAdhikari.value.isEmpty) {
//     errorSnackBar("त्रुटी", "कृपया नियुक्त अधिकारी निवडा");
//     return;
//   }
//   if (soochnaController.text.trim().isEmpty) {
//     errorSnackBar("त्रुटी", "कृपया सूचना भरा");
//     return;
//   }

//   isSubmitting(true);
//   try {
//     final body = {
//       "visitor_id": visitorId,
//       "officer_id": int.parse(selectedNiyuktAdhikari.value),
//       "feedback": soochnaController.text.trim(),
//     };

//     final uri = Uri.parse(ApiRouts.spForm);
//     final response = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == "success") {
//         //successSnackBar("यशस्वी", data['message'] ?? "सबमिट यशस्वी");
//         successSnackBar("यशस्वी", "फॉर्म यशस्वीरीत्या समाविष्ट झाला");
        
//       } else {
//         errorSnackBar("त्रुटी", data['message'] ?? "सबमिट झाले नाही");
//       }
//     } else {
//       errorSnackBar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//     }
//   } catch (e) {
//     errorSnackBar("त्रुटी", e.toString());
//   } finally {
//     isSubmitting(false);
//   }
// }


//   @override
//   void onClose() {
//     soochnaController.dispose();
//     super.onClose();
//   }
// }




















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class SpVisitorControllerForm extends GetxController {
//   var isLoading = false.obs;
//   var visitorData = {}.obs;

//   // Editable fields
//   var selectedNiyuktAdhikari = "".obs;
//   TextEditingController soochnaController = TextEditingController();

//   // Officer dropdown data
//   var officers = <Map<String, dynamic>>[].obs;

//   Future<void> fetchVisitorForm(int visitorId) async {
//   isLoading(true);
//   try {
//     final response = await http.post(
//       Uri.parse(ApiRouts.getVisitorForm),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"visitor_id": visitorId}),
//     );

//     print("VisitorForm Response: ${response.body}");

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == "success") {
//         visitorData.value = data['visitor_data'] ?? {};

//         final policeStationId = visitorData['police_station_id'];
//         print("Police Station ID: $policeStationId");   // 👈 debug
//         if (policeStationId != null) {
//           await fetchOfficers(policeStationId);
//         }
//       }
//     }
//   } catch (e) {
//     print("Error in fetchVisitorForm: $e");
//   } finally {
//     isLoading(false);
//   }
// }

//   Future<void> fetchOfficers(int policeStationId) async {
//   try {
//     print("Fetching officers for station: $policeStationId");
//     final response = await http.post(
//       Uri.parse(ApiRouts.getOfficersByStation),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"police_station_id": policeStationId}),
//     );

//     print("Officers API Response: ${response.body}");

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       if (data['status'] == "success") {
//         officers.value =
//             List<Map<String, dynamic>>.from(data['officers'] ?? []);
//       } else {
//         officers.clear();
//         Get.snackbar("Error", data['message'] ?? "अधिकारी उपलब्ध नाहीत");
//       }
//     } else {
//       Get.snackbar("Error", "Server error: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error in fetchOfficers: $e");
//     Get.snackbar("Error", e.toString());
//   }
// }

// }


