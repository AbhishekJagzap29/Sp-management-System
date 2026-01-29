import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // ✅ For parsing dd/MM/yyyy
import 'package:sp_manage_system/API/Service/base_service.dart';

class Visitor {
  final int id;
  final String name;
  final String? officerToMeet;
  final String? policeStation;
  final String status;
  final String? date; // ✅ For filtering

  Visitor({
    required this.id,
    required this.name,
    this.officerToMeet,
    this.policeStation,
    required this.status,
    this.date,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['visitor_id'] ?? 0,
      name: json['name'] ?? '',
      officerToMeet: json['officer_to_meet_name'] ?? '',
      policeStation: json['police_station_name'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '', // ✅ Backend provides dd/MM/yyyy
    );
  }
}

class PiVisitController extends GetxController {
  var isLoading = false.obs;
  var visitors = <Visitor>[].obs;
  var filteredVisitors = <Visitor>[].obs;

  var selectedDate = Rxn<DateTime>();
  final searchController = TextEditingController();

  Future<void> fetchVisitors() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(ApiRouts.getVisitorRecords));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success" && data["visitor_records"] != null) {
          final allVisitors = (data["visitor_records"] as List)
              .map((e) => Visitor.fromJson(e))
              .toList();

          visitors.value = allVisitors
              .where((v) => v.status.toLowerCase() == "assigned")
              .toList();

          applyFilters();
        } else {
          visitors.clear();
          filteredVisitors.clear();
          Get.snackbar("Error", "No visitor records found.");
        }
      } else {
        visitors.clear();
        filteredVisitors.clear();
        Get.snackbar("Error", "Failed to fetch visitors");
      }
    } catch (e) {
      visitors.clear();
      filteredVisitors.clear();
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// 🔍 Apply search & date filter
  void applyFilters() {
    String query = searchController.text.toLowerCase();

    filteredVisitors.value = visitors.where((v) {
      bool matchesSearch = v.name.toLowerCase().contains(query) ||
          (v.policeStation?.toLowerCase().contains(query) ?? false);

      bool matchesDate = true;
      if (selectedDate.value != null && v.date != null && v.date!.isNotEmpty) {
        try {
          // ✅ Backend gives dd/MM/yyyy
          DateTime visitDate = DateFormat("dd/MM/yyyy").parse(v.date!);
          matchesDate = visitDate.year == selectedDate.value!.year &&
              visitDate.month == selectedDate.value!.month &&
              visitDate.day == selectedDate.value!.day;
        } catch (_) {
          matchesDate = false; // ignore invalid dates
        }
      }

      return matchesSearch && matchesDate;
    }).toList();
  }
}














// // lib/Screen/View/Forms/pi_visit_form_controller.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class Visitor {
//   final int id;
//   final String name;
//   final String? officerToMeet;
//   final String? policeStation;
//   final String status;
//   final String? date; // ✅ Added for filtering

//   Visitor({
//     required this.id,
//     required this.name,
//     this.officerToMeet,
//     this.policeStation,
//     required this.status,
//     this.date,
//   });

//   factory Visitor.fromJson(Map<String, dynamic> json) {
//     return Visitor(
//       id: json['visitor_id'] ?? 0,
//       name: json['name'] ?? '',
//       officerToMeet: json['officer_to_meet_name'] ?? '',
//       policeStation: json['police_station_name'] ?? '',
//       status: json['status'] ?? '',
//       date: json['date'] ?? '', // ✅ Backend must provide date field
//     );
//   }
// }

// class PiVisitController extends GetxController {
//   var isLoading = false.obs;
//   var visitors = <Visitor>[].obs;
//   var filteredVisitors = <Visitor>[].obs;

//   var selectedDate = Rxn<DateTime>();
//   final searchController = TextEditingController();

//   Future<void> fetchVisitors() async {
//     try {
//       isLoading(true);
//       final response = await http.get(Uri.parse(ApiRouts.getVisitorRecords));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data["status"] == "success" && data["visitor_records"] != null) {
//           final allVisitors = (data["visitor_records"] as List)
//               .map((e) => Visitor.fromJson(e))
//               .toList();

//           visitors.value = allVisitors
//               .where((v) =>
//                   v.status.toLowerCase() == "assigned") // only assigned
//               .toList();

//           applyFilters();
//         } else {
//           visitors.clear();
//           filteredVisitors.clear();
//           Get.snackbar("Error", "No visitor records found.");
//         }
//       } else {
//         visitors.clear();
//         filteredVisitors.clear();
//         Get.snackbar("Error", "Failed to fetch visitors");
//       }
//     } catch (e) {
//       visitors.clear();
//       filteredVisitors.clear();
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   /// 🔍 Apply search & date filter
//   void applyFilters() {
//     String query = searchController.text.toLowerCase();

//     filteredVisitors.value = visitors.where((v) {
//       bool matchesSearch = v.name.toLowerCase().contains(query) ||
//           (v.policeStation?.toLowerCase().contains(query) ?? false);

//       bool matchesDate = true;
//       if (selectedDate.value != null && v.date != null && v.date!.isNotEmpty) {
//         try {
//           DateTime visitDate = DateTime.parse(v.date!);
//           matchesDate = visitDate.year == selectedDate.value!.year &&
//               visitDate.month == selectedDate.value!.month &&
//               visitDate.day == selectedDate.value!.day;
//         } catch (_) {
//           matchesDate = true; // ignore if date parse fails
//         }
//       }

//       return matchesSearch && matchesDate;
//     }).toList();
//   }
// }

















// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Service/base_service.dart';

// class Visitor {
//   final int id;
//   final String name;
//   final String? officerToMeet;
//   final String? policeStation;
//   final String status;

//   Visitor({
//     required this.id,
//     required this.name,
//     this.officerToMeet,
//     this.policeStation,
//     required this.status,
//   });

//   factory Visitor.fromJson(Map<String, dynamic> json) {
//     return Visitor(
//       id: json['visitor_id'] ?? 0,
//       name: json['name'] ?? '',
//       officerToMeet: json['officer_to_meet_name'] ?? '',
//       policeStation: json['police_station_name'] ?? '',
//       status: json['status'] ?? '',
//     );
//   }
// }

// class PiVisitController extends GetxController {
//   var isLoading = false.obs;
//   var visitors = <Visitor>[].obs;

//   Future<void> fetchVisitors() async {
//     try {
//       isLoading(true);
//       final response = await http.get(Uri.parse(ApiRouts.getVisitorRecords));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data["status"] == "success" && data["visitor_records"] != null) {
//           final allVisitors = (data["visitor_records"] as List)
//               .map((e) => Visitor.fromJson(e))
//               .toList();

//           /// ✅ Case-insensitive filtering
//           visitors.value = allVisitors
//               .where((v) => v.status.toLowerCase() == "Assigned".toLowerCase())
//               .toList();

//           if (visitors.isEmpty) {
//             Get.snackbar("No Data", "No Assigned visitors found.");
//           }
//         } else {
//           visitors.clear();
//           Get.snackbar("Error", "No visitor records found.");
//         }
//       } else {
//         visitors.clear();
//         Get.snackbar("Error", "Failed to fetch visitors");
//       }
//     } catch (e) {
//       visitors.clear();
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
// }

