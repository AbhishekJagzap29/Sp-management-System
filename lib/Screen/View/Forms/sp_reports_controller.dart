import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:sp_manage_system/API/Repo/project_repo.dart';
import 'package:sp_manage_system/API/Response Model/police_station_res_model.dart';
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SpReportsController extends GetxController {
  var policeStations = <PoliceStation>[].obs;
  var isLoading = false.obs;
  var selectedPoliceStation = ''.obs;
  var selectedPoliceStationId = ''.obs;
  final TextEditingController searchController = TextEditingController();

  /// Fetch Police Stations
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

  /// Show Police Station Dropdown
  void showPoliceStations(BuildContext context) async {
    await fetchPoliceStations();
    if (policeStations.isEmpty) {
      Get.snackbar("त्रुटी", "पोलिस स्टेशन यादी मिळाली नाही");
      return;
    }

    searchController.clear();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Obx(() {
          final filtered = policeStations
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
                onChanged: (_) => policeStations.refresh(),
              ),
              const SizedBox(height: 12),
              if (isLoading.value)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final ps = filtered[index];
                      return ListTile(
                        title: Text(ps.policeStationName),
                        onTap: () {
                          selectedPoliceStation.value = ps.policeStationName;
                          selectedPoliceStationId.value =
                              ps.policeStationId.toString();
                          Get.back();
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

  /// 🔹 Download Visitor Report API
  Future<Uint8List?> downloadVisitorReport({
    required String policeStationId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final url = Uri.parse("${ApiRouts.baseUrl}/visitor/report/download");

      final body = {
        "police_station_id": int.parse(policeStationId),
        "from_date": fromDate,
        "to_date": toDate,
      };

      debugPrint("📦 Request body: ${jsonEncode(body)}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/pdf') == true) {
        final dir = await getTemporaryDirectory();
        final filePath =
            '${dir.path}/visitor_report_${fromDate}_to_${toDate}.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        try {
          // ✅ Try opening with OpenFilex
          final result = await OpenFilex.open(file.path);

          if (result == null || result.type != ResultType.done) {
            debugPrint("⚠️ OpenFilex failed, launching via URL instead.");
            await launchUrl(Uri.file(file.path));
          } else {
            debugPrint("✅ PDF opened successfully!");
          }
        } catch (e) {
          // 🔄 Fallback if OpenFilex fails completely
          debugPrint("⚠️ OpenFilex error: $e");
          await launchUrl(Uri.file(file.path));
        }
        //Get.snackbar();
        //Get.snackbar("यशस्वी", "PDF डाउनलोड व उघडला गेला आहे.");
        //return response.bodyBytes;
      } else {
        debugPrint("❌ Failed response: ${response.body}");
        if (response.body.contains("No records found")) {
          Get.snackbar("माहिती नाही", "निवडलेल्या कालावधीसाठी कोणतीही नोंद आढळली नाही.");
        } else {
          Get.snackbar("त्रुटी", "PDF मिळाला नाही. कृपया पुन्हा प्रयत्न करा.");
        }
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Error downloading PDF: $e");
      Get.snackbar("त्रुटी", "अहवाल डाउनलोड करताना समस्या आली.");
      return null;
    }
  }
}
