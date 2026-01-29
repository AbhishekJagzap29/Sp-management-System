import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/SpGraph/sp_ps_graph_controller.dart';

class SpPsGraphScreen extends StatelessWidget {
  final String policeStationName;
  final int policeStationId;

  const SpPsGraphScreen({
    super.key,
    required this.policeStationName,
    required this.policeStationId,
  });

  @override
  Widget build(BuildContext context) {
    final SpPsGraphController controller = Get.put(SpPsGraphController());

    // Fetch counts when screen opens
    controller.fetchPsStatusCounts(policeStationId);

    return Scaffold(
      appBar: AppBar(
        title: Text("$policeStationName - ग्राफ"),
        centerTitle: true,
        backgroundColor: backGroundColor,
      ),
      body: Padding(
  padding: const EdgeInsets.all(16),
  child: GetBuilder<SpPsGraphController>(
    builder: (ctrl) {
      if (ctrl.statusResponse.status == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else if (ctrl.statusResponse.status == Status.ERROR) {
        return Center(
          child: Text(
            ctrl.statusResponse.message ?? "Failed to load data",
            style: TextStyle(color: Colors.red.shade600),
          ),
        );
      } else {
        return SingleChildScrollView(   // 🔹 Make it scrollable
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔽 Toggle between Pie/Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("पाय"),
                  Switch(
                    value: ctrl.showBarChart,
                    onChanged: ctrl.toggleChart,
                  ),
                  const Text("बार"),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Graph Card
              SizedBox(
                height: 600,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ctrl.showBarChart
                        ? _buildBarChart(ctrl)
                        : _buildPieChart(ctrl),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Legend
              Wrap(
                alignment: WrapAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                runSpacing: 8,
                children: [
                  _buildLegendItem(Colors.orange, "नियुक्त", ctrl.assigned.value),
                  _buildLegendItem(Colors.blue, "भेट निश्चित", ctrl.visitTimeFixed.value),
                  _buildLegendItem(Colors.green, "पूर्ण", ctrl.closed.value),
                  _buildLegendItem(Colors.redAccent, "चालू", ctrl.open.value),
                  
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }
    },
  ),
),

    );
  }

  // ---------- Bar Chart ----------
  Widget _buildBarChart(SpPsGraphController ctrl) {
    final maxY = [
      ctrl.assigned.value,
      ctrl.visitTimeFixed.value,
      ctrl.closed.value,
      ctrl.open.value,
      ctrl.visitDone.value
    ].reduce((a, b) => a > b ? a : b).toDouble() + 5;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barGroups: [
          _barGroup(0, ctrl.assigned.value, Colors.orange),
          _barGroup(1, ctrl.visitTimeFixed.value, Colors.blue),
          _barGroup(2, ctrl.closed.value, Colors.green),
          _barGroup(3, ctrl.open.value, Colors.redAccent),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  toMarathiNumber(value.toInt()),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0: 
                    return const Text(
                      "नियुक्त",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  case 1: 
                    return const Text(
                      "भेट निश्चित",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  case 2: 
                    return const Text(
                      "पूर्ण",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  case 3: 
                    return const Text(
                      "चालू",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                }
                return const Text("");
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, int value, Color color) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: value.toDouble(),
        color: color,
        width: 20,
        borderRadius: BorderRadius.circular(4),
      ),
    ]);
  }

  // ---------- Pie Chart ----------
  Widget _buildPieChart(SpPsGraphController ctrl) {
    return PieChart(
      PieChartData(
        sections: [
          _pieSection(ctrl.assigned.value, Colors.orange, "नियुक्त"),
          _pieSection(ctrl.visitTimeFixed.value, Colors.blue, "भेट निश्चित"),
          _pieSection(ctrl.closed.value, Colors.green, "पूर्ण"),
          _pieSection(ctrl.open.value, Colors.redAccent, "चालू"),
        ],
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  PieChartSectionData _pieSection(int value, Color color, String title) {
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      title: "$title\n${toMarathiNumber(value)}",
      radius: 60,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  // ---------- Legend ----------
  Widget _buildLegendItem(Color color, String label, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text("$label: ${toMarathiNumber(count)}", style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// Helper to convert numbers to Marathi
String toMarathiNumber(int number) {
  const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  return number.toString().split('').map((e) => marathiDigits[int.parse(e)]).join();
}
