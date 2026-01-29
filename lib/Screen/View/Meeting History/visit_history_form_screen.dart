import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'visit_history_form_controller.dart';

class VisitHistoryFormScreen extends StatefulWidget {
  final int visitorId;
  const VisitHistoryFormScreen({super.key, required this.visitorId});

  @override
  State<VisitHistoryFormScreen> createState() => _VisitHistoryFormScreenState();
}

class _VisitHistoryFormScreenState extends State<VisitHistoryFormScreen> {
  final VisitHistoryFormController controller =
      Get.put(VisitHistoryFormController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchVisitorForm(widget.visitorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("भेटीचा फॉर्म"),
        backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.visitorData.isEmpty) {
          return const Center(child: Text("डेटा उपलब्ध नाही"));
        }

        final v = controller.visitorData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildReadOnlyField("भेट क्रमांक", v["sequence_number"]),
              _buildReadOnlyField("अर्जदाराचे नाव", v["name"]),
              _buildReadOnlyField("मोबाईल क्रमांक (SMS)", v["sms_number"]),
              _buildReadOnlyField("व्हॉट्सअ‍ॅप क्रमांक", v["whatsapp_number"]),
              _buildReadOnlyField("सध्याचा पत्ता", v["current_address"]),
              _buildReadOnlyField("भेटीचे कारण", v["reason"]),
              _buildReadOnlyField("अधिकारी", v["officer_to_meet_name"]),
              _buildReadOnlyField("पोलीस स्टेशन", v["police_station_id_name"]),
              _buildReadOnlyField("नियुक्ती तारीख", v["appointment_date"]),
              _buildReadOnlyField("नियुक्ती वेळ", v["time_slot"]),
              _buildReadOnlyField("ई-ऑफिस क्रमांक", v["e_office"]),
              _buildReadOnlyField("नियुक्त अधिकारी नाव", v["officer_name"]),
              _buildReadOnlyField("SP अभिप्राय", v["feedback"]),
              _buildReadOnlyField("तक्रारदाराशी भेटीची तारीख निश्चित केली आहे का?", v["date_fixed"]),
              _buildReadOnlyField("PI अभिप्राय", v["pi_feedback"]),
              _buildReadOnlyField("स्थिती", v["status"]),

              const SizedBox(height: 20),

              // ✅ Back Button or Navigation Option
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("मागे जा"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
                    minimumSize: const Size(300, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReadOnlyField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value?.toString() ?? "-",
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        readOnly: true,
      ),
    );
  }
}















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'visit_history_form_controller.dart';

// class VisitHistoryFormScreen extends StatefulWidget {
//   final int visitorId;
//   const VisitHistoryFormScreen({super.key, required this.visitorId});

//   @override
//   State<VisitHistoryFormScreen> createState() => _VisitHistoryFormScreenState();
// }

// class _VisitHistoryFormScreenState extends State<VisitHistoryFormScreen> {
//   final VisitHistoryFormController controller =
//       Get.put(VisitHistoryFormController());

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchVisitorForm(widget.visitorId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("भेटीचा फॉर्म"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.visitorData.isEmpty) {
//           return const Center(child: Text("डेटा उपलब्ध नाही"));
//         }

//         final v = controller.visitorData;

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               infoTile("भेट क्रमांक", v["sequence_number"]),
//               infoTile("अर्जदाराचे नाव", v["name"]),
//               infoTile("मोबाईल क्रमांक", v["sms_number"]),
//               infoTile("व्हॉट्सअ‍ॅप क्रमांक", v["whatsapp_number"]),
//               infoTile("ई-मेल", v["email"]),
//               infoTile("पत्ता", v["current_address"]),
//               infoTile("भेटीचे कारण", v["reason"]),
//               infoTile("अधिकारी", v["officer_to_meet_name"]),
//               infoTile("पोलीस स्टेशन", v["police_station_id_name"]),
//               infoTile("नियुक्ती तारीख", v["appointment_date"]),
//               infoTile("वेळ", v["time_slot"]),
//               infoTile("ई-ऑफिस क्रमांक", v["e_office"]),
//               infoTile("स्थिती", v["status"]),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget infoTile(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//               flex: 4,
//               child: Text(
//                 "$label:",
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               )),
//           Expanded(
//               flex: 6,
//               child: Text(
//                 value != null && value.toString().isNotEmpty
//                     ? value.toString()
//                     : "-",
//                 style: const TextStyle(fontSize: 15),
//               )),
//         ],
//       ),
//     );
//   }
// }
















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'visit_history_form_controller.dart';

// class VisitHistoryFormScreen extends StatefulWidget {
//   final int visitorId;
//   const VisitHistoryFormScreen({super.key, required this.visitorId});

//   @override
//   State<VisitHistoryFormScreen> createState() => _VisitHistoryFormScreenState();
// }

// class _VisitHistoryFormScreenState extends State<VisitHistoryFormScreen> {
//   final VisitHistoryFormController controller =
//       Get.put(VisitHistoryFormController());

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchVisitorForm(widget.visitorId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("भेटीचा फॉर्म"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.visitorData.isEmpty) {
//           return const Center(child: Text("डेटा उपलब्ध नाही"));
//         }

//         final data = controller.visitorData;

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildRow("भेट क्रमांक", data["sequence_number"]),
//                   _buildRow("अर्जदाराचे नाव", data["name"]),
//                   _buildRow("एसएमएस क्रमांक", data["sms_number"]),
//                   _buildRow("व्हॉट्सअॅप क्रमांक", data["whatsapp_number"]),
//                   _buildRow("ई-मेल", data["email"]),
//                   _buildRow("सध्याचा पत्ता", data["current_address"]),
//                   _buildRow("भेटीचे कारण", data["reason"]),
//                   _buildRow("अधिकारी", data["officer_to_meet_name"]),
//                   _buildRow("पोलीस स्टेशन", data["police_station_id_name"]),
//                   _buildRow("नियुक्ती तारीख", data["appointment_date"]),
//                   _buildRow("वेळ स्लॉट", data["time_slot"]),
//                   _buildRow("ई-ऑफिस क्रमांक", data["e_office"]),
//                   _buildRow("स्थिती", data["status"]),
//                   _buildRow("अधिकारी अभिप्राय", data["pi_feedback"]),
//                   _buildRow("Feedback", data["feedback"]),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildRow(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 4,
//             child: Text(
//               "$label:",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 6,
//             child: Text(
//               value?.toString() ?? "-",
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
