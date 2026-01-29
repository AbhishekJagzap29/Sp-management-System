import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart'; 

class PiSubController extends GetxController {
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var visitorData = <String, dynamic>{}.obs;

  /// Fetch visitor details
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
          visitorData.value =
              Map<String, dynamic>.from(data['visitor_data'] ?? {});
        } else {
          errorSnackBar("त्रुटी", data['message'] ?? "डेटा लोड करण्यात अयशस्वी");
        }
      } else {
        errorSnackBar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
      }
    } catch (e) {
      errorSnackBar("त्रुटी", e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Close visitor form
  Future<void> closeForm(int visitorId) async {
    isSubmitting(true);
    try {
      final uri = Uri.parse(ApiRouts.closeForm);
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"visitor_id": visitorId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          visitorData.value =
              Map<String, dynamic>.from(data['visitor_data'] ?? {});
          successSnackBar("यशस्वी", "अर्ज पूर्ण करण्यात आला आहे");

          // refresh UI after closing
          fetchVisitorForm(visitorId);
        } else {
          errorSnackBar("त्रुटी", data['message'] ?? "अर्ज बंद झाला नाही");
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
}



















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class PiSubController extends GetxController {
//   var isLoading = false.obs;
//   var isSubmitting = false.obs;
//   var visitorData = <String, dynamic>{}.obs;

//   /// Fetch visitor details
//   Future<void> fetchVisitorForm(int visitorId) async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.getVisitorForm);
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"visitor_id": visitorId}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           visitorData.value = Map<String, dynamic>.from(data['visitor_data'] ?? {});
//         } else {
//           Get.snackbar("त्रुटी", data['message'] ?? "डेटा लोड करण्यात अयशस्वी");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("त्रुटी", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   /// Close visitor form
//   Future<void> closeForm(int visitorId) async {
//     isSubmitting(true);
//     try {
//       final uri = Uri.parse(ApiRouts.closeForm);
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"visitor_id": visitorId}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           visitorData.value = Map<String, dynamic>.from(data['visitor_data'] ?? {});
//           Get.snackbar("यशस्वी", data['message'] ?? "अर्ज बंद झाला");

//           // refresh UI after closing
//           fetchVisitorForm(visitorId);
//         } else {
//           Get.snackbar("त्रुटी", data['message'] ?? "अर्ज बंद झाला नाही");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("त्रुटी", e.toString());
//     } finally {
//       isSubmitting(false);
//     }
//   }
// }



















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class PiSubController extends GetxController {
//   var isLoading = false.obs;
//   var isSubmitting = false.obs;
//   var visitorData = <String, dynamic>{}.obs;

//   /// Fetch visitor details
//   Future<void> fetchVisitorForm(int visitorId) async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.getVisitorForm);
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"visitor_id": visitorId}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           visitorData.value =
//               Map<String, dynamic>.from(data['visitor_data'] ?? {});
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

//   /// Close visitor form
//   Future<void> closeForm(int visitorId) async {
//     isSubmitting(true);
//     try {
//       final uri = Uri.parse(ApiRouts.closeForm);
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"visitor_id": visitorId}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           Get.snackbar("यशस्वी", data['message'] ?? "अर्ज बंद झाला");
//         } else {
//           Get.snackbar("त्रुटी", data['message'] ?? "अर्ज बंद झाला नाही");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("त्रुटी", e.toString());
//     } finally {
//       isSubmitting(false);
//     }
//   }
// }















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class PiSubController extends GetxController {
//   var isLoading = false.obs;
//   var isSubmitting = false.obs;
//   var visitorData = <String, dynamic>{}.obs;

//   // Dropdown field (yes/no)
//   var meetingConfirmed = "".obs;

//   // Feedback controller
//   TextEditingController soochnaController = TextEditingController();

//   /// Fetch visitor details
//   Future<void> fetchVisitorForm(int visitorId) async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.getVisitorForm);
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"visitor_id": visitorId}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           visitorData.value =
//               Map<String, dynamic>.from(data['visitor_data'] ?? {});
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

//   /// Submit form
//   Future<void> submitForm(int visitorId) async {
//     if (meetingConfirmed.value.isEmpty) {
//       Get.snackbar("त्रुटी", "कृपया 'तक्रदाराशी भेटीची तारीख' निवडा");
//       return;
//     }
//     if (soochnaController.text.trim().isEmpty) {
//       Get.snackbar("त्रुटी", "कृपया अभिप्राय भरा");
//       return;
//     }

//     String dateFixed = meetingConfirmed.value == "होय" ? "yes" : "no";

//     final body = {
//       "visitor_id": visitorId,
//       "date_fixed": dateFixed,
//       "pi_feedback": soochnaController.text.trim(),
//     };

//     isSubmitting(true);
//     try {
//       final uri = Uri.parse(ApiRouts.piForm);
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           Get.snackbar("यशस्वी", data['message'] ?? "सबमिट यशस्वी");
//         } else {
//           Get.snackbar("त्रुटी", data['message'] ?? "सबमिट झाले नाही");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("त्रुटी", e.toString());
//     } finally {
//       isSubmitting(false);
//     }
//   }

//   @override
//   void onClose() {
//     soochnaController.dispose();
//     super.onClose();
//   }
// }
