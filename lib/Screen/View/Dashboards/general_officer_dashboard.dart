import 'package:flutter/material.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/View/Forms/complaint_form.dart';

class OfficerDashboardScreen extends StatefulWidget {
  final String userType;
  const OfficerDashboardScreen({super.key, required this.userType});

  @override
  State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "अधिकारी माहिती पटल",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: backGroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Maharashtra Police Logo (Rounded with glow & shadow)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.6),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.white,
                  backgroundImage: const AssetImage('assets/images/PRPS.png'),
                ),
              ),

              const SizedBox(height: 20),

              // App title
              const Text(
                "महाराष्ट्र राज्य पोलीस विभाग",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              Text(
                "आपले स्वागत आहे",
                //"आपले स्वागत आहे, ${"अधिकारी"}",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Complaint button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ComplaintFormScreen()),
                  );
                },
                child: Container(
                  height: 60,
                  width: 230,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 10, 69, 170),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "तक्रार अर्ज भरा",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Footer note
              // const Text(
              //   //"© महाराष्ट्र राज्य पोलीस - अधिकृत अनुप्रयोग",
              //   style: TextStyle(
              //     fontSize: 12,
              //     color: Colors.black54,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
















// import 'package:flutter/material.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Forms/complaint_form.dart';

// class OfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const OfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
// }

// class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "अधिकारी माहिती पटल",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: backGroundColor,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             // Maharashtra Police Logo
//             Center(
//               child: Image.asset(
//                 'assets/images/PRPS.png', // ensure this path exists in pubspec.yaml
//                 height: 200,
//                 width: 200,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // App title section
//             const Text(
//               "महाराष्ट्र राज्य पोलीस विभाग",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "आपले स्वागत आहे, ${"अधिकारी"}",
//               style: const TextStyle(
//                 fontSize: 15,
//                 color: Colors.black54,
//               ),
//               textAlign: TextAlign.center,
//             ),

//             const SizedBox(height: 40),

//             // Complaint button
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ComplaintFormScreen()),
//                 );
//               },
//               child: Container(
//                 height: 60,
//                 width: 220,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 10, 69, 170),
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       offset: const Offset(0, 3),
//                       blurRadius: 6,
//                     ),
//                   ],
//                 ),
//                 alignment: Alignment.center,
//                 child: const Text(
//                   "तक्रार अर्ज भरा",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Footer note
//             // const Text(
//             //   "© महाराष्ट्र राज्य पोलीस - अधिकृत अनुप्रयोग",
//             //   style: TextStyle(
//             //     fontSize: 12,
//             //     color: Colors.black54,
//             //   ),
//             //   textAlign: TextAlign.center,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }















// //corrected without dummy graph, dummy graph is Removed-----------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Forms/complaint_form.dart';

// class OfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const OfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
// }

// class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
//   bool showBarChart = true;

//   final int totalComplaints = 120;
//   final int solvedComplaints = 80;
//   final int pendingComplaints = 40;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("अधिकारी माहिती पटल"),
//         backgroundColor: backGroundColor,
//       ),
//       body: Center(
//         child: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const ComplaintFormScreen()),
//             );
//           },
//           child: Container(
//             height: 60,
//             width: 220,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 10, 69, 170),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             alignment: Alignment.center,
//             child: const Text(
//               "तक्रार अर्ज भरा",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔽 Graph-related code commented out below 🔽
//   /*
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
//                 rightTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: AxisTitles(
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
//       ],
//     );
//   }

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
//       ],
//     );
//   }

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

//   String toMarathiNumber(int number) {
//     const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
//     return number
//         .toString()
//         .split('')
//         .map((e) => marathiDigits[int.parse(e)])
//         .join();
//   }
//   */
// }



















//corrected but dummy graph is present-----------------------------------------------

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// //import 'package:sp_manage_system/Screen/View/Dashboards/admin_dashboard.dart';
// import 'package:sp_manage_system/Screen/View/Forms/complaint_form.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_screen.dart';

// class OfficerDashboardScreen extends StatefulWidget {
//   final String userType;
//   const OfficerDashboardScreen({super.key, required this.userType});

//   @override
//   State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
// }

// class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
//   bool showBarChart = true;

//   final int totalComplaints = 120;
//   final int solvedComplaints = 80;
//   final int pendingComplaints = 40;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//                 centerTitle: true,

//         title: const Text("अधिकारी माहिती पटल"),
//         backgroundColor: backGroundColor,
//         actions: [
//           // IconButton(
//           //   icon: const Icon(Icons.notifications),
//           //   onPressed: () {
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //         builder: (context) => const NotificationScreen(callerDashboard: '',),
//           //       ),
//           //     );
//           //   },
//           // ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
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
//             SizedBox(
//               height: 350,
//               child: Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: showBarChart ? _buildBarChart() : _buildPieChart(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ComplaintFormScreen()),
//                 );
//               },
//               child: Center(
//                 child: Container(
//                   height: 60,
//                   width: 220,
//                   decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 10, 69, 170),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   alignment: Alignment.center,
//                   child: const Text(
//                     "तक्रार अर्ज भरा",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

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
//                 rightTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: AxisTitles(
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
//                     rodStackItems: [
//                       BarChartRodStackItem(
//                         0,
//                         totalComplaints.toDouble(),
//                         Colors.orange,
//                       ),
//                     ],
//                   ),
//                 ]),
//                 BarChartGroupData(x: 1, barRods: [
//                   BarChartRodData(
//                     toY: solvedComplaints.toDouble(),
//                     color: Colors.green,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                     rodStackItems: [
//                       BarChartRodStackItem(
//                         0,
//                         solvedComplaints.toDouble(),
//                         Colors.green,
//                       )
//                     ],
//                   ),
//                 ]),
//                 BarChartGroupData(x: 2, barRods: [
//                   BarChartRodData(
//                     toY: pendingComplaints.toDouble(),
//                     color: Colors.redAccent,
//                     width: 22,
//                     borderRadius: BorderRadius.circular(4),
//                     rodStackItems: [
//                       BarChartRodStackItem(
//                         0,
//                         pendingComplaints.toDouble(),
//                         Colors.redAccent,
//                       )
//                     ],
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
//                   value:
//                       (totalComplaints - solvedComplaints - pendingComplaints)
//                           .toDouble(),
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
//             _buildLegendItem(Colors.green, 'संपलेले', solvedComplaints),
//             _buildLegendItem(Colors.red, 'प्रलंबित', pendingComplaints),
//             _buildLegendItem(Colors.blue, 'एकूण', totalComplaints),
//           ],
//         ),
//       ],
//     );
//   }

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

//   String toMarathiNumber(int number) {
//     const marathiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
//     return number
//         .toString()
//         .split('')
//         .map((e) => marathiDigits[int.parse(e)])
//         .join();
//   }
// }
