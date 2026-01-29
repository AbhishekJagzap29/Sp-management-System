import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/API/Service/base_service.dart';

class SpPsGraphController extends GetxController {
  bool showBarChart = true;

  // Status counts
  RxInt assigned = 0.obs;
  RxInt visitTimeFixed = 0.obs;
  RxInt closed = 0.obs;
  RxInt open = 0.obs;
  RxInt visitDone = 0.obs;

  ApiResponse statusResponse = ApiResponse.initial(message: "Init");

  /// Fetch police station status counts
  Future<void> fetchPsStatusCounts(int psId) async {
    statusResponse = ApiResponse.loading(message: "Loading PS counts...");
    update();

    try {
      final response = await http.post(
        Uri.parse("${ApiRouts.base}session/auth/get/ps/status_counts"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'police_station_id': psId}),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final counts = data['counts'] ?? {};
        assigned.value = counts['assigned'] ?? 0;
        visitTimeFixed.value = counts['bhetichi_vel_nishcit'] ?? 0;
        closed.value = counts['close'] ?? 0;
        open.value = counts['open'] ?? 0;
        visitDone.value = counts['visit_done'] ?? 0;

        statusResponse = ApiResponse.complete(data);
      } else {
        statusResponse = ApiResponse.error(message: data['message'] ?? "Error");
      }
    } catch (e) {
      statusResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

  /// Toggle between bar and pie chart
  void toggleChart(bool value) {
    showBarChart = value;
    update();
  }
}
