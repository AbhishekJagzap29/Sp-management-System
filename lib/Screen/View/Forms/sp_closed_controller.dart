// lib/Screen/View/Forms/sp_closed_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sp_manage_system/API/Service/base_service.dart';

class SpClosedController extends GetxController {
  var isLoading = false.obs;
  var closedForms = <dynamic>[].obs;

  // filters
  var filteredForms = <dynamic>[].obs;
  var selectedDate = Rxn<DateTime>();
  TextEditingController searchController = TextEditingController();
  final DateFormat _dateFormat = DateFormat("dd/MM/yyyy");

  Future<void> fetchClosedForms() async {
    isLoading(true);
    try {
      final uri = Uri.parse(ApiRouts.closeFormList);
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == "success") {
          final records = List<Map<String, dynamic>>.from(
            data['visitor_records'] ?? const [],
          );
          records.sort(_compareClosedRecords);
          closedForms.value = records;
          applyFilters();
        } else {
          Get.snackbar("त्रुटी", data['message'] ?? "डेटा लोड करण्यात अयशस्वी");
        }
      } else {
        Get.snackbar("त्रुटी", "सर्व्हर त्रुटी: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("त्रुटी", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void applyFilters() {
    List temp = List.from(closedForms);

    // 🔍 Search filter
    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      temp = temp.where((e) {
        final name = (e['name'] ?? '').toString().toLowerCase();
        final police =
            (e['police_station_name'] ?? '').toString().toLowerCase();
        return name.contains(query) || police.contains(query);
      }).toList();
    }

    // 📅 Date filter (parse dd/MM/yyyy safely)
    if (selectedDate.value != null) {
      final filterDate = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
      );

      temp = temp.where((e) {
        if (e['date'] == null || e['date'].toString().isEmpty) return false;

        try {
          DateTime parsedDate = _dateFormat.parse(e['date'].toString());
          final onlyDate =
              DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
          return onlyDate == filterDate;
        } catch (_) {
          return false; // ignore invalid format
        }
      }).toList();
    }

    filteredForms.value = temp;
  }

  int _compareClosedRecords(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final dateA = _parseRecordDate(a);
    final dateB = _parseRecordDate(b);

    if (dateA != null && dateB != null) {
      final byDate = dateB.compareTo(dateA);
      if (byDate != 0) return byDate;
    } else if (dateA != null) {
      return -1;
    } else if (dateB != null) {
      return 1;
    }

    final idA = _parseRecordId(a);
    final idB = _parseRecordId(b);
    return idB.compareTo(idA);
  }

  DateTime? _parseRecordDate(Map<String, dynamic> record) {
    final dateValue = record['date']?.toString();
    if (dateValue == null || dateValue.isEmpty) return null;

    try {
      return _dateFormat.parse(dateValue);
    } catch (_) {
      return null;
    }
  }

  int _parseRecordId(Map<String, dynamic> record) {
    final idValue = record['id'] ?? record['visitor_id'] ?? record['sequence_number'];
    return int.tryParse(idValue?.toString() ?? '') ?? 0;
  }
}





















// // lib/Screen/View/Forms/sp_closed_controller.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class SpClosedController extends GetxController {
//   var isLoading = false.obs;
//   var closedForms = <dynamic>[].obs;

//   // filters
//   var filteredForms = <dynamic>[].obs;
//   var selectedDate = Rxn<DateTime>();
//   TextEditingController searchController = TextEditingController();

//   Future<void> fetchClosedForms() async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.closeFormList);
//       final response = await http.get(uri, headers: {
//         "Content-Type": "application/json",
//       });

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == "success") {
//           closedForms.value = data['visitor_records'] ?? [];
//           applyFilters();
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

//   void applyFilters() {
//     List temp = closedForms;

//     // 🔍 Search filter
//     if (searchController.text.isNotEmpty) {
//       final query = searchController.text.toLowerCase();
//       temp = temp.where((e) {
//         final name = (e['name'] ?? '').toString().toLowerCase();
//         final police =
//             (e['police_station_name'] ?? '').toString().toLowerCase();
//         return name.contains(query) || police.contains(query);
//       }).toList();
//     }

//     // 📅 Date filter (parse API date safely)
//     if (selectedDate.value != null) {
//       final filterDate = DateTime(
//         selectedDate.value!.year,
//         selectedDate.value!.month,
//         selectedDate.value!.day,
//       );

//       temp = temp.where((e) {
//         if (e['date'] == null || e['date'].toString().isEmpty) return false;

//         try {
//           DateTime parsedDate = DateTime.parse(e['date'].toString());
//           final onlyDate =
//               DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
//           return onlyDate == filterDate;
//         } catch (_) {
//           return false; // ignore invalid format
//         }
//       }).toList();
//     }

//     filteredForms.value = temp;
//   }
// }
















// // lib/Screen/View/Forms/sp_closed_controller.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class SpClosedController extends GetxController {
//   var isLoading = false.obs;
//   var closedForms = <dynamic>[].obs;

//   // filters
//   var filteredForms = <dynamic>[].obs;
//   var selectedDate = Rxn<DateTime>();
//   TextEditingController searchController = TextEditingController();

//   Future<void> fetchClosedForms() async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.closeFormList);
//       final response = await http.get(uri, headers: {
//         "Content-Type": "application/json",
//       });

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == "success") {
//           closedForms.value = data['visitor_records'] ?? [];
//           applyFilters();
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

//   void applyFilters() {
//     List temp = closedForms;

//     // 🔍 Search filter
//     if (searchController.text.isNotEmpty) {
//       final query = searchController.text.toLowerCase();
//       temp = temp.where((e) {
//         final name = (e['name'] ?? '').toString().toLowerCase();
//         final police = (e['police_station_name'] ?? '').toString().toLowerCase();
//         return name.contains(query) || police.contains(query);
//       }).toList();
//     }

//     // 📅 Date filter (assuming API returns `date` in yyyy-MM-dd format)
//     if (selectedDate.value != null) {
//       final filterDate =
//           "${selectedDate.value!.year.toString().padLeft(4, '0')}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
//       temp = temp.where((e) => e['date'] == filterDate).toList();
//     }

//     filteredForms.value = temp;
//   }
// }



















// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class SpClosedController extends GetxController {
//   var isLoading = false.obs;
//   var closedForms = <dynamic>[].obs;

//   Future<void> fetchClosedForms() async {
//     isLoading(true);
//     try {
//       final uri = Uri.parse(ApiRouts.closeFormList); // ✅ Use correct API
//       final response = await http.get(uri, headers: {
//         "Content-Type": "application/json",
//       });

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == "success") {
//           // Backend already returns only closed records
//           closedForms.value = data['visitor_records'] ?? [];
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
// }






