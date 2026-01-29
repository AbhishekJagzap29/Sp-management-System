import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pi_form_controller.dart';

class PiFormScreen extends StatelessWidget {
  final int visitorId;
  const PiFormScreen({super.key, required this.visitorId});

  @override
  Widget build(BuildContext context) {
    final PiFormController controller = Get.put(PiFormController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchVisitorForm(visitorId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("अभ्यागत फॉर्म"),
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

        final data = controller.visitorData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildReadOnlyField("अर्जदाराचे नाव", data["name"]),
              _buildReadOnlyField("भेट क्रमांक:", data["sequence_number"]),
              _buildReadOnlyField("सध्याचा पत्ता", data["current_address"]),
              _buildReadOnlyField("मोबाईल नंबर (SMS)", data["sms_number"]),
              _buildReadOnlyField(
                  "मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
              _buildReadOnlyField("ईमेल", data["email"]),
              _buildReadOnlyField(
                  "तक्रारीचे स्वरूप / भेटीचे कारण", data["reason"]),
              _buildReadOnlyField(
                  "तुम्हाला कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
              _buildReadOnlyField(
                  "संबंधित पोलिस स्टेशन", data["police_station_id_name"]),
              _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
              _buildReadOnlyField("नियुक्तीची वेळ", data["time_slot"]),
              _buildReadOnlyField("स्थिती", data["status"]),

              // Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.meetingConfirmed.value.isEmpty
                          ? null
                          : controller.meetingConfirmed.value,
                      decoration: InputDecoration(
                        labelText: "तक्रारदाराशी भेटीची तारीख निश्चित केली आहे का?",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      items: const [
                        DropdownMenuItem(value: "होय", child: Text("होय")),
                        DropdownMenuItem(value: "नाही", child: Text("नाही")),
                      ],
                      onChanged: (val) {
                        controller.meetingConfirmed.value = val ?? '';
                      },
                    )),
              ),

              _buildMultilineTextField("अभिप्राय", controller.soochnaController),

              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.submitForm(visitorId);
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
                        minimumSize: const Size(300, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  child: Obx(() => controller.isSubmitting.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text("समाविष्ट करा")),
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

  Widget _buildMultilineTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        maxLines: 4,
      ),
    );
  }
}



















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'pi_form_controller.dart';

// class PiFormScreen extends StatelessWidget {
//   final int visitorId;
//   const PiFormScreen({super.key, required this.visitorId});

//   @override
//   Widget build(BuildContext context) {
//     final PiFormController controller = Get.put(PiFormController());

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchVisitorForm(visitorId);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागत फॉर्म"),
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
//           child: Column(
//             children: [
//               _buildReadOnlyField("अर्जदाराचे नाव", data["name"]),
//               _buildReadOnlyField("सध्याचा पत्ता", data["current_address"]),
//               _buildReadOnlyField("मोबाईल नंबर (SMS)", data["sms_number"]),
//               _buildReadOnlyField(
//                   "मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
//               _buildReadOnlyField("ईमेल", data["email"]),
//               _buildReadOnlyField(
//                   "तक्रारीचे स्वरूप / भेटीचे कारण", data["reason"]),
//               _buildReadOnlyField(
//                   "तुम्हाला कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
//               _buildReadOnlyField(
//                   "संबंधित पोलिस स्टेशन", data["police_station_id_name"]),
//               _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
//               _buildReadOnlyField("नियुक्तीची वेळ", data["time_slot"]),
//               _buildReadOnlyField("स्थिती", data["status"]),

//               // Dropdown
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Obx(() => DropdownButtonFormField<String>(
//                       value: controller.meetingConfirmed.value.isEmpty
//                           ? null
//                           : controller.meetingConfirmed.value,
//                       decoration: InputDecoration(
//                         labelText: "तक्रदाराशी भेटीची तारीख निश्चित केली अहे का?",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       items: const [
//                         DropdownMenuItem(value: "होय", child: Text("होय")),
//                         DropdownMenuItem(value: "नाही", child: Text("नाही")),
//                       ],
//                       onChanged: (val) {
//                         controller.meetingConfirmed.value = val ?? '';
//                       },
//                     )),
//               ),

//               _buildMultilineTextField("अभिप्राय", controller.soochnaController),

//               const SizedBox(height: 20),

//               // ✅ Button section
//               Obx(() {
//                 if (controller.isSubmitted.value) {
//                   // After submission show close button
//                   return SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async =>
//                           await controller.closeForm(visitorId),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         textStyle: const TextStyle(fontSize: 16),
//                       ),
//                       child: controller.isSubmitting.value
//                           ? const SizedBox(
//                               height: 18,
//                               width: 18,
//                               child: CircularProgressIndicator(
//                                   strokeWidth: 2, color: Colors.white))
//                           : const Text("अर्ज बंद करा"),
//                     ),
//                   );
//                 } else {
//                   // Before submission show submit button
//                   return SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async =>
//                           await controller.submitForm(visitorId),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         textStyle: const TextStyle(fontSize: 16),
//                       ),
//                       child: controller.isSubmitting.value
//                           ? const SizedBox(
//                               height: 18,
//                               width: 18,
//                               child: CircularProgressIndicator(
//                                   strokeWidth: 2, color: Colors.white))
//                           : const Text("सबमिट करा"),
//                     ),
//                   );
//                 }
//               }),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildReadOnlyField(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         initialValue: value?.toString() ?? "-",
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         readOnly: true,
//       ),
//     );
//   }

//   Widget _buildMultilineTextField(
//       String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         maxLines: 4,
//       ),
//     );
//   }
// }





















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'pi_form_controller.dart';

// class PiFormScreen extends StatelessWidget {
//   final int visitorId;
//   const PiFormScreen({super.key, required this.visitorId});

//   @override
//   Widget build(BuildContext context) {
//     final PiFormController controller = Get.put(PiFormController());

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchVisitorForm(visitorId);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागत फॉर्म"),
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
//           child: Column(
//             children: [
//               _buildReadOnlyField("अर्जदाराचे नाव", data["name"]),
//               _buildReadOnlyField("सध्याचा पत्ता", data["current_address"]),
//               _buildReadOnlyField("मोबाईल नंबर (SMS)", data["sms_number"]),
//               _buildReadOnlyField(
//                   "मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
//               _buildReadOnlyField("ईमेल", data["email"]),
//               _buildReadOnlyField(
//                   "तक्रारीचे स्वरूप / भेटीचे कारण", data["reason"]),
//               _buildReadOnlyField(
//                   "तुम्हाला कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
//               _buildReadOnlyField(
//                   "संबंधित पोलिस स्टेशन", data["police_station_id_name"]),
//               _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
//               _buildReadOnlyField("नियुक्तीची वेळ", data["time_slot"]),
//               _buildReadOnlyField("स्थिती", data["status"]),

//               // Dropdown
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Obx(() => DropdownButtonFormField<String>(
//                       value: controller.meetingConfirmed.value.isEmpty
//                           ? null
//                           : controller.meetingConfirmed.value,
//                       decoration: InputDecoration(
//                         labelText: "तक्रदाराशी भेटीची तारीख निश्चित केली अहे का?",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       items: const [
//                         DropdownMenuItem(value: "होय", child: Text("होय")),
//                         DropdownMenuItem(value: "नाही", child: Text("नाही")),
//                       ],
//                       onChanged: (val) {
//                         controller.meetingConfirmed.value = val ?? '';
//                       },
//                     )),
//               ),

//               _buildMultilineTextField("अभिप्राय", controller.soochnaController),

//               const SizedBox(height: 20),

//               // ✅ Button section
//               Obx(() {
//                 if (controller.isSubmitted.value) {
//                   // After submission show close button
//                   return SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: controller.closeForm,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         textStyle: const TextStyle(fontSize: 16),
//                       ),
//                       child: const Text("अर्ज बंद करा"),
//                     ),
//                   );
//                 } else {
//                   // Before submission show submit button
//                   return SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async =>
//                           await controller.submitForm(visitorId),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         textStyle: const TextStyle(fontSize: 16),
//                       ),
//                       child: Obx(() => controller.isSubmitting.value
//                           ? const SizedBox(
//                               height: 18,
//                               width: 18,
//                               child: CircularProgressIndicator(
//                                   strokeWidth: 2, color: Colors.white))
//                           : const Text("सबमिट करा")),
//                     ),
//                   );
//                 }
//               }),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildReadOnlyField(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         initialValue: value?.toString() ?? "-",
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         readOnly: true,
//       ),
//     );
//   }

//   Widget _buildMultilineTextField(
//       String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         maxLines: 4,
//       ),
//     );
//   }
// }



















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'pi_form_controller.dart';

// class PiFormScreen extends StatelessWidget {
//   final int visitorId;
//   const PiFormScreen({super.key, required this.visitorId});

//   @override
//   Widget build(BuildContext context) {
//     final PiFormController controller = Get.put(PiFormController());

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchVisitorForm(visitorId);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागत फॉर्म"),
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
//           child: Column(
//             children: [
//               _buildReadOnlyField("अर्जदाराचे नाव", data["name"]),
//               _buildReadOnlyField("सध्याचा पत्ता", data["current_address"]),
//               _buildReadOnlyField("मोबाईल नंबर (SMS)", data["sms_number"]),
//               _buildReadOnlyField(
//                   "मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
//               _buildReadOnlyField("ईमेल", data["email"]),
//               _buildReadOnlyField(
//                   "तक्रारीचे स्वरूप / भेटीचे कारण", data["reason"]),
//               _buildReadOnlyField(
//                   "तुम्हाला कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
//               _buildReadOnlyField(
//                   "संबंधित पोलिस स्टेशन", data["police_station_id_name"]),
//               _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
//               _buildReadOnlyField("नियुक्तीची वेळ", data["time_slot"]),
//               _buildReadOnlyField("स्थिती", data["status"]),

//               // Dropdown
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Obx(() => DropdownButtonFormField<String>(
//                       value: controller.meetingConfirmed.value.isEmpty
//                           ? null
//                           : controller.meetingConfirmed.value,
//                       decoration: InputDecoration(
//                         labelText: "तक्रदाराशी भेटीची तारीख निश्चित केली अहे का?",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       items: const [
//                         DropdownMenuItem(value: "होय", child: Text("होय")),
//                         DropdownMenuItem(value: "नाही", child: Text("नाही")),
//                       ],
//                       onChanged: (val) {
//                         controller.meetingConfirmed.value = val ?? '';
//                       },
//                     )),
//               ),

//               _buildMultilineTextField("अभिप्राय", controller.soochnaController),

//               const SizedBox(height: 20),

//               // Submit button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async => await controller.submitForm(visitorId),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(fontSize: 16),
//                   ),
//                   child: Obx(() => controller.isSubmitting.value
//                       ? const SizedBox(
//                           height: 18,
//                           width: 18,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2, color: Colors.white))
//                       : const Text("सबमिट करा")),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildReadOnlyField(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         initialValue: value?.toString() ?? "-",
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         readOnly: true,
//       ),
//     );
//   }

//   Widget _buildMultilineTextField(
//       String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         maxLines: 4,
//       ),
//     );
//   }
// }

