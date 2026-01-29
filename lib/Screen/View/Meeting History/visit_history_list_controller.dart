import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Service/base_service.dart';

class VisitHistoryListController extends GetxController {
  var isLoading = false.obs;
  var visitHistory = <Map<String, dynamic>>[].obs;
  var filteredVisitHistory = <Map<String, dynamic>>[].obs;

  /// Fetch visit history from API
  Future<void> fetchVisitHistory(String whatsappNumber) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(ApiRouts.getVisitorByWhatsapp);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"whatsapp_number": whatsappNumber}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "success") {
          visitHistory.value = List<Map<String, dynamic>>.from(data["data"]);
          filteredVisitHistory.value = visitHistory; // initialize search list
        } else {
          Get.snackbar("त्रुटी", data["message"] ?? "डेटा मिळाला नाही");
        }
      } else {
        Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("त्रुटी", "भेटीचा इतिहास आणण्यात अडचण: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter visit history by visit number
  void filterVisitHistory(String query) {
    if (query.isEmpty) {
      filteredVisitHistory.value = visitHistory;
    } else {
      filteredVisitHistory.value = visitHistory
          .where((item) => (item["sequence_number"] ?? "")
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }
}














// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class VisitHistoryListController extends GetxController {
//   var isLoading = false.obs;
//   var visitHistory = <Map<String, dynamic>>[].obs;

//   Future<void> fetchVisitHistory(String whatsappNumber) async {
//     try {
//       isLoading.value = true;

//       final url = Uri.parse(ApiRouts.getVisitorByWhatsapp);
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: json.encode({"whatsapp_number": whatsappNumber}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data["status"] == "success") {
//           visitHistory.value = List<Map<String, dynamic>>.from(data["data"]);
//         } else {
//           Get.snackbar("त्रुटी", data["message"] ?? "डेटा मिळाला नाही");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("त्रुटी", "भेटीचा इतिहास आणण्यात अडचण: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
