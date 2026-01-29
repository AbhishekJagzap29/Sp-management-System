import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_reports_controller.dart';

class SpReportsScreen extends StatefulWidget {
  const SpReportsScreen({super.key});

  @override
  State<SpReportsScreen> createState() => _SpReportsScreenState();
}

class _SpReportsScreenState extends State<SpReportsScreen> {
  final _formKey = GlobalKey<FormState>();
  final SpReportsController controller = Get.put(SpReportsController());

  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _pickDate(BuildContext context, bool isFromDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  /// ✅ Common Snackbar Function (Same format as your screenshot)
  void _showPopup({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.closeAllSnackbars();
    Get.snackbar(
      "",
      "",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      backgroundColor: const Color(0xFF607D8B),
      borderRadius: 12,
      borderWidth: 2,
      borderColor: Colors.black26,
      icon: Icon(
        isError ? Icons.close_rounded : Icons.done_all,
        color: Colors.white,
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _downloadPdfReport() async {
    if (_formKey.currentState!.validate()) {
      if (fromDate != null && toDate != null) {
        try {
          String fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate!);
          String toDateStr = DateFormat('yyyy-MM-dd').format(toDate!);

          _showPopup(
            title: "कृपया थांबा",
            message: "PDF अहवाल तयार होत आहे...",
          );

          final pdfBytes = await controller.downloadVisitorReport(
            policeStationId: controller.selectedPoliceStationId.value,
            fromDate: fromDateStr,
            toDate: toDateStr,
          );

          if (pdfBytes != null) {
            final dir = await getApplicationDocumentsDirectory();
            final filePath =
                '${dir.path}/visitor_report_${fromDateStr}_to_${toDateStr}.pdf';
            final file = File(filePath);
            await file.writeAsBytes(pdfBytes);

            _showPopup(
              title: "यशस्वी",
              message: "PDF अहवाल यशस्वीरित्या डाउनलोड झाला!",
            );
          } else {
            _showPopup(
              title: "त्रुटी",
              message: "PDF डाउनलोड करण्यात अडचण आली.",
              isError: true,
            );
          }
        } catch (e) {
          _showPopup(
            title: "त्रुटी",
            message: "अहवाल तयार करताना समस्या आली.",
            isError: true,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("अभ्यागतांचा अहवाल"),
        backgroundColor: backGroundColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  /// Police Station Dropdown
                  Obx(() {
                    return GestureDetector(
                      onTap: () => controller.showPoliceStations(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "पोलीस स्टेशन निवडा",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                          ),
                          controller: TextEditingController(
                            text: controller.selectedPoliceStation.value,
                          ),
                          validator: (_) => controller
                                  .selectedPoliceStation.value.isEmpty
                              ? "कृपया पोलीस स्टेशन निवडा"
                              : null,
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  /// From Date
                  TextFormField(
                    readOnly: true,
                    validator: (_) => fromDate == null
                        ? "कृपया सुरुवातीचा दिनांक निवडा"
                        : null,
                    decoration: InputDecoration(
                      labelText: "दिनांक पासून",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(context, true),
                      ),
                    ),
                    controller: TextEditingController(
                      text: fromDate != null
                          ? DateFormat('dd-MM-yyyy').format(fromDate!)
                          : "",
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// To Date
                  TextFormField(
                    readOnly: true,
                    validator: (_) =>
                        toDate == null ? "कृपया शेवटचा दिनांक निवडा" : null,
                    decoration: InputDecoration(
                      labelText: "दिनांक पर्यंत",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(context, false),
                      ),
                    ),
                    controller: TextEditingController(
                      text: toDate != null
                          ? DateFormat('dd-MM-yyyy').format(toDate!)
                          : "",
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Download PDF Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _downloadPdfReport,
                      icon: const Icon(Icons.download),
                      label: const Text("PDF अहवाल डाउनलोड करा"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 10, 69, 170),
                        minimumSize: const Size(260, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}











// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_reports_controller.dart';

// class SpReportsScreen extends StatefulWidget {
//   const SpReportsScreen({super.key});

//   @override
//   State<SpReportsScreen> createState() => _SpReportsScreenState();
// }

// class _SpReportsScreenState extends State<SpReportsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final SpReportsController controller = Get.put(SpReportsController());

//   DateTime? fromDate;
//   DateTime? toDate;

//   Future<void> _pickDate(BuildContext context, bool isFromDate) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2035),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           fromDate = picked;
//         } else {
//           toDate = picked;
//         }
//       });
//     }
//   }

//   /// ✅ Custom Snackbar (Same style as your screenshot)
//   void _showSuccessPopup({
//     required String title,
//     required String message,
//   }) {
//     Get.closeAllSnackbars();
//     Get.rawSnackbar(
//       backgroundColor: const Color(0xFF607D8B), // same bluish-grey shade
//       borderRadius: 12,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       snackPosition: SnackPosition.BOTTOM,
//       animationDuration: const Duration(milliseconds: 350),
//       duration: const Duration(seconds: 3),
//       messageText: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.done_all_rounded, color: Colors.white, size: 28),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   message,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showErrorPopup({
//     required String title,
//     required String message,
//   }) {
//     Get.closeAllSnackbars();
//     Get.rawSnackbar(
//       backgroundColor: Colors.red.shade700,
//       borderRadius: 12,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       snackPosition: SnackPosition.BOTTOM,
//       animationDuration: const Duration(milliseconds: 350),
//       duration: const Duration(seconds: 3),
//       messageText: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.white, size: 28),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   message,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _downloadPdfReport() async {
//     if (_formKey.currentState!.validate()) {
//       if (fromDate != null && toDate != null) {
//         try {
//           String fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate!);
//           String toDateStr = DateFormat('yyyy-MM-dd').format(toDate!);

//           _showSuccessPopup(
//             title: "कृपया थांबा",
//             message: "PDF अहवाल तयार होत आहे...",
//           );

//           final pdfBytes = await controller.downloadVisitorReport(
//             policeStationId: controller.selectedPoliceStationId.value,
//             fromDate: fromDateStr,
//             toDate: toDateStr,
//           );

//           if (pdfBytes != null) {
//             final dir = await getApplicationDocumentsDirectory();
//             final filePath =
//                 '${dir.path}/visitor_report_${fromDateStr}_to_${toDateStr}.pdf';
//             final file = File(filePath);
//             await file.writeAsBytes(pdfBytes);

//             _showSuccessPopup(
//               title: "यशस्वी",
//               message: "PDF अहवाल यशस्वीरित्या डाउनलोड झाला!",
//             );
//           } else {
//             _showErrorPopup(
//               title: "त्रुटी",
//               message: "PDF डाउनलोड करण्यात अडचण आली.",
//             );
//           }
//         } catch (e) {
//           _showErrorPopup(
//             title: "त्रुटी",
//             message: "अहवाल तयार करताना समस्या आली.",
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागतांचा अहवाल"),
//         backgroundColor: backGroundColor,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 5,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   /// Police Station Dropdown
//                   Obx(() {
//                     return GestureDetector(
//                       onTap: () => controller.showPoliceStations(context),
//                       child: AbsorbPointer(
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             labelText: "पोलीस स्टेशन निवडा",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             suffixIcon: const Icon(Icons.arrow_drop_down),
//                           ),
//                           controller: TextEditingController(
//                             text: controller.selectedPoliceStation.value,
//                           ),
//                           validator: (_) => controller
//                                   .selectedPoliceStation.value.isEmpty
//                               ? "कृपया पोलीस स्टेशन निवडा"
//                               : null,
//                         ),
//                       ),
//                     );
//                   }),

//                   const SizedBox(height: 20),

//                   /// From Date
//                   TextFormField(
//                     readOnly: true,
//                     validator: (_) => fromDate == null
//                         ? "कृपया सुरुवातीचा दिनांक निवडा"
//                         : null,
//                     decoration: InputDecoration(
//                       labelText: "दिनांक पासून",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () => _pickDate(context, true),
//                       ),
//                     ),
//                     controller: TextEditingController(
//                       text: fromDate != null
//                           ? DateFormat('dd-MM-yyyy').format(fromDate!)
//                           : "",
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   /// To Date
//                   TextFormField(
//                     readOnly: true,
//                     validator: (_) =>
//                         toDate == null ? "कृपया शेवटचा दिनांक निवडा" : null,
//                     decoration: InputDecoration(
//                       labelText: "दिनांक पर्यंत",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () => _pickDate(context, false),
//                       ),
//                     ),
//                     controller: TextEditingController(
//                       text: toDate != null
//                           ? DateFormat('dd-MM-yyyy').format(toDate!)
//                           : "",
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   /// Download PDF Button
//                   Center(
//                     child: ElevatedButton.icon(
//                       onPressed: _downloadPdfReport,
//                       icon: const Icon(Icons.download),
//                       label: const Text("PDF अहवाल डाउनलोड करा"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             const Color.fromARGB(255, 10, 69, 170),
//                         minimumSize: const Size(260, 60),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         textStyle: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


