import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/pi_dashboard_controller.dart';
import 'package:sp_manage_system/Screen/View/Forms/pi_submitted_list.dart';
import 'package:sp_manage_system/Screen/View/Forms/pi_visit_form_list.dart';
import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

class PiOfficerDashboardScreen extends StatefulWidget {
  final String userType;
  const PiOfficerDashboardScreen({super.key, required this.userType});

  @override
  State<PiOfficerDashboardScreen> createState() =>
      _PiOfficerDashboardScreenState();
}

class _PiOfficerDashboardScreenState extends State<PiOfficerDashboardScreen> {
  bool showBarChart = true;
  final PiDashboardController controller = Get.put(PiDashboardController());

  @override
  void initState() {
    super.initState();
    controller.fetchPiStatusCounts(); // Fetch API on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("पोलिस स्टेशन - ग्राफ"),
        backgroundColor: backGroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NotificationScreen(callerDashboard: 'pi'),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<PiDashboardController>(
          builder: (ctrl) {
            if (ctrl.statusCountResponse.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            } else if (ctrl.statusCountResponse.status == Status.ERROR) {
              return Center(
                child: Text(
                  ctrl.statusCountResponse.message ?? "डेटा लोड करण्यात अयशस्वी",
                  style: TextStyle(color: Colors.red.shade600),
                ),
              );
            } else if (ctrl.statusCountResponse.status == Status.COMPLETE) {
              final data = ctrl.statusCounts;
              int assigned = data['assigned'] ?? 0;
              int bhetNishcit = data['bhetichi_vel_nishcit'] ?? 0;
              int close = data['close'] ?? 0;
              int open = data['open'] ?? 0;

              debugPrint(
                  '✅ PI Status Data → assigned:$assigned | bhet:$bhetNishcit | close:$close | open:$open');

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Toggle between Pie/Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("पाय"),
                        Switch(
                          value: showBarChart,
                          onChanged: (value) {
                            setState(() => showBarChart = value);
                          },
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
                          child: showBarChart
                              ? _buildBarChart(assigned, bhetNishcit, close, open)
                              : _buildPieChart(assigned, bhetNishcit, close, open),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Legend
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 8,
                      children: [
                        _buildLegendItem(Colors.orange, "नियुक्त", assigned),
                        _buildLegendItem(Colors.blue, "भेट निश्चित", bhetNishcit),
                        _buildLegendItem(Colors.green, "पूर्ण", close),
                        _buildLegendItem(Colors.redAccent, "चालू", open),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // 🔹 Buttons
                    _buildDashboardButton(
                      label: "अभ्यागतांची यादी",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PiVisitFormListScreen()),
                        );
                      },
                    ),
                    _buildDashboardButton(
                      label: "सादर केलेले अर्ज",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PiSubmittedListScreen()),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  // ---------- Bar Chart ----------
  Widget _buildBarChart(int assigned, int bhetNishcit, int close, int open) {
    final maxY = [
      assigned,
      bhetNishcit,
      close,
      open,
    ].reduce((a, b) => a > b ? a : b).toDouble() + 5;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barGroups: [
          _barGroup(0, assigned, Colors.orange),
          _barGroup(1, bhetNishcit, Colors.blue),
          _barGroup(2, close, Colors.green),
          _barGroup(3, open, Colors.redAccent),
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
                    return const Text("नियुक्त",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
                  case 1:
                    return const Text("भेट निश्चित",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
                  case 2:
                    return const Text("पूर्ण",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
                  case 3:
                    return const Text("चालू",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
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
  Widget _buildPieChart(int assigned, int bhetNishcit, int close, int open) {
    return PieChart(
      PieChartData(
        sections: [
          _pieSection(assigned, Colors.orange, "नियुक्त"),
          _pieSection(bhetNishcit, Colors.blue, "भेट निश्चित"),
          _pieSection(close, Colors.green, "पूर्ण"),
          _pieSection(open, Colors.redAccent, "चालू"),
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

  // ---------- Dashboard Buttons ----------
  Widget _buildDashboardButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 60,
            width: 220,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 10, 69, 170),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to convert numbers to Marathi
  String toMarathiNumber(int number) {
    const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    return number.toString().split('').map((e) => marathiDigits[int.parse(e)]).join();
  }
}















// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/API/Apis/api_response.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/pi_dashboard_controller.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

// class PiOfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const PiOfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<PiOfficerDashboardScreen> createState() =>
//       _PiOfficerDashboardScreenState();
// }

// class _PiOfficerDashboardScreenState extends State<PiOfficerDashboardScreen> {
//   bool showBarChart = true;
//   final PiDashboardController controller = Get.put(PiDashboardController());

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchPiStatusCounts(); // Fetch API on screen load
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("भिगवण पोलिस स्टेशन - ग्राफ"),
//         backgroundColor: backGroundColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       const NotificationScreen(callerDashboard: 'pi'),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GetBuilder<PiDashboardController>(
//           builder: (ctrl) {
//             if (ctrl.statusCountResponse.status == Status.LOADING) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (ctrl.statusCountResponse.status == Status.ERROR) {
//               return Center(
//                 child: Text(
//                   ctrl.statusCountResponse.message ?? "डेटा लोड करण्यात अयशस्वी",
//                   style: TextStyle(color: Colors.red.shade600),
//                 ),
//               );
//             } else if (ctrl.statusCountResponse.status == Status.COMPLETE) {
//               final data = ctrl.statusCounts;
//               int assigned = data['assigned'] ?? 0;
//               int bhetNishcit = data['bhetichi_vel_nishcit'] ?? 0;
//               int close = data['close'] ?? 0;
//               int open = data['open'] ?? 0;

//               debugPrint(
//                   '✅ PI Status Data → assigned:$assigned | bhet:$bhetNishcit | close:$close | open:$open');

//               return SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // 🔹 Toggle between Pie/Bar
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const Text("पाय"),
//                         Switch(
//                           value: showBarChart,
//                           onChanged: (value) {
//                             setState(() => showBarChart = value);
//                           },
//                         ),
//                         const Text("बार"),
//                       ],
//                     ),
//                     const SizedBox(height: 20),

//                     // 🔹 Graph Card
//                     SizedBox(
//                       height: 600,
//                       child: Card(
//                         elevation: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: showBarChart
//                               ? _buildBarChart(assigned, bhetNishcit, close, open)
//                               : _buildPieChart(assigned, bhetNishcit, close, open),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // 🔹 Legend
//                     Wrap(
//                       alignment: WrapAlignment.center,
//                       spacing: 20,
//                       runSpacing: 8,
//                       children: [
//                         _buildLegendItem(Colors.orange, "नियुक्त", assigned),
//                         _buildLegendItem(Colors.blue, "भेट निश्चित", bhetNishcit),
//                         _buildLegendItem(Colors.green, "पूर्ण", close),
//                         _buildLegendItem(Colors.redAccent, "चालू", open),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               );
//             } else {
//               return const SizedBox();
//             }
//           },
//         ),
//       ),
//     );
//   }

//   // ---------- Bar Chart ----------
//   Widget _buildBarChart(int assigned, int bhetNishcit, int close, int open) {
//     final maxY = [
//       assigned,
//       bhetNishcit,
//       close,
//       open,
//     ].reduce((a, b) => a > b ? a : b).toDouble() + 5;

//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: maxY,
//         barGroups: [
//           _barGroup(0, assigned, Colors.orange),
//           _barGroup(1, bhetNishcit, Colors.blue),
//           _barGroup(2, close, Colors.green),
//           _barGroup(3, open, Colors.redAccent),
//         ],
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               interval: 2,
//               reservedSize: 40,
//               getTitlesWidget: (value, meta) {
//                 return Text(
//                   toMarathiNumber(value.toInt()),
//                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                 );
//               },
//             ),
//           ),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 switch (value.toInt()) {
//                   case 0:
//                     return const Text("नियुक्त",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
//                   case 1:
//                     return const Text("भेट निश्चित",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
//                   case 2:
//                     return const Text("पूर्ण",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
//                   case 3:
//                     return const Text("चालू",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
//                 }
//                 return const Text("");
//               },
//             ),
//           ),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//         borderData: FlBorderData(show: false),
//         gridData: FlGridData(
//           show: true,
//           drawHorizontalLine: true,
//           horizontalInterval: 2,
//           getDrawingHorizontalLine: (value) => FlLine(
//             color: Colors.grey.withOpacity(0.2),
//             strokeWidth: 1,
//           ),
//         ),
//       ),
//     );
//   }

//   BarChartGroupData _barGroup(int x, int value, Color color) {
//     return BarChartGroupData(x: x, barRods: [
//       BarChartRodData(
//         toY: value.toDouble(),
//         color: color,
//         width: 20,
//         borderRadius: BorderRadius.circular(4),
//       ),
//     ]);
//   }

//   // ---------- Pie Chart ----------
//   Widget _buildPieChart(int assigned, int bhetNishcit, int close, int open) {
//     return PieChart(
//       PieChartData(
//         sections: [
//           _pieSection(assigned, Colors.orange, "नियुक्त"),
//           _pieSection(bhetNishcit, Colors.blue, "भेट निश्चित"),
//           _pieSection(close, Colors.green, "पूर्ण"),
//           _pieSection(open, Colors.redAccent, "चालू"),
//         ],
//         centerSpaceRadius: 40,
//         sectionsSpace: 2,
//       ),
//     );
//   }

//   PieChartSectionData _pieSection(int value, Color color, String title) {
//     return PieChartSectionData(
//       value: value.toDouble(),
//       color: color,
//       title: "$title\n${toMarathiNumber(value)}",
//       radius: 60,
//       titleStyle: const TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//         fontSize: 12,
//       ),
//     );
//   }

//   // ---------- Legend ----------
//   Widget _buildLegendItem(Color color, String label, int count) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//         const SizedBox(width: 6),
//         Text("$label: ${toMarathiNumber(count)}", style: const TextStyle(fontSize: 14)),
//       ],
//     );
//   }

//   // Helper to convert numbers to Marathi
//   String toMarathiNumber(int number) {
//     const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
//     return number.toString().split('').map((e) => marathiDigits[int.parse(e)]).join();
//   }
// }













// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/API/Apis/api_response.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/pi_dashboard_controller.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_submitted_list.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_visit_form_list.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

// class PiOfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const PiOfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<PiOfficerDashboardScreen> createState() =>
//       _PiOfficerDashboardScreenState();
// }

// class _PiOfficerDashboardScreenState extends State<PiOfficerDashboardScreen> {
//   bool showBarChart = true;

//   final PiDashboardController controller = Get.put(PiDashboardController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("अधिकारी माहिती पटल"),
//         backgroundColor: backGroundColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       const NotificationScreen(callerDashboard: 'pi'),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: GetBuilder<PiDashboardController>(
//         builder: (ctrl) {
//           if (ctrl.statusCountResponse.status == Status.LOADING) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (ctrl.statusCountResponse.status == Status.ERROR) {
//             return Center(
//               child: Text(
//                 "डेटा लोड करण्यात अयशस्वी",
//                 style: TextStyle(color: Colors.red.shade600),
//               ),
//             );
//           } else if (ctrl.statusCountResponse.status == Status.COMPLETE) {
//             // Get counts from API response
//             int total = ctrl.statusCounts['total'] ?? 0;
//             int open = ctrl.statusCounts['open'] ?? 0;
//             int visitDone = ctrl.statusCounts['visit_done'] ?? 0;
//             int assigned = ctrl.statusCounts['assigned'] ?? 0;
//             int bhetichiVelNishcit = ctrl.statusCounts['bhetichi_vel_nishcit'] ?? 0;
//             int close = ctrl.statusCounts['close'] ?? 0;

//             // For PI dashboard, we'll use open, visit_done, and close as main statuses
//             int solvedComplaints = close;
//             int pendingComplaints = open + assigned + bhetichiVelNishcit;

//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 🔽 Chart Toggle Only
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const Text('पाय'),
//                       Switch(
//                         value: showBarChart,
//                         onChanged: (value) {
//                           setState(() {
//                             showBarChart = value;
//                           });
//                         },
//                       ),
//                       const Text('बार'),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Chart Card
//                   Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: showBarChart 
//                           ? _buildBarChart(total, solvedComplaints, pendingComplaints)
//                           : _buildPieChart(total, solvedComplaints, pendingComplaints),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Status Legend
//                   _buildDetailedLegend(
//                     total: total,
//                     solved: solvedComplaints,
//                     pending: pendingComplaints,
//                     open: open,
//                     visitDone: visitDone,
//                     assigned: assigned,
//                     bhetichiVelNishcit: bhetichiVelNishcit,
//                     close: close,
//                   ),

//                   const SizedBox(height: 20),

//                   // Buttons
//                   _buildDashboardButton(
//                     label: "अभ्यागतांची यादी",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const PiVisitFormListScreen()),
//                       );
//                     },
//                   ),
//                   _buildDashboardButton(
//                     label: "सादर केलेले अर्ज",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const PiSubmittedListScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return const SizedBox();
//           }
//         },
//       ),
//     );
//   }

//   // 🔽 Build Bar Chart
//   Widget _buildBarChart(int total, int solved, int pending) {
//     double maxY = ([total, solved, pending].reduce((a, b) => a > b ? a : b).toDouble() + 10);

//     return Column(
//       children: [
//         SizedBox(
//           height: 300,
//           child: BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.spaceAround,
//               maxY: maxY,
//               barTouchData: BarTouchData(enabled: false),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: _calculateInterval(maxY),
//                     reservedSize: 40,
//                     getTitlesWidget: (value, meta) {
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         space: 6,
//                         child: Text(
//                           toMarathiNumber(value.toInt()),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 rightTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       String label = '';
//                       switch (value.toInt()) {
//                         case 0:
//                           label = 'एकूण';
//                           break;
//                         case 1:
//                           label = 'पूर्ण';
//                           break;
//                         case 2:
//                           label = 'प्रलंबित';
//                           break;
//                       }
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         child: Text(
//                           label,
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               borderData: FlBorderData(show: false),
//               gridData: FlGridData(
//                 show: true,
//                 drawHorizontalLine: true,
//                 horizontalInterval: _calculateInterval(maxY),
//                 getDrawingHorizontalLine: (value) {
//                   return FlLine(
//                     color: Colors.grey.withOpacity(0.2),
//                     strokeWidth: 1,
//                   );
//                 },
//               ),
//               barGroups: [
//                 BarChartGroupData(x: 0, barRods: [
//                   BarChartRodData(
//                     toY: total.toDouble(),
//                     color: Colors.orange,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//                 BarChartGroupData(x: 1, barRods: [
//                   BarChartRodData(
//                     toY: solved.toDouble(),
//                     color: Colors.green,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//                 BarChartGroupData(x: 2, barRods: [
//                   BarChartRodData(
//                     toY: pending.toDouble(),
//                     color: Colors.redAccent,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(Colors.orange, 'एकूण', total),
//             _buildLegendItem(Colors.green, 'पूर्ण', solved),
//             _buildLegendItem(Colors.redAccent, 'प्रलंबित', pending),
//           ],
//         ),
//       ],
//     );
//   }

//   // 🔽 Build Pie Chart
//   Widget _buildPieChart(int total, int solved, int pending) {
//     int other = total - solved - pending;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 250,
//           child: PieChart(
//             PieChartData(
//               sections: [
//                 PieChartSectionData(
//                   value: solved.toDouble(),
//                   color: Colors.green,
//                   title: '${toMarathiNumber(solved)}\nपूर्ण',
//                   radius: 60,
//                   titleStyle: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 PieChartSectionData(
//                   value: pending.toDouble(),
//                   color: Colors.red,
//                   title: '${toMarathiNumber(pending)}\nप्रलंबित',
//                   radius: 60,
//                   titleStyle: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 if (other > 0)
//                   PieChartSectionData(
//                     value: other.toDouble(),
//                     color: Colors.blue,
//                     title: '${toMarathiNumber(other)}\nइतर',
//                     radius: 60,
//                     titleStyle: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//               ],
//               centerSpaceRadius: 40,
//               sectionsSpace: 2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(Colors.green, 'पूर्ण', solved),
//             _buildLegendItem(Colors.red, 'प्रलंबित', pending),
//             if (other > 0) _buildLegendItem(Colors.blue, 'इतर', other),
//           ].where((element) => element != null).cast<Widget>().toList(),
//         ),
//       ],
//     );
//   }

//   // 🔽 Detailed Legend for all statuses
//   Widget _buildDetailedLegend({
//     required int total,
//     required int solved,
//     required int pending,
//     required int open,
//     required int visitDone,
//     required int assigned,
//     required int bhetichiVelNishcit,
//     required int close,
//   }) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "सर्व स्थिती तपशील",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 16,
//               runSpacing: 8,
//               children: [
//                 _buildDetailedLegendItem(Colors.orange, 'एकूण', total),
//                 _buildDetailedLegendItem(Colors.green, 'पूर्ण', close),
//                 _buildDetailedLegendItem(Colors.red, 'प्रलंबित', pending),
//                 _buildDetailedLegendItem(Colors.blue, 'खुले', open),
//                 _buildDetailedLegendItem(Colors.purple, 'भेट पूर्ण', visitDone),
//                 _buildDetailedLegendItem(Colors.teal, 'नियुक्त', assigned),
//                 _buildDetailedLegendItem(Colors.amber, 'भेट वेळ निश्चित', bhetichiVelNishcit),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🔽 Legend item builder
//   Widget _buildLegendItem(Color color, String label, int count) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(width: 14, height: 14, color: color),
//         const SizedBox(width: 6),
//         Text(
//           '$label: ${toMarathiNumber(count)}',
//           style: const TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailedLegendItem(Color color, String label, int count) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(width: 12, height: 12, color: color),
//           const SizedBox(width: 6),
//           Text(
//             '$label: ${toMarathiNumber(count)}',
//             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🔽 Dashboard button builder
//   Widget _buildDashboardButton({
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             height: 60,
//             width: 220,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 10, 69, 170),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               label,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to calculate interval for Y-axis
//   double _calculateInterval(double maxY) {
//     if (maxY <= 10) return 2;
//     if (maxY <= 20) return 5;
//     if (maxY <= 50) return 10;
//     if (maxY <= 100) return 20;
//     return 50;
//   }

//   // 🔽 Convert number to Marathi digits
//   String toMarathiNumber(int number) {
//     const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
//     return number
//         .toString()
//         .split('')
//         .map((e) => marathiDigits[int.parse(e)])
//         .join();
//   }
// }













// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/pi_dashboard_controller.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_submitted_list.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_visit_form_list.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

// class PiOfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const PiOfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<PiOfficerDashboardScreen> createState() =>
//       _PiOfficerDashboardScreenState();
// }

// class _PiOfficerDashboardScreenState extends State<PiOfficerDashboardScreen> {
//   bool showBarChart = true;

//   final int totalComplaints = 120;
//   final int solvedComplaints = 80;
//   final int pendingComplaints = 40;

//   final PiDashboardController controller = Get.put(PiDashboardController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("अधिकारी माहिती पटल"),
//         backgroundColor: backGroundColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       const NotificationScreen(callerDashboard: 'pi'),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔽 Chart Toggle Only (Filter icon removed)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 const Text('पाय'),
//                 Switch(
//                   value: showBarChart,
//                   onChanged: (value) {
//                     setState(() {
//                       showBarChart = value;
//                     });
//                   },
//                 ),
//                 const Text('बार'),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Chart Card
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: showBarChart ? _buildBarChart() : _buildPieChart(),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Buttons
//             _buildDashboardButton(
//               label: "अभ्यागतांची यादी",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const PiVisitFormListScreen()),
//                 );
//               },
//             ),
//             _buildDashboardButton(
//               label: "सादर केलेले अर्ज",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const PiSubmittedListScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🔽 Build Bar Chart
//   Widget _buildBarChart() {
//     return Column(
//       children: [
//         SizedBox(
//           height: 250,
//           child: BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.spaceAround,
//               maxY: totalComplaints.toDouble() + 20,
//               barTouchData: BarTouchData(enabled: false),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: 10,
//                     reservedSize: 40,
//                     getTitlesWidget: (value, meta) {
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         space: 6,
//                         child: Text(
//                           toMarathiNumber(value.toInt()),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 rightTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         child: Text(
//                           value.toInt() == 0
//                               ? 'एकूण'
//                               : value.toInt() == 1
//                                   ? 'पूर्ण'
//                                   : 'प्रलंबित',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               borderData: FlBorderData(show: false),
//               gridData: FlGridData(
//                 show: true,
//                 drawHorizontalLine: true,
//                 horizontalInterval: 10,
//                 getDrawingHorizontalLine: (value) {
//                   return FlLine(
//                     color: Colors.grey.withOpacity(0.2),
//                     strokeWidth: 1,
//                   );
//                 },
//               ),
//               barGroups: [
//                 BarChartGroupData(x: 0, barRods: [
//                   BarChartRodData(
//                     toY: totalComplaints.toDouble(),
//                     color: Colors.orange,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//                 BarChartGroupData(x: 1, barRods: [
//                   BarChartRodData(
//                     toY: solvedComplaints.toDouble(),
//                     color: Colors.green,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//                 BarChartGroupData(x: 2, barRods: [
//                   BarChartRodData(
//                     toY: pendingComplaints.toDouble(),
//                     color: Colors.redAccent,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(Colors.orange, 'एकूण', totalComplaints),
//             _buildLegendItem(Colors.green, 'पूर्ण', solvedComplaints),
//             _buildLegendItem(Colors.redAccent, 'प्रलंबित', pendingComplaints),
//           ],
//         ),
//       ],
//     );
//   }

//   // 🔽 Build Pie Chart
//   Widget _buildPieChart() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 250,
//           child: PieChart(
//             PieChartData(
//               sections: [
//                 PieChartSectionData(
//                   value: solvedComplaints.toDouble(),
//                   color: Colors.green,
//                   title: 'पूर्ण',
//                   radius: 60,
//                 ),
//                 PieChartSectionData(
//                   value: pendingComplaints.toDouble(),
//                   color: Colors.red,
//                   title: 'प्रलंबित',
//                   radius: 60,
//                 ),
//                 PieChartSectionData(
//                   value: (totalComplaints - solvedComplaints - pendingComplaints)
//                       .toDouble(),
//                   color: Colors.blue,
//                   title: 'एकूण\n${toMarathiNumber(totalComplaints)}',
//                   radius: 60,
//                   titleStyle: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ],
//               centerSpaceRadius: 40,
//               sectionsSpace: 2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(Colors.green, 'पूर्ण', solvedComplaints),
//             _buildLegendItem(Colors.red, 'प्रलंबित', pendingComplaints),
//             _buildLegendItem(Colors.blue, 'एकूण', totalComplaints),
//           ],
//         ),
//       ],
//     );
//   }

//   // 🔽 Legend item builder
//   Widget _buildLegendItem(Color color, String label, int count) {
//     return Row(
//       children: [
//         Container(width: 14, height: 14, color: color),
//         const SizedBox(width: 6),
//         Text(
//           '$label: ${toMarathiNumber(count)}',
//           style: const TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }

//   // 🔽 Dashboard button builder
//   Widget _buildDashboardButton(
//       {required String label, required VoidCallback onTap}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             height: 60,
//             width: 220,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 10, 69, 170),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               label,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔽 Convert number to Marathi digits
//   String toMarathiNumber(int number) {
//     const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
//     return number
//         .toString()
//         .split('')
//         .map((e) => marathiDigits[int.parse(e)])
//         .join();
//   }
// }




















// //Working code for police station searchable list Graph is Pending-----------------26/09/2025------------
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/pi_dashboard_controller.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_submitted_list.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_visit_form_list.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

// class PiOfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const PiOfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<PiOfficerDashboardScreen> createState() =>
//       _PiOfficerDashboardScreenState();
// }

// class _PiOfficerDashboardScreenState extends State<PiOfficerDashboardScreen> {
//   bool showBarChart = true;

//   final int totalComplaints = 120;
//   final int solvedComplaints = 80;
//   final int pendingComplaints = 40;

//   final PiDashboardController controller = Get.put(PiDashboardController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("अधिकारी माहिती पटल"),
//         backgroundColor: backGroundColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       const NotificationScreen(callerDashboard: 'pi'),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔽 Filter + Chart Toggle
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.tune, color: Colors.black87),
//                   onPressed: () {
//                     controller.showPoliceStations(context);
//                   },
//                 ),
//                 Row(
//                   children: [
//                     const Text('पाय'),
//                     Switch(
//                       value: showBarChart,
//                       onChanged: (value) {
//                         setState(() {
//                           showBarChart = value;
//                         });
//                       },
//                     ),
//                     const Text('बार'),
//                   ],
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Chart Card
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: showBarChart ? _buildBarChart() : _buildPieChart(),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Buttons
//             _buildDashboardButton(
//               label: "अभ्यागतांची यादी",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const PiVisitFormListScreen()),
//                 );
//               },
//             ),
//             _buildDashboardButton(
//               label: "सादर केलेले अर्ज",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const PiSubmittedListScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🔽 Build Bar Chart
//   Widget _buildBarChart() {
//     return Column(
//       children: [
//         SizedBox(
//           height: 250,
//           child: BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.spaceAround,
//               maxY: totalComplaints.toDouble() + 20,
//               barTouchData: BarTouchData(enabled: false),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: 10,
//                     reservedSize: 40,
//                     getTitlesWidget: (value, meta) {
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         space: 6,
//                         child: Text(
//                           toMarathiNumber(value.toInt()),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 rightTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         child: Text(
//                           value.toInt() == 0
//                               ? 'एकूण'
//                               : value.toInt() == 1
//                                   ? 'पूर्ण'
//                                   : 'प्रलंबित',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               borderData: FlBorderData(show: false),
//               gridData: FlGridData(
//                 show: true,
//                 drawHorizontalLine: true,
//                 horizontalInterval: 10,
//                 getDrawingHorizontalLine: (value) {
//                   return FlLine(
//                     color: Colors.grey.withOpacity(0.2),
//                     strokeWidth: 1,
//                   );
//                 },
//               ),
//               barGroups: [
//                 BarChartGroupData(x: 0, barRods: [
//                   BarChartRodData(
//                     toY: totalComplaints.toDouble(),
//                     color: Colors.orange,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//                 BarChartGroupData(x: 1, barRods: [
//                   BarChartRodData(
//                     toY: solvedComplaints.toDouble(),
//                     color: Colors.green,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//                 BarChartGroupData(x: 2, barRods: [
//                   BarChartRodData(
//                     toY: pendingComplaints.toDouble(),
//                     color: Colors.redAccent,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(Colors.orange, 'एकूण', totalComplaints),
//             _buildLegendItem(Colors.green, 'पूर्ण', solvedComplaints),
//             _buildLegendItem(Colors.redAccent, 'प्रलंबित', pendingComplaints),
//           ],
//         ),
//       ],
//     );
//   }

//   // 🔽 Build Pie Chart
//   Widget _buildPieChart() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 250,
//           child: PieChart(
//             PieChartData(
//               sections: [
//                 PieChartSectionData(
//                   value: solvedComplaints.toDouble(),
//                   color: Colors.green,
//                   title: 'पूर्ण',
//                   radius: 60,
//                 ),
//                 PieChartSectionData(
//                   value: pendingComplaints.toDouble(),
//                   color: Colors.red,
//                   title: 'प्रलंबित',
//                   radius: 60,
//                 ),
//                 PieChartSectionData(
//                   value: (totalComplaints - solvedComplaints - pendingComplaints)
//                       .toDouble(),
//                   color: Colors.blue,
//                   title: 'एकूण\n${toMarathiNumber(totalComplaints)}',
//                   radius: 60,
//                   titleStyle: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ],
//               centerSpaceRadius: 40,
//               sectionsSpace: 2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(Colors.green, 'पूर्ण', solvedComplaints),
//             _buildLegendItem(Colors.red, 'प्रलंबित', pendingComplaints),
//             _buildLegendItem(Colors.blue, 'एकूण', totalComplaints),
//           ],
//         ),
//       ],
//     );
//   }

//   // 🔽 Legend item builder
//   Widget _buildLegendItem(Color color, String label, int count) {
//     return Row(
//       children: [
//         Container(width: 14, height: 14, color: color),
//         const SizedBox(width: 6),
//         Text(
//           '$label: ${toMarathiNumber(count)}',
//           style: const TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }

//   // 🔽 Dashboard button builder
//   Widget _buildDashboardButton(
//       {required String label, required VoidCallback onTap}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             height: 60,
//             width: 220,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 10, 69, 170),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               label,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// //   // 🔽 Convert number to Marathi digits
//   String toMarathiNumber(int number) {
//     const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
//     return number
//         .toString()
//         .split('')
//         .map((e) => marathiDigits[int.parse(e)])
//         .join();
//   }
// }






















// //working code without graph list showing----------------------------26/09/2025--------------------
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/pi_dashboard_controller.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_submitted_list.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_visit_form_list.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

// class PiOfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const PiOfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<PiOfficerDashboardScreen> createState() =>
//       _PiOfficerDashboardScreenState();
// }

// class _PiOfficerDashboardScreenState extends State<PiOfficerDashboardScreen> {
//   bool showBarChart = true;

//   final int totalComplaints = 120;
//   final int solvedComplaints = 80;
//   final int pendingComplaints = 40;

//   final PiDashboardController controller = Get.put(PiDashboardController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("अधिकारी माहिती पटल"),
//         backgroundColor: backGroundColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const NotificationScreen(callerDashboard: 'pi',),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔽 Filter + Chart Toggle
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.tune, color: Colors.black87),
//                   onPressed: () {
//                     controller.showPoliceStations(context);
//                   },
//                 ),
//                 Row(
//                   children: [
//                     const Text('पाय'),
//                     Switch(
//                       value: showBarChart,
//                       onChanged: (value) {
//                         setState(() {
//                           showBarChart = value;
//                         });
//                       },
//                     ),
//                     const Text('बार'),
//                   ],
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Chart Card
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: showBarChart ? _buildBarChart() : _buildPieChart(),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Buttons
//             _buildDashboardButton(
//               label: "अभ्यागतांची यादी",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const PiVisitFormListScreen()),
//                 );
//               },
//             ),
//             _buildDashboardButton(
//               label: "सादर केलेले अर्ज",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const PiSubmittedListScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🔽 Build Bar Chart
//   Widget _buildBarChart() {
//     return Column(
//       children: [
//         SizedBox(
//           height: 250,
//           child: BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.spaceAround,
//               maxY: totalComplaints.toDouble() + 20,
//               barTouchData: BarTouchData(enabled: false),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: 10,
//                     reservedSize: 40,
//                     getTitlesWidget: (value, meta) {
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         space: 6,
//                         child: Text(
//                           toMarathiNumber(value.toInt()),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 rightTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         child: Text(
//                           value.toInt() == 0
//                               ? 'एकूण'
//                               : value.toInt() == 1
//                                   ? 'पूर्ण'
//                                   : 'प्रलंबित',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               borderData: FlBorderData(show: false),
//               gridData: FlGridData(
//                 show: true,
//                 drawHorizontalLine: true,
//                 horizontalInterval: 10,
//                 getDrawingHorizontalLine: (value) {
//                   return FlLine(
//                     color: Colors.grey.withOpacity(0.2),
//                     strokeWidth: 1,
//                   );
//                 },
//               ),
//               barGroups: [
//                 BarChartGroupData(x: 0, barRods: [
//                   BarChartRodData(
//                     toY: totalComplaints.toDouble(),
//                     color: Colors.orange,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//                 BarChartGroupData(x: 1, barRods: [
//                   BarChartRodData(
//                     toY: solvedComplaints.toDouble(),
//                     color: Colors.green,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//                 BarChartGroupData(x: 2, barRods: [
//                   BarChartRodData(
//                     toY: pendingComplaints.toDouble(),
//                     color: Colors.redAccent,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(Colors.orange, 'एकूण', totalComplaints),
//             _buildLegendItem(Colors.green, 'पूर्ण', solvedComplaints),
//             _buildLegendItem(Colors.redAccent, 'प्रलंबित', pendingComplaints),
//           ],
//         ),
//       ],
//     );
//   }

//   // 🔽 Build Pie Chart
//   Widget _buildPieChart() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 250,
//           child: PieChart(
//             PieChartData(
//               sections: [
//                 PieChartSectionData(
//                   value: solvedComplaints.toDouble(),
//                   color: Colors.green,
//                   title: 'पूर्ण',
//                   radius: 60,
//                 ),
//                 PieChartSectionData(
//                   value: pendingComplaints.toDouble(),
//                   color: Colors.red,
//                   title: 'प्रलंबित',
//                   radius: 60,
//                 ),
//                 PieChartSectionData(
//                   value: (totalComplaints - solvedComplaints - pendingComplaints)
//                       .toDouble(),
//                   color: Colors.blue,
//                   title: 'एकूण\n${toMarathiNumber(totalComplaints)}',
//                   radius: 60,
//                   titleStyle: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ],
//               centerSpaceRadius: 40,
//               sectionsSpace: 2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(Colors.green, 'पूर्ण', solvedComplaints),
//             _buildLegendItem(Colors.red, 'प्रलंबित', pendingComplaints),
//             _buildLegendItem(Colors.blue, 'एकूण', totalComplaints),
//           ],
//         ),
//       ],
//     );
//   }

//   // 🔽 Legend item builder
//   Widget _buildLegendItem(Color color, String label, int count) {
//     return Row(
//       children: [
//         Container(width: 14, height: 14, color: color),
//         const SizedBox(width: 6),
//         Text(
//           '$label: ${toMarathiNumber(count)}',
//           style: const TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }

//   // 🔽 Dashboard button builder
//   Widget _buildDashboardButton({required String label, required VoidCallback onTap}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             height: 60,
//             width: 220,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 10, 69, 170),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               label,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔽 Convert number to Marathi digits
//   String toMarathiNumber(int number) {
//     const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
//     return number
//         .toString()
//         .split('')
//         .map((e) => marathiDigits[int.parse(e)])
//         .join();
//   }
// }








