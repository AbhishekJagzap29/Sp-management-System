import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/API/Repo/project_repo.dart';
import 'package:sp_manage_system/API/Response%20Model/count_res_model.dart';
import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';

class SPDashboardController extends GetxController {
  Map<String, int> statusCounts = {};

  ApiResponse _statusCountResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get statusCountResponse => _statusCountResponse;

  // 🔽 Police Station related
  var policeStations = <PoliceStation>[].obs;
  var isLoading = false.obs;
  var selectedPoliceStation = "".obs;
  var selectedPoliceStationId = "".obs;
  final TextEditingController searchController = TextEditingController();

  Future<void> fetchStatusCounts({required int policeStationId}) async {
    _statusCountResponse =
        ApiResponse.loading(message: 'Loading status counts...');
    update();

    try {
      StatusCountResponseModel? response = await ProjectRepo().getStatusCount(policeStationId: 0);

      if (response != null && response.status.toLowerCase() == 'success') {
        statusCounts = response.counts.map((key, value) => MapEntry(key, value as int));
      } else {
        statusCounts = {};
        errorSnackBar("Failed", response?.message ?? "Unable to fetch counts");
      }

      _statusCountResponse = ApiResponse.complete(response);
    } catch (e) {
      _statusCountResponse = ApiResponse.error(message: e.toString());
      log("Error fetching status counts: $e");
    }

    update();
  }

  /// -------- Fetch police stations --------
  Future<void> fetchPoliceStations() async {
    try {
      isLoading.value = true;
      final response = await ProjectRepo().getPoliceStations();
      if (response != null && response.data.isNotEmpty) {
        policeStations.value = response.data;
      } else {
        policeStations.clear();
      }
    } catch (e) {
      debugPrint("Error fetching police stations: $e");
      policeStations.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// -------- Show Police Station Filter --------
  void showPoliceStations(BuildContext context,
      {required Function(PoliceStation) onSelect}) async {
    await fetchPoliceStations();
    if (policeStations.isEmpty) return;

    searchController.clear();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Obx(() {
          final filteredStations = policeStations
              .where((ps) => ps.policeStationName
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "पोलिस स्टेशन निवडा",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "शोधा...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) {
                  policeStations.refresh();
                },
              ),
              const SizedBox(height: 12),
              if (isLoading.value)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: filteredStations.length,
                    itemBuilder: (context, index) {
                      final ps = filteredStations[index];
                      return ListTile(
                        title: Text(ps.policeStationName),
                        onTap: () {
                          selectedPoliceStation.value = ps.policeStationName;
                          selectedPoliceStationId.value =
                              ps.policeStationId.toString();

                          Get.back(); // close bottom sheet

                          // Navigate to SP PS Graph Screen
                          onSelect(ps);
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

