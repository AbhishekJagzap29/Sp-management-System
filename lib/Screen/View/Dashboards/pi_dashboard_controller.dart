import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/API/Repo/project_repo.dart';
import 'package:sp_manage_system/API/Response%20Model/count_res_model.dart';

class PiDashboardController extends GetxController {
  Map<String, int> statusCounts = {};
  ApiResponse _statusCountResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get statusCountResponse => _statusCountResponse;

  @override
  void onInit() {
    super.onInit();
    fetchPiStatusCounts();
  }

  Future<void> fetchPiStatusCounts() async {
    _statusCountResponse = ApiResponse.loading(message: 'Loading...');
    update();

    try {
      StatusCountResponseModel? response =
          await ProjectRepo().getPiStatusCounts();

      if (response != null && response.status.toLowerCase() == 'success') {
        statusCounts = Map<String, int>.from(response.counts);
        debugPrint('✅ PI Status Counts: $statusCounts');
      } else {
        debugPrint('⚠️ Empty or invalid response');
      }

      _statusCountResponse = ApiResponse.complete(response);
    } catch (e) {
      _statusCountResponse = ApiResponse.error(message: e.toString());
      debugPrint("❌ Error fetching PI counts: $e");
    }

    update();
  }
}










// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:sp_manage_system/API/Apis/api_response.dart';
// import 'package:sp_manage_system/API/Repo/project_repo.dart';
// import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/count_res_model.dart';

// class PiDashboardController extends GetxController {
//   var policeStations = <PoliceStation>[].obs;
//   var isLoading = false.obs;
  
//   // For status counts
//   Map<String, int> statusCounts = {};
//   ApiResponse _statusCountResponse = ApiResponse.initial(message: 'Initialization');
//   ApiResponse get statusCountResponse => _statusCountResponse;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchPiStatusCounts();
//   }

//   Future<void> fetchPiStatusCounts() async {
//     _statusCountResponse = ApiResponse.loading(message: 'Loading status counts...');
//     update();

//     try {
//       // Assuming you have a method in ProjectRepo for PI status counts
//       StatusCountResponseModel? response = await ProjectRepo().getPiStatusCounts();

//       if (response != null && response.status.toLowerCase() == 'success') {
//         statusCounts = response.data;
//       } else {
//         statusCounts = {};
//         Get.snackbar(
//           "Error",
//           response?.message ?? "Unable to fetch counts",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }

//       _statusCountResponse = ApiResponse.complete(response);
//     } catch (e) {
//       _statusCountResponse = ApiResponse.error(message: e.toString());
//       debugPrint("Error fetching PI status counts: $e");
//     }

//     update();
//   }

//   Future<void> fetchPoliceStations() async {
//     try {
//       isLoading.value = true;
//       final response = await ProjectRepo().getPoliceStations();
//       if (response != null && response.data.isNotEmpty) {
//         policeStations.value = response.data;
//       } else {
//         policeStations.clear();
//       }
//     } catch (e) {
//       debugPrint("Error fetching police stations: $e");
//       policeStations.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }











// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:sp_manage_system/API/Repo/project_repo.dart';
// import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';

// class PiDashboardController extends GetxController {
//   var policeStations = <PoliceStation>[].obs;
//   var isLoading = false.obs;

//   Future<void> fetchPoliceStations() async {
//     try {
//       isLoading.value = true;
//       final response = await ProjectRepo().getPoliceStations();
//       if (response != null && response.data.isNotEmpty) {
//         policeStations.value = response.data;
//       } else {
//         policeStations.clear();
//       }
//     } catch (e) {
//       debugPrint("Error fetching police stations: $e");
//       policeStations.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }





















// //Working code for police station searchable list Graph is Pending-----------------26/09/2025------------
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:sp_manage_system/API/Repo/project_repo.dart';
// import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';

// class PiDashboardController extends GetxController {
//   var policeStations = <PoliceStation>[].obs;
//   var isLoading = false.obs;

//   var selectedPoliceStation = "".obs;
//   var selectedPoliceStationId = "".obs;

//   final TextEditingController searchController = TextEditingController();

//   Future<void> fetchPoliceStations() async {
//     try {
//       isLoading.value = true;

//       final response = await ProjectRepo().getPoliceStations();
//       if (response != null && response.data.isNotEmpty) {
//         policeStations.value = response.data;
//       } else {
//         policeStations.clear();
//       }
//     } catch (e) {
//       debugPrint("Error fetching police stations: $e");
//       policeStations.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void showPoliceStations(BuildContext context) async {
//     await fetchPoliceStations();
//     if (policeStations.isEmpty) return;

//     searchController.clear();

//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         child: Obx(() {
//           final filteredStations = policeStations
//               .where((ps) => ps.policeStationName
//                   .toLowerCase()
//                   .contains(searchController.text.toLowerCase()))
//               .toList();

//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "पोलिस स्टेशन निवडा",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: searchController,
//                 decoration: const InputDecoration(
//                   hintText: "शोधा...",
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.search),
//                 ),
//                 onChanged: (_) {
//                   // refresh search
//                   policeStations.refresh();
//                 },
//               ),
//               const SizedBox(height: 12),
//               if (isLoading.value)
//                 const Center(child: CircularProgressIndicator())
//               else
//                 SizedBox(
//                   height: 300,
//                   child: ListView.builder(
//                     itemCount: filteredStations.length,
//                     itemBuilder: (context, index) {
//                       final ps = filteredStations[index];
//                       return ListTile(
//                         title: Text(ps.policeStationName),
//                         onTap: () {
//                           selectedPoliceStation.value = ps.policeStationName;
//                           selectedPoliceStationId.value =
//                               ps.policeStationId.toString();
//                           Get.back();
//                           debugPrint(
//                               "Selected Police Station: ${ps.policeStationName} (${ps.policeStationId})");
//                         },
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
















// //working code without graph list showing----------------------------26/09/2025--------------------
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:sp_manage_system/API/Repo/project_repo.dart';
// import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';

// class PiDashboardController extends GetxController {
//   var policeStations = <PoliceStation>[].obs; 
//   var isLoading = false.obs;


//   Future<void> fetchPoliceStations() async {
//     try {
//       isLoading.value = true;

//       final response = await ProjectRepo().getPoliceStations(); 
//       if (response != null && response.data.isNotEmpty) {
//         policeStations.value = response.data;
//       } else {
//         policeStations.clear();
//       }
//     } catch (e) {
//       debugPrint("Error fetching police stations: $e");
//       policeStations.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void showPoliceStations(BuildContext context) async {
//     await fetchPoliceStations();
//     if (policeStations.isEmpty) return;

//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         child: Obx(() {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "पोलिस स्टेशन निवडा",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               if (isLoading.value)
//                 const Center(child: CircularProgressIndicator())
//               else
//                 ...policeStations.map(
//                   (ps) => ListTile(
//                     title: Text(ps.policeStationName),
//                     onTap: () {
//                       Get.back(); // close sheet
//                       debugPrint("Selected Police Station: ${ps.policeStationName}");
//                       // TODO: Call your API with ps.policeStationId
//                     },
//                   ),
//                 ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

