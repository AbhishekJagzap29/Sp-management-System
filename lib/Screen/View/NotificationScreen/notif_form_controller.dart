import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';

class NotifFormController extends GetxController {
  var isLoading = false.obs;
  var visitorData = <String, dynamic>{}.obs;

  /// Fetch visitor details by ID
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
}
