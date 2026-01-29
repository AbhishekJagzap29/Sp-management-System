import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:intl/intl.dart';

class VisitFormController extends GetxController {
  var visitors = <Map<String, dynamic>>[].obs;
  var filteredVisitors = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  var selectedDate = Rxn<DateTime>();
  TextEditingController searchController = TextEditingController();

  var statusOptions = <String>[].obs; // ✅ Unique statuses
  var selectedStatus = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchVisitors();
  }

  Future<void> fetchVisitors() async {
    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse(ApiRouts.getVisitorRecords));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == "success") {
          visitors.value =
              List<Map<String, dynamic>>.from(data['visitor_records']);

          // ✅ Extract unique statuses (capitalized + replace special case)
          final uniqueStatuses = visitors
              .map((e) {
                String status = (e['status'] ?? '').toString().capitalizeFirst ?? "";
                if (status.toLowerCase() == "bhetichi_vel_nishchit") {
                  status = "Bhetichi vel Nishchit";
                }
                return status;
              })
              .where((status) => status.isNotEmpty)
              .toSet()
              .toList();

          statusOptions.assignAll(uniqueStatuses);

          applyFilters();
        } else {
          visitors.clear();
          filteredVisitors.clear();
          Get.snackbar("Error", data['message'] ?? "Failed to load visitors");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Map<String, dynamic>> temp = List.from(visitors);

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

    // 📅 Date filter (backend format = dd/MM/yyyy)
    if (selectedDate.value != null) {
      final filterDate = DateFormat("dd/MM/yyyy").format(selectedDate.value!);
      temp = temp.where((e) {
        final recordDateStr = e['date']?.toString();
        if (recordDateStr == null || recordDateStr.isEmpty) return false;

        try {
          final recordDate =
              DateFormat("dd/MM/yyyy").parseStrict(recordDateStr);
          return DateFormat("dd/MM/yyyy").format(recordDate) == filterDate;
        } catch (_) {
          return false;
        }
      }).toList();
    }

    // ✅ Status filter
    if (selectedStatus.value != null) {
      temp = temp.where((e) {
        String status = (e['status'] ?? '').toString().capitalizeFirst ?? "";
        if (status.toLowerCase() == "bhetichi_vel_nishchit") {
          status = "Bhetichi vel Nishchit";
        }
        return status == selectedStatus.value;
      }).toList();
    }

    filteredVisitors.value = temp;
  }
}
















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';
// import 'package:intl/intl.dart';

// class VisitFormController extends GetxController {
//   var visitors = <Map<String, dynamic>>[].obs;
//   var filteredVisitors = <Map<String, dynamic>>[].obs;
//   var isLoading = false.obs;

//   var selectedDate = Rxn<DateTime>();
//   TextEditingController searchController = TextEditingController();

//   var statusOptions = <String>[].obs; // ✅ Unique statuses
//   var selectedStatus = Rxn<String>();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchVisitors();
//   }

//   Future<void> fetchVisitors() async {
//     try {
//       isLoading.value = true;

//       final response = await http.get(Uri.parse(ApiRouts.getVisitorRecords));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == "success") {
//           visitors.value =
//               List<Map<String, dynamic>>.from(data['visitor_records']);

//           // ✅ Extract unique statuses (capitalized + replace special case)
//           final uniqueStatuses = visitors
//               .map((e) {
//                 String status = (e['status'] ?? '').toString().capitalizeFirst ?? "";
//                 if (status.toLowerCase() == "bhetichi_vel_nishchit") {
//                   status = "Bhetichi vel Nishchit";
//                 }
//                 return status;
//               })
//               .where((status) => status.isNotEmpty)
//               .toSet()
//               .toList();

//           statusOptions.assignAll(uniqueStatuses);

//           applyFilters();
//         } else {
//           visitors.clear();
//           filteredVisitors.clear();
//           Get.snackbar("Error", data['message'] ?? "Failed to load visitors");
//         }
//       } else {
//         Get.snackbar("Error", "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void applyFilters() {
//     List<Map<String, dynamic>> temp = List.from(visitors);

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

//     // 📅 Date filter (compare only yyyy-MM-dd part)
//     if (selectedDate.value != null) {
//       final filterDate = DateFormat("yyyy-MM-dd").format(selectedDate.value!);
//       temp = temp.where((e) {
//         final recordDateStr = e['date']?.toString();
//         if (recordDateStr == null || recordDateStr.isEmpty) return false;

