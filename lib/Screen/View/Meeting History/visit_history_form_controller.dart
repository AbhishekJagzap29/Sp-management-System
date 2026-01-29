import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Service/base_service.dart';

class VisitHistoryFormController extends GetxController {
  var isLoading = false.obs;
  var visitorData = {}.obs;

  Future<void> fetchVisitorForm(int visitorId) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(ApiRouts.visitorForm);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"visitor_id": visitorId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success") {
          visitorData.value = data["visitor_data"];
        } else {
          Get.snackbar("त्रुटी", data["message"] ?? "फॉर्म मिळाला नाही");
        }
      } else {
        Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("त्रुटी", "फॉर्म आणण्यात अडचण: $e");
    } finally {
      isLoading.value = false;
    }
  }
}















// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class VisitHistoryFormController extends GetxController {
//   var isLoading = false.obs;
//   var visitorData = {}.obs;

//   Future<void> fetchVisitorForm(int visitorId) async {
//     try {
//       isLoading.value = true;

//       final url = Uri.parse(ApiRouts.getVisitorForm);
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: json.encode({"visitor_id": visitorId}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data["status"] == "success") {
//           visitorData.value = data["visitor_data"] ?? {};
//         } else {
//           Get.snackbar("त्रुटी", data["message"] ?? "डेटा मिळाला नाही");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("त्रुटी", "डेटा मिळवताना अडचण: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
