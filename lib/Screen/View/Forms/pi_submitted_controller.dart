import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // ✅ For date parsing
import 'package:sp_manage_system/API/Service/base_service.dart';

class PiSubmittedController extends GetxController {
  var isLoading = false.obs;
  var submittedList = [].obs;

  // Filters
  var filteredList = [].obs;
  var selectedDate = Rxn<DateTime>();
  TextEditingController searchController = TextEditingController();

  Future<void> fetchSubmittedForms() async {
    isLoading(true);
    try {
      final uri = Uri.parse(ApiRouts.getVisitorRecords);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          List records = data['visitor_records'] ?? [];
          submittedList.value = records
              .where((e) => e['status'] == 'bhetichi_vel_nishcit')
              .toList();
          applyFilters();
        } else {
          Get.snackbar("त्रुटी", data['message'] ?? "डेटा मिळाला नाही");
        }
      } else {
        Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void applyFilters() {
    List temp = submittedList;

    // 🔍 Search filter
    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      temp = temp.where((e) {
        final name = (e['name'] ?? '').toString().toLowerCase();
        final police = (e['police_station_name'] ?? '').toString().toLowerCase();
        return name.contains(query) || police.contains(query);
      }).toList();
    }

    // 📅 Date filter (backend gives dd/MM/yyyy)
    if (selectedDate.value != null) {
      temp = temp.where((e) {
        final dateStr = e['date'] ?? '';
        if (dateStr.isEmpty) return false;

        try {
          final visitDate = DateFormat("dd/MM/yyyy").parse(dateStr);
          return visitDate.year == selectedDate.value!.year &&
              visitDate.month == selectedDate.value!.month &&
              visitDate.day == selectedDate.value!.day;
        } catch (_) {
          return false; // ignore invalid date formats
        }
      }).toList();
    }

    filteredList.value = temp;
  }
}













// // lib/Screen/View/Forms/pi_submitted_controller.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class PiSubmittedController extends GetxController {
//   var isLoading = false.obs;
//   var submittedList = [].obs;

//   // Filters
//   var filteredList = [].obs;
//   var selectedDate = Rxn<DateTime>();
//   TextEditingController searchController = TextEditingController();

//   Future<void> fetchSubmittedForms() async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.getVisitorRecords);
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           List records = data['visitor_records'] ?? [];
//           submittedList.value = records
//               .where((e) => e['status'] == 'bhetichi_vel_nishcit')
//               .toList();
//           applyFilters();
//         } else {
//           Get.snackbar("त्रुटी", data['message'] ?? "डेटा मिळाला नाही");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   void applyFilters() {
//     List temp = submittedList;

//     // 🔍 Search filter
//     if (searchController.text.isNotEmpty) {
//       final query = searchController.text.toLowerCase();
//       temp = temp.where((e) {
//         final name = (e['name'] ?? '').toString().toLowerCase();
//         final police = (e['police_station_name'] ?? '').toString().toLowerCase();
//         return name.contains(query) || police.contains(query);
//       }).toList();
//     }

//     // 📅 Date filter (parse backend date and compare)
//     if (selectedDate.value != null) {
//       temp = temp.where((e) {
//         final dateStr = e['date'] ?? '';
//         if (dateStr.isEmpty) return false;

//         try {
//           final visitDate = DateTime.parse(dateStr);
//           return visitDate.year == selectedDate.value!.year &&
//               visitDate.month == selectedDate.value!.month &&
//               visitDate.day == selectedDate.value!.day;
//         } catch (_) {
//           return false; // ignore invalid date formats
//         }
//       }).toList();
//     }

//     filteredList.value = temp;
//   }
// }


















// // lib/Screen/View/Forms/pi_submitted_controller.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class PiSubmittedController extends GetxController {
//   var isLoading = false.obs;
//   var submittedList = [].obs;

//   // Filters
//   var filteredList = [].obs;
//   var selectedDate = Rxn<DateTime>();
//   TextEditingController searchController = TextEditingController();

//   Future<void> fetchSubmittedForms() async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.getVisitorRecords);
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           List records = data['visitor_records'] ?? [];
//           submittedList.value = records
//               .where((e) => e['status'] == 'bhetichi_vel_nishcit')
//               .toList();
//           applyFilters();
//         } else {
//           Get.snackbar("त्रुटी", data['message'] ?? "डेटा मिळाला नाही");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   void applyFilters() {
//     List temp = submittedList;

//     // 🔍 Search filter
//     if (searchController.text.isNotEmpty) {
//       final query = searchController.text.toLowerCase();
//       temp = temp.where((e) {
//         final name = (e['name'] ?? '').toString().toLowerCase();
//         final police = (e['police_station_name'] ?? '').toString().toLowerCase();
//         return name.contains(query) || police.contains(query);
//       }).toList();
//     }

//     // 📅 Date filter (assuming backend sends "date" as yyyy-MM-dd)
//     if (selectedDate.value != null) {
//       final filterDate =
//           "${selectedDate.value!.year.toString().padLeft(4, '0')}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
//       temp = temp.where((e) => e['date'] == filterDate).toList();
//     }

//     filteredList.value = temp;
//   }
// }





















// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class PiSubmittedController extends GetxController {
//   var isLoading = false.obs;
//   var submittedList = [].obs;

//   Future<void> fetchSubmittedForms() async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.getVisitorRecords);
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == "success") {
//           // filter only bhetichi_vel_nishcit
//           List records = data['visitor_records'] ?? [];
//           submittedList.value = records
//               .where((e) => e['status'] == 'bhetichi_vel_nishcit')
//               .toList();
//         } else {
//           Get.snackbar("त्रुटी", data['message'] ?? "डेटा मिळाला नाही");
//         }
//       } else {
//         Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
// }










