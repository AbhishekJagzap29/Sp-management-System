import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/sp_officer_dashboard.dart'; 

class SpReopenController extends GetxController {
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var visitorData = <String, dynamic>{}.obs;

  /// Fetch visitor details
  Future<void> fetchVisitorForm(int visitorId) async {
    isLoading(true);
    try {
      print("📤 Fetching visitor form with ID: $visitorId"); 
      final uri = Uri.parse(ApiRouts.getVisitorForm);
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"visitor_id": visitorId}),
      );
      print("📥 Response: ${response.body}"); 

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

  /// Reopen visitor form
  Future<void> reopenForm(int visitorId) async {
    isSubmitting(true);
    try {
      final uri = Uri.parse(ApiRouts.reopenForm); 
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
              
          successSnackBar("यशस्वी", "अर्ज पुन्हा उघडण्यात आला आहे");         
          //Get.offAll(() => const SpOfficerDashboardScreen(userType: "sp"));
          // Refresh UI after reopen
          fetchVisitorForm(visitorId);
        } else {
          errorSnackBar("त्रुटी", data['message'] ?? "अर्ज पुन्हा उघडला नाही");
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
