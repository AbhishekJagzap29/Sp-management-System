import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/SpGraph/sp_ps_graph_screen.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/sp_dashboard_controller.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_closed_list.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_reports_screen.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_visit_form_list.dart';
import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

class SpOfficerDashboardScreen extends StatefulWidget {
  final String userType;
  const SpOfficerDashboardScreen({super.key, required this.userType});

  @override
  State<SpOfficerDashboardScreen> createState() =>
      _SpOfficerDashboardScreenState();
}

class _SpOfficerDashboardScreenState extends State<SpOfficerDashboardScreen> {
  bool showBarChart = true;
  final SPDashboardController controller = Get.put(SPDashboardController());
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.fetchStatusCounts(policeStationId: 1);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Dashboard - stay here
    } else if (index == 1) {
      Get.to(() => const VisitFormListScreen());
    } else if (index == 2) {
      Get.to(() => const SpClosedListScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("अधिकारी माहिती पटल"),
        backgroundColor: backGroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NotificationScreen(callerDashboard: 'sp'),
                ),
              );
            },
          ),
        ],
      ),

      body: GetBuilder<SPDashboardController>(
        builder: (ctrl) {
          if (ctrl.statusCountResponse.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          } else if (ctrl.statusCountResponse.status == Status.ERROR) {
            return Center(
              child: Text(
                "Failed to load data",
                style: TextStyle(color: Colors.red.shade600),
              ),
            );
          } else if (ctrl.statusCountResponse.status == Status.COMPLETE) {
            int assigned = ctrl.statusCounts['assigned'] ?? 0;
            int visitTimeFixed = ctrl.statusCounts['bhetichi_vel_nishcit'] ?? 0;
            int closed = ctrl.statusCounts['close'] ?? 0;
            int open = ctrl.statusCounts['open'] ?? 0;
            int visitDone = ctrl.statusCounts['visit_done'] ?? 0;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔽 Filter + Chart Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.tune, color: Colors.black87),
                          onPressed: () {
                            controller.showPoliceStations(context, onSelect: (ps) {
                              Get.to(() => SpPsGraphScreen(
                                    policeStationId: ps.policeStationId,
                                    policeStationName: ps.policeStationName,
                                  ));
                            });
                          },
                        ),
                        Row(
                          children: [
                            const Text('पाय'),
                            Switch(
                              value: showBarChart,
                              onChanged: (value) {
                                setState(() {
                                  showBarChart = value;
                                });
                              },
                            ),
                            const Text('बार'),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Chart Card
                    SizedBox(
                      height: 600,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox.expand(
                            child: showBarChart
                                ? _buildBarChart(
                                    assigned,
                                    visitTimeFixed,
                                    closed,
                                    open,
                                    visitDone,
                                  )
                                : _buildPieChart(
                                    assigned,
                                    visitTimeFixed,
                                    closed,
                                    open,
                                    visitDone,
                                  ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Dashboard Buttons
                    Column(
                      children: [
                        _buildDashboardButton(
                          label: "अभ्यागतांची यादी",
                          color: const Color.fromARGB(255, 10, 69, 170),
                          onTap: () {
                            Get.to(() => const VisitFormListScreen());
                          },
                        ),
                        const SizedBox(height: 5),
                        _buildDashboardButton(
                          label: "पूर्ण झालेले अर्ज",
                          color: const Color.fromARGB(255, 10, 69, 170),
                          onTap: () {
                            Get.to(() => const SpClosedListScreen());
                          },
                        ),
                        const SizedBox(height: 5),
                        // ✅ New Button
                        _buildDashboardButton(
                          label: "अभ्यागतांचा अहवाल",
                          color: const Color.fromARGB(255, 10, 69, 170),
                          onTap: () {
                            Get.to(() => const SpReportsScreen());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  /// -------- Dashboard Button ------
  Widget _buildDashboardButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 60,
          width: 220,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// --------- BAR CHART ----------
  Widget _buildBarChart(
      int assigned, int visitTimeFixed, int closed, int open, int visitDone) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: ([assigned, visitTimeFixed, closed, open, visitDone]
                          .reduce((a, b) => a > b ? a : b)
                          .toDouble() +
                      5)
                  .toDouble(),
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child: Text(
                          toMarathiNumber(value.toInt()),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String label = '';
                      switch (value.toInt()) {
                        case 0:
                          label = 'नियुक्त';
                          break;
                        case 1:
                          label = 'भेट निश्चित';
                          break;
                        case 2:
                          label = 'पूर्ण';
                          break;
                        case 3:
                          label = 'चालू';
                          break;
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              barGroups: [
                _barGroup(0, assigned, Colors.orange),
                _barGroup(1, visitTimeFixed, Colors.blue),
                _barGroup(2, closed, Colors.green),
                _barGroup(3, open, Colors.redAccent),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildLegendItem(Colors.orange, 'नियुक्त', assigned),
            _buildLegendItem(Colors.blue, 'भेट निश्चित', visitTimeFixed),
            _buildLegendItem(Colors.green, 'पूर्ण', closed),
            _buildLegendItem(Colors.redAccent, 'चालू', open),
          ],
        ),
      ],
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

  /// --------- PIE CHART ----------
  Widget _buildPieChart(
      int assigned, int visitTimeFixed, int closed, int open, int visitDone) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: [
                _pieSection(assigned, Colors.orange),
                _pieSection(visitTimeFixed, Colors.blue),
                _pieSection(closed, Colors.green),
                _pieSection(open, Colors.redAccent),
              ],
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 8,
          children: [
            _buildLegendItem(Colors.orange, "नियुक्त", assigned),
            _buildLegendItem(Colors.blue, "भेट वेळ निश्चित", visitTimeFixed),
            _buildLegendItem(Colors.green, "पूर्ण", closed),
            _buildLegendItem(Colors.redAccent, "चालू", open),
          ],
        ),
      ],
    );
  }

  PieChartSectionData _pieSection(int value, Color color) {
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      title: toMarathiNumber(value),
      radius: 60,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "$label: ${toMarathiNumber(count)}",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

/// ---- Helper to convert numbers to Marathi ----
String toMarathiNumber(int number) {
  const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  return number
      .toString()
      .split('')
      .map((e) => marathiDigits[int.parse(e)])
      .join();
}















// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/API/Apis/api_response.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/SpGraph/sp_ps_graph_screen.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/sp_dashboard_controller.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_closed_list.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_visit_form_list.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

// class SpOfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const SpOfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<SpOfficerDashboardScreen> createState() =>
//       _SpOfficerDashboardScreenState();
// }

// class _SpOfficerDashboardScreenState extends State<SpOfficerDashboardScreen> {
//   bool showBarChart = true;

//   final SPDashboardController controller = Get.put(SPDashboardController());

//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchStatusCounts(policeStationId: 1);
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (index == 0) {
//       // Dashboard - stay here
//     } else if (index == 1) {
//       Get.to(() => const VisitFormListScreen());
//     } else if (index == 2) {
//       Get.to(() => const SpClosedListScreen());
//     }
//   }

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
//                       const NotificationScreen(callerDashboard: 'sp'),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
      
//       body: GetBuilder<SPDashboardController>(
//   builder: (ctrl) {
//     if (ctrl.statusCountResponse.status == Status.LOADING) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (ctrl.statusCountResponse.status == Status.ERROR) {
//       return Center(
//         child: Text(
//           "Failed to load data",
//           style: TextStyle(color: Colors.red.shade600),
//         ),
//       );
//     } else if (ctrl.statusCountResponse.status == Status.COMPLETE) {
//       int assigned = ctrl.statusCounts['assigned'] ?? 0;
//       int visitTimeFixed = ctrl.statusCounts['bhetichi_vel_nishcit'] ?? 0;
//       int closed = ctrl.statusCounts['close'] ?? 0;
//       int open = ctrl.statusCounts['open'] ?? 0;
//       int visitDone = ctrl.statusCounts['visit_done'] ?? 0;

//       return SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔽 Filter + Chart Toggle
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.tune, color: Colors.black87),
//                     onPressed: () {
//                       controller.showPoliceStations(context, onSelect: (ps) {
//                         Get.to(() => SpPsGraphScreen(
//                               policeStationId: ps.policeStationId,
//                               policeStationName: ps.policeStationName,
//                             ));
//                       });
//                     },
//                   ),
//                   Row(
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
//                 ],
//               ),

//               const SizedBox(height: 16),
//               // Chart card
// SizedBox(
//   height: 600, // 🔼 increased graph height
//   child: Card(
//     elevation: 4,
//     child: Padding(
//       padding: const EdgeInsets.all(10),
//       child: SizedBox.expand(   // 🔑 make chart fill full height
//         child: showBarChart
//             ? _buildBarChart(
//                 assigned,
//                 visitTimeFixed,
//                 closed,
//                 open,
//                 visitDone,
//               )
//             : _buildPieChart(
//                 assigned,
//                 visitTimeFixed,
//                 closed,
//                 open,
//                 visitDone,
//               ),
//       ),
//     ),
//   ),
// ),

//               const SizedBox(height: 14),

//               // Dashboard Buttons
//               Column(
//                 children: [
//                   _buildDashboardButton(
//                     label: "अभ्यागतांची यादी",
//                     color: const Color.fromARGB(255, 10, 69, 170),
//                     onTap: () {
//                       Get.to(() => const VisitFormListScreen());
//                     },
//                   ),
//                   const SizedBox(height: 5),
//                   _buildDashboardButton(
//                     label: "पूर्ण झालेले अर्ज",
//                     color: const Color.fromARGB(255, 10, 69, 170),
//                     onTap: () {
//                       Get.to(() => const SpClosedListScreen());
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return const SizedBox();
//     }
//   },
// ),

//     );
//   }

//   /// -------- Dashboard Button ------
//   Widget _buildDashboardButton({
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Center(
//         child: Container(
//           height: 60,
//           width: 220,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             label,
//             style: const TextStyle(
//                 color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   /// --------- BAR CHART ----------
//   Widget _buildBarChart(
//       int assigned, int visitTimeFixed, int closed, int open, int visitDone) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 500,
//           child: BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.spaceAround,
//               maxY: ([assigned, visitTimeFixed, closed, open, visitDone]
//                           .reduce((a, b) => a > b ? a : b)
//                           .toDouble() +
//                       5)
//                   .toDouble(),
//               barTouchData: BarTouchData(enabled: false),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: 2,
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
//                 rightTitles:
//                     AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 topTitles:
//                     AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       String label = '';
//                       switch (value.toInt()) {
//                         case 0:
//                           label = 'नियुक्त';
//                           break;
//                         case 1:
//                           label = 'भेट निश्चित';
//                           break;
//                         case 2:
//                           label = 'पूर्ण';
//                           break;
//                         case 3:
//                           label = 'चालू';
//                           break;
//                       }
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         child: Text(
//                           label,
//                           style: const TextStyle(
//                             fontSize: 12,
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
//                 horizontalInterval: 2,
//                 getDrawingHorizontalLine: (value) {
//                   return FlLine(
//                     color: Colors.grey.withOpacity(0.2),
//                     strokeWidth: 1,
//                   );
//                 },
//               ),
//               barGroups: [
//                 _barGroup(0, assigned, Colors.orange),
//                 _barGroup(1, visitTimeFixed, Colors.blue),
//                 _barGroup(2, closed, Colors.green),
//                 _barGroup(3, open, Colors.redAccent),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Wrap(
//           spacing: 16,
//           runSpacing: 8,
//           children: [
//             _buildLegendItem(Colors.orange, 'नियुक्त', assigned),
//             _buildLegendItem(Colors.blue, 'भेट निश्चित', visitTimeFixed),
//             _buildLegendItem(Colors.green, 'पूर्ण', closed),
//             _buildLegendItem(Colors.redAccent, 'चालू', open),
//           ],
//         ),
//       ],
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

//   /// --------- PIE CHART ----------
//   Widget _buildPieChart(
//       int assigned, int visitTimeFixed, int closed, int open, int visitDone) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 250,
//           child: PieChart(
//             PieChartData(
//               sections: [
//                 _pieSection(assigned, Colors.orange),
//                 _pieSection(visitTimeFixed, Colors.blue),
//                 _pieSection(closed, Colors.green),
//                 _pieSection(open, Colors.redAccent),
//               ],
//               centerSpaceRadius: 40,
//               sectionsSpace: 2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Wrap(
//           alignment: WrapAlignment.center,
//           spacing: 20,
//           runSpacing: 8,
//           children: [
//             _buildLegendItem(Colors.orange, "नियुक्त", assigned),
//             _buildLegendItem(Colors.blue, "भेट वेळ निश्चित", visitTimeFixed),
//             _buildLegendItem(Colors.green, "पूर्ण", closed),
//             _buildLegendItem(Colors.redAccent, "चालू", open),
//           ],
//         ),
//       ],
//     );
//   }

//   PieChartSectionData _pieSection(int value, Color color) {
//     return PieChartSectionData(
//       value: value.toDouble(),
//       color: color,
//       title: toMarathiNumber(value),
//       radius: 60,
//       titleStyle: const TextStyle(
//         color: Colors.white,
//         fontSize: 12,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   Widget _buildLegendItem(Color color, String label, int count) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 14,
//           height: 14,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           "$label: ${toMarathiNumber(count)}",
//           style: const TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }
// }

// /// ---- Helper to convert numbers to Marathi ----
// String toMarathiNumber(int number) {
//   const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
//   return number
//       .toString()
//       .split('')
//       .map((e) => marathiDigits[int.parse(e)])
//       .join();
// }

