import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/API/Repo/project_repo.dart';
import 'package:sp_manage_system/API/Response Model/police_station_res_model.dart';
import 'package:sp_manage_system/API/Response Model/sp_res_model.dart';
import 'package:sp_manage_system/API/Response Model/time_slot_res_model.dart';
import 'package:sp_manage_system/API/Service/base_service.dart';

class ComplaintFormController extends GetxController {
  String? selectedSpId;
  String? selectedPoliceStationId;

  List<SpOfficer> spOfficers = [];
  List<PoliceStation> policeStations = [];
  List<TimeSlot> timeSlots = [];

  /// For selected time slot
  String? selectedTimeSlotValue; // backend value
  String? selectedTimeSlotLabel; // UI label

  // Loading states
  var isLoading = false.obs;
  var isSubmitting = false.obs;

  ApiResponse _spListResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get spListResponse => _spListResponse;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        fetchSPList(),
        fetchPoliceStations(),
        fetchTimeSlots(),
      ]);
    } catch (e) {
      log("Error fetching initial data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSPList() async {
    _spListResponse = ApiResponse.loading(message: 'Loading SP list...');
    update();

    try {
      SpResponseModel? response = await ProjectRepo().spList();

      if (response != null && response.status.toLowerCase() == 'success') {
        spOfficers = response.spOfficers;
      } else {
        spOfficers = [];
      }

      _spListResponse = ApiResponse.complete(response);
    } catch (e) {
      _spListResponse = ApiResponse.error(message: e.toString());
      log("Error fetching SP list: $e");
    }

    update();
  }

  ApiResponse _policeStationResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get policeStationResponse => _policeStationResponse;

  Future<void> fetchPoliceStations() async {
    _policeStationResponse =
        ApiResponse.loading(message: 'Loading police stations...');
    update();

    try {
      PoliceStationResponseModel? response =
          await ProjectRepo().getPoliceStations();

      if (response != null && response.status.toLowerCase() == 'success') {
        policeStations = response.data;
      } else {
        policeStations = [];
      }

      _policeStationResponse = ApiResponse.complete(response);
    } catch (e) {
      _policeStationResponse = ApiResponse.error(message: e.toString());
      log("Error fetching police stations: $e");
    }
    update();
  }

  ApiResponse _timeSlotResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get timeSlotResponse => _timeSlotResponse;

  Future<void> fetchTimeSlots() async {
    _timeSlotResponse = ApiResponse.loading(message: 'Loading time slots...');
    update();

    try {
      TimeSlotResponseModel? response = await ProjectRepo().getTimeSlot();

      if (response != null && response.status.toLowerCase() == 'success') {
        timeSlots = response.data;
      } else {
        timeSlots = [];
      }

      _timeSlotResponse = ApiResponse.complete(response);
    } catch (e) {
      _timeSlotResponse = ApiResponse.error(message: e.toString());
      log("Error fetching time slots: $e");
    }

    update();
  }

  /// ✅ Create Visitor API
  Future<Map<String, dynamic>> createVisitor(Map<String, dynamic> data) async {
    try {
      isSubmitting.value = true;
      update();

      final response = await http.post(
        Uri.parse("${ApiRouts.baseUrl}/create/visitor"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result;
      } else {
        return {
          "status": "error",
          "message": "Failed with status ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    } finally {
      isSubmitting.value = false;
      update();
    }
  }

  // Method to set submitting state
  void setSubmitting(bool value) {
    isSubmitting.value = value;
    update();
  }
}























// //working with dropdown feilds------------------------------------------------------
// import 'dart:convert';
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Apis/api_response.dart';
// import 'package:sp_manage_system/API/Repo/project_repo.dart';
// import 'package:sp_manage_system/API/Response Model/police_station_res_model.dart';
// import 'package:sp_manage_system/API/Response Model/sp_res_model.dart';
// import 'package:sp_manage_system/API/Response Model/time_slot_res_model.dart';
// import 'package:sp_manage_system/API/Service/base_service.dart';
// import 'package:sp_manage_system/Screen/Utils/app_layout.dart';

// class ComplaintFormController extends GetxController {
//   String? selectedSpId;
//   String? selectedPoliceStationId;

//   List<SpOfficer> spOfficers = [];
//   List<PoliceStation> policeStations = [];
//   List<TimeSlot> timeSlots = [];

//   /// For selected time slot
//   String? selectedTimeSlotValue; // backend value
//   String? selectedTimeSlotLabel; // UI label

//   ApiResponse _spListResponse = ApiResponse.initial(message: 'Initialization');
//   ApiResponse get spListResponse => _spListResponse;

//   Future<void> fetchSPList() async {
//     _spListResponse = ApiResponse.loading(message: 'Loading SP list...');
//     update();

//     try {
//       SpResponseModel? response = await ProjectRepo().spList();

//       if (response != null && response.status.toLowerCase() == 'success') {
//         spOfficers = response.spOfficers;
//       } else {
//         spOfficers = [];
//         errorSnackBar("Failed", response?.message ?? "Unable to fetch SP list");
//       }

//       _spListResponse = ApiResponse.complete(response);
//     } catch (e) {
//       _spListResponse = ApiResponse.error(message: e.toString());
//       log("Error fetching SP list: $e");
//     }

//     update();
//   }

//   ApiResponse _policeStationResponse =
//       ApiResponse.initial(message: 'Initialization');
//   ApiResponse get policeStationResponse => _policeStationResponse;

//   Future<void> fetchPoliceStations() async {
//     _policeStationResponse =
//         ApiResponse.loading(message: 'Loading police stations...');
//     update();

//     try {
//       PoliceStationResponseModel? response =
//           await ProjectRepo().getPoliceStations();

//       if (response != null && response.status.toLowerCase() == 'success') {
//         policeStations = response.data;
//       } else {
//         policeStations = [];
//         errorSnackBar(
//             "Failed", response?.message ?? "Unable to fetch police stations");
//       }

//       _policeStationResponse = ApiResponse.complete(response);
//     } catch (e) {
//       _policeStationResponse = ApiResponse.error(message: e.toString());
//       log("Error fetching police stations: $e");
//     }
//     update();
//   }

//   ApiResponse _timeSlotResponse =
//       ApiResponse.initial(message: 'Initialization');
//   ApiResponse get timeSlotResponse => _timeSlotResponse;

//   Future<void> fetchTimeSlots() async {
//     _timeSlotResponse = ApiResponse.loading(message: 'Loading time slots...');
//     update();

//     try {
//       TimeSlotResponseModel? response = await ProjectRepo().getTimeSlot();

//       if (response != null && response.status.toLowerCase() == 'success') {
//         timeSlots = response.data;
//       } else {
//         timeSlots = [];
//         errorSnackBar(
//             "Failed", response?.message ?? "Unable to fetch time slots");
//       }

//       _timeSlotResponse = ApiResponse.complete(response);
//     } catch (e) {
//       _timeSlotResponse = ApiResponse.error(message: e.toString());
//       log("Error fetching time slots: $e");
//     }

//     update();
//   }

//   /// ✅ Create Visitor API
//   Future<Map<String, dynamic>> createVisitor(Map<String, dynamic> data) async {
//     try {
//       final response = await http.post(
//         Uri.parse("${ApiRouts.baseUrl}/create/visitor"),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(data),
//       );

//       if (response.statusCode == 200) {
//         final result = json.decode(response.body);
//         return result;
//       } else {
//         return {
//           "status": "error",
//           "message": "Failed with status ${response.statusCode}"
//         };
//       }
//     } catch (e) {
//       return {"status": "error", "message": e.toString()};
//     }
//   }
// }