//         try {
//           // normalize record date
//           final recordDate = DateTime.tryParse(recordDateStr);
//           if (recordDate != null) {
//             return DateFormat("yyyy-MM-dd").format(recordDate) == filterDate;
//           } else {
//             // if already a string yyyy-MM-dd
//             return recordDateStr == filterDate;
//           }
//         } catch (_) {
//           return false;
//         }
//       }).toList();
//     }

//     // ✅ Status filter
//     if (selectedStatus.value != null) {
//       temp = temp.where((e) {
//         String status = (e['status'] ?? '').toString().capitalizeFirst ?? "";
//         if (status.toLowerCase() == "bhetichi_vel_nishchit") {
//           status = "Bhetichi vel Nishchit";
//         }
//         return status == selectedStatus.value;
//       }).toList();
//     }

//     filteredVisitors.value = temp;
//   }
// }



















// // lib/Screen/View/Forms/sp_visit_form_controller.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class VisitFormController extends GetxController {
//   var visitors = <Map<String, dynamic>>[].obs;
//   var filteredVisitors = <Map<String, dynamic>>[].obs;
//   var isLoading = false.obs;

//   var selectedDate = Rxn<DateTime>();
//   TextEditingController searchController = TextEditingController();

//   var statusOptions = <String>[].obs; // ✅ Unique statuses
//   var selectedStatus = Rxn<String>();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchVisitors();
//   }

//   Future<void> fetchVisitors() async {
//     try {
//       isLoading.value = true;

//       final response = await http.get(Uri.parse(ApiRouts.getVisitorRecords));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == "success") {
//           visitors.value =
//               List<Map<String, dynamic>>.from(data['visitor_records']);

//           // ✅ Extract unique statuses (capitalized)
//           final uniqueStatuses = visitors
//               .map((e) => (e['status'] ?? '').toString().capitalizeFirst!)
//               .where((status) => status.isNotEmpty)
//               .toSet()
//               .toList();
//           statusOptions.assignAll(uniqueStatuses);

//           applyFilters();
//         } else {
//           visitors.clear();
//           filteredVisitors.clear();
//           Get.snackbar("Error", data['message'] ?? "Failed to load visitors");
//         }
//       } else {
//         Get.snackbar("Error", "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void applyFilters() {
//     List<Map<String, dynamic>> temp = List.from(visitors);

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

//     // 📅 Date filter
//     if (selectedDate.value != null) {
//       final filterDate =
//           "${selectedDate.value!.year.toString().padLeft(4, '0')}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
//       temp = temp.where((e) => e['date'] == filterDate).toList();
//     }

//     // ✅ Status filter
//     if (selectedStatus.value != null) {
//       temp = temp.where((e) {
//         final status = (e['status'] ?? '').toString().capitalizeFirst!;
//         return status == selectedStatus.value;
//       }).toList();
//     }

//     filteredVisitors.value = temp;
//   }
// }






















// // lib/Screen/View/Forms/sp_visit_form_controller.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class VisitFormController extends GetxController {
//   var visitors = <Map<String, dynamic>>[].obs;
//   var filteredVisitors = <Map<String, dynamic>>[].obs;
//   var isLoading = false.obs;

//   var selectedDate = Rxn<DateTime>();
//   TextEditingController searchController = TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchVisitors();
//   }

//   Future<void> fetchVisitors() async {
//     try {
//       isLoading.value = true;

//       final response = await http.get(Uri.parse(ApiRouts.getVisitorRecords));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == "success") {
//           visitors.value =
//               List<Map<String, dynamic>>.from(data['visitor_records']);
//           applyFilters();
//         } else {
//           visitors.clear();
//           filteredVisitors.clear();
//           Get.snackbar("Error", data['message'] ?? "Failed to load visitors");
//         }
//       } else {
//         Get.snackbar("Error", "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void applyFilters() {
//     List<Map<String, dynamic>> temp = List.from(visitors);

//     // 🔍 Search filter
//     if (searchController.text.isNotEmpty) {
//       final query = searchController.text.toLowerCase();
//       temp = temp.where((e) {
//         final name = (e['name'] ?? '').toString().toLowerCase();
//         final police = (e['police_station_name'] ?? '').toString().toLowerCase();
//         return name.contains(query) || police.contains(query);
//       }).toList();
//     }

//     // 📅 Date filter (assuming backend sends "date" in yyyy-MM-dd format)
//     if (selectedDate.value != null) {
//       final filterDate =
//           "${selectedDate.value!.year.toString().padLeft(4, '0')}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
//       temp = temp.where((e) => e['date'] == filterDate).toList();
//     }

//     filteredVisitors.value = temp;
//   }
// }
