import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'visit_history_list_controller.dart';
import 'visit_history_form_screen.dart';

class VisitHistoryListScreen extends StatefulWidget {
  final String whatsappNumber;
  const VisitHistoryListScreen({super.key, required this.whatsappNumber});

  @override
  State<VisitHistoryListScreen> createState() => _VisitHistoryListScreenState();
}

class _VisitHistoryListScreenState extends State<VisitHistoryListScreen> {
  final VisitHistoryListController controller =
      Get.put(VisitHistoryListController());

  @override
  void initState() {
    super.initState();
    controller.fetchVisitHistory(widget.whatsappNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("भेटीचा इतिहास"),
        backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => controller.filterVisitHistory(value),
              decoration: InputDecoration(
                hintText: "भेट क्रमांकाने शोधा",
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(6, 51, 131, 1), width: 1.5),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredVisitHistory.isEmpty) {
                return const Center(child: Text("भेटीचा इतिहास उपलब्ध नाही"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.filteredVisitHistory.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredVisitHistory[index];
                  final visitorId = item["visitor_id"];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      onTap: () {
                        if (visitorId != null) {
                          Get.to(() => VisitHistoryFormScreen(visitorId: visitorId));
                        } else {
                          Get.snackbar("त्रुटी", "Visitor ID उपलब्ध नाही");
                        }
                      },
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(186, 4, 2, 92),
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        item["sequence_number"] ?? "-",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("अर्जदाराचे नाव: ${item["name"] ?? "-"}"),
                            Text("भेटीचे कारण: ${item["reason"] ?? "-"}"),
                            Text("नियुक्ती तारीख: ${item["appointment_date"] ?? "-"}"),
                            Text("नियुक्त अधिकारी नाव: ${item["officer_name"] ?? "-"}"),
                            Text("SP अभिप्राय: ${item["feedback"] ?? "-"}"),
                            if (item["e_office"] != null &&
                                item["e_office"].toString().isNotEmpty)
                              Text("ई-ऑफिस क्रमांक: ${item["e_office"]}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'visit_history_list_controller.dart';
// import 'visit_history_form_screen.dart';

// class VisitHistoryListScreen extends StatefulWidget {
//   final String whatsappNumber;
//   const VisitHistoryListScreen({super.key, required this.whatsappNumber});

//   @override
//   State<VisitHistoryListScreen> createState() => _VisitHistoryListScreenState();
// }

// class _VisitHistoryListScreenState extends State<VisitHistoryListScreen> {
//   final VisitHistoryListController controller =
//       Get.put(VisitHistoryListController());

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchVisitHistory(widget.whatsappNumber);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("भेटीचा इतिहास"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.visitHistory.isEmpty) {
//           return const Center(child: Text("भेटीचा इतिहास उपलब्ध नाही"));
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: controller.visitHistory.length,
//           itemBuilder: (context, index) {
//             final item = controller.visitHistory[index];
//             //final visitorId = item["id"]; // 👈 extract visitor ID
//             final visitorId = item["visitor_id"];

//             return Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 3,
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: ListTile(
//                 onTap: () {
//                   if (visitorId != null) {
//                     Get.to(() => VisitHistoryFormScreen(visitorId: visitorId));
//                   } else {
//                     Get.snackbar("त्रुटी", "Visitor ID उपलब्ध नाही");
//                   }
//                 },
//                 leading: CircleAvatar(
//                   backgroundColor: const Color.fromARGB(186, 4, 2, 92),
//                   child: Text(
//                     (index + 1).toString(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 title: Text(
//                   item["sequence_number"] ?? "-",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Padding(
//                   padding: const EdgeInsets.only(top: 6.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("अर्जदाराचे नाव: ${item["name"] ?? "-"}"),
//                       Text("भेटीचे कारण: ${item["reason"] ?? "-"}"),
//                       //Text("अधिकारी: ${item["officer_to_meet_name"] ?? "-"}"),
//                       //Text("पोलीस स्टेशन: ${item["police_station_name"] ?? "-"}"),
//                       Text("नियुक्ती तारीख: ${item["appointment_date"] ?? "-"}"),
//                       Text("नियुक्त अधिकारी नाव: ${item["officer_name"] ?? "-"}"),
//                       Text("SP अभिप्राय: ${item["feedback"] ?? "-"}"),
//                       //Text("वेळ: ${item["time_slot"] ?? "-"}"),
//                       if (item["e_office"] != null &&
//                           item["e_office"].toString().isNotEmpty)
//                         Text("ई-ऑफिस क्रमांक: ${item["e_office"]}"),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }










