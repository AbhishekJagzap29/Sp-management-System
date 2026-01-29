import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/View/Meeting%20History/visit_history_list_screen.dart';
import 'sp_form_controller.dart';

class SpVisitorFormScreen extends StatefulWidget {
  final int visitorId;
  const SpVisitorFormScreen({super.key, required this.visitorId});

  @override
  State<SpVisitorFormScreen> createState() => _SpVisitorFormScreenState();
}

class _SpVisitorFormScreenState extends State<SpVisitorFormScreen> {
  final spSearchController = TextEditingController();
  final itarSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(SpVisitorControllerForm());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchVisitorForm(widget.visitorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SpVisitorControllerForm>();

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
              _buildReadOnlyField("भेट क्रमांक", data["sequence_number"]),
              _buildReadOnlyField("अर्जदाराचे नाव", data["name"]),
              _buildReadOnlyField("सध्याचा पत्ता", data["current_address"]),
              _buildReadOnlyField("मोबाईल नंबर (SMS)", data["sms_number"]),
              _buildReadOnlyField("मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
              _buildReadOnlyField("तक्रारीचे स्वरूप / भेटीचे कारण", data["reason"]),
              _buildReadOnlyField("तुम्हाला कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
              _buildReadOnlyField("संबंधित पोलिस स्टेशन", data["police_station_id_name"]),
              _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
              _buildReadOnlyField("नियुक्तीची वेळ", data["time_slot"]),
              _buildReadOnlyField("ई-ऑफिस क्रमांक", data["e_office"]),
              _buildReadOnlyField("समान कारणाने भेट दिली का?", data["visit_same_reason"]),
              _buildReadOnlyField("स्थिती", data["status"]),

              const SizedBox(height: 15),

              // नियुक्त अधिकारी Dropdown
              Obx(() {
                final items = controller.officers
                    .map((e) => e['officer_name']?.toString() ?? "")
                    .toList();
                items.add("इतर");
                return buildSearchableDropdown(
                  label: "नियुक्त अधिकारी",
                  items: items,
                  value: controller.selectedNiyuktAdhikari.value.isNotEmpty
                      ? controller.selectedNiyuktAdhikari.value
                      : null,
                  searchController: spSearchController,
                  hintText: "नियुक्त अधिकारी निवडा",
                  onChanged: (val) {
                    if (val == null) return;
                    if (val == "इतर") {
                      controller.isItarSelected.value = true;
                      controller.selectedNiyuktAdhikari.value = "इतर";
                      controller.selectedNiyuktAdhikariId.value = "";
                      controller.fetchOtherOfficers();
                    } else {
                      controller.isItarSelected.value = false;
                      final selectedOfficer = controller.officers
                          .firstWhere((sp) => sp['officer_name'] == val);
                      controller.selectedNiyuktAdhikari.value =
                          selectedOfficer['officer_name'].toString();
                      controller.selectedNiyuktAdhikariId.value =
                          selectedOfficer['officer_id'].toString();
                    }
                  },
                );
              }),

              const SizedBox(height: 15),

              // इतर अधिकारी Dropdown
              Obx(() {
                if (controller.isItarSelected.value) {
                  return buildSearchableDropdown(
                    label: "इतर अधिकारी निवडा",
                    items: controller.otherOfficers
                        .map((o) => o['officer_name']?.toString() ?? "")
                        .toList(),
                    value: controller.selectedOtherOfficer.value.isNotEmpty
                        ? controller.selectedOtherOfficer.value
                        : null,
                    searchController: itarSearchController,
                    hintText: "इतर अधिकारी शोधा",
                    onChanged: (val) {
                      if (val == null) return;
                      final selectedOfficer = controller.otherOfficers
                          .firstWhere((o) => o['officer_name'] == val);
                      controller.selectedOtherOfficer.value =
                          selectedOfficer['officer_name'].toString();
                      controller.selectedOtherOfficerId.value =
                          selectedOfficer['officer_id'].toString();
                    },
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 15),

              _buildMultilineTextField("सूचना", controller.soochnaController),

              const SizedBox(height: 20),

              // ✅ समाविष्ट करा Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.submitForm(widget.visitorId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
                    minimumSize: const Size(300, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Obx(() => controller.isSubmitting.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ))
                      : const Text("समाविष्ट करा")),
                ),
              ),

              const SizedBox(height: 12),

              // ✅ नवीन बटण — भेटीचा इतिहास
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       // Navigate to Meeting History Screen or any logic you want
              //       Get.snackbar("भेटीचा इतिहास", "भेटीचा इतिहास पाहण्यासाठी पुढे जा");
              //       // Example:
              //       // Get.to(() => VisitHistoryScreen(visitorId: widget.visitorId));
              //     },
              //     icon: const Icon(Icons.history, color: Colors.white),
              //     label: const Text("भेटीचा इतिहास"),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
              //       minimumSize: const Size(300, 55),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(20)),
              //       textStyle: const TextStyle(
              //           fontSize: 18, fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      final whatsappNumber = controller.visitorData["whatsapp_number"];
      if (whatsappNumber != null && whatsappNumber.isNotEmpty) {
        Get.to(() => VisitHistoryListScreen(whatsappNumber: whatsappNumber));
      } else {
        Get.snackbar("त्रुटी", "WhatsApp नंबर उपलब्ध नाही");
      }
    },
    icon: const Icon(Icons.history, color: Colors.white),
    label: const Text("भेटीचा इतिहास"),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
      minimumSize: const Size(300, 55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildMultilineTextField(String label, TextEditingController controller) {
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

  Widget buildSearchableDropdown({
    required String label,
    required List<String> items,
    required TextEditingController searchController,
    String? value,
    required Function(String?) onChanged,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) {
                final filteredItems = <String>[...items].obs;
                searchController.clear();
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    height: 400,
                    child: Column(
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: "Search",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (val) {
                            filteredItems.value = items
                                .where((e) => e.toLowerCase().contains(val.toLowerCase()))
                                .toList();
                          },
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Obx(() => ListView.builder(
                                itemCount: filteredItems.length,
                                itemBuilder: (_, index) {
                                  final item = filteredItems[index];
                                  return ListTile(
                                    title: Text(item),
                                    onTap: () {
                                      onChanged(item);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value ?? hintText,
                    style: TextStyle(color: value == null ? Colors.grey : Colors.black)),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



















// import 'package:flutter/material.dart';//------------------------------corrected without history button
// import 'package:get/get.dart';
// import 'sp_form_controller.dart';

// class SpVisitorFormScreen extends StatefulWidget {
//   final int visitorId;
//   const SpVisitorFormScreen({super.key, required this.visitorId});

//   @override
//   State<SpVisitorFormScreen> createState() => _SpVisitorFormScreenState();
// }

// class _SpVisitorFormScreenState extends State<SpVisitorFormScreen> {
//   final spSearchController = TextEditingController();
//   final itarSearchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     final controller = Get.put(SpVisitorControllerForm());
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchVisitorForm(widget.visitorId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<SpVisitorControllerForm>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागत फॉर्म"),
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
//           child: Column(
//             children: [
//               _buildReadOnlyField("अर्जदाराचे नाव", data["name"]),
//               _buildReadOnlyField("सध्याचा पत्ता", data["current_address"]),
//               _buildReadOnlyField("मोबाईल नंबर (SMS)", data["sms_number"]),
//               _buildReadOnlyField("मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
//               _buildReadOnlyField("तक्रारीचे स्वरूप / भेटीचे कारण", data["reason"]),
//               _buildReadOnlyField("तुम्हाला कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
//               _buildReadOnlyField("संबंधित पोलिस स्टेशन", data["police_station_id_name"]),
//               _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
//               _buildReadOnlyField("नियुक्तीची वेळ", data["time_slot"]),
//               _buildReadOnlyField("स्थिती", data["status"]),

//               const SizedBox(height: 15),

//               // नियुक्त अधिकारी Dropdown
//               Obx(() {
//                 final items = controller.officers
//                     .map((e) => e['officer_name']?.toString() ?? "")
//                     .toList();
//                 items.add("इतर");
//                 return buildSearchableDropdown(
//                   label: "नियुक्त अधिकारी",
//                   items: items,
//                   value: controller.selectedNiyuktAdhikari.value.isNotEmpty
//                       ? controller.selectedNiyuktAdhikari.value
//                       : null,
//                   searchController: spSearchController,
//                   hintText: "नियुक्त अधिकारी निवडा",
//                   onChanged: (val) {
//                     if (val == null) return;
//                     if (val == "इतर") {
//                       controller.isItarSelected.value = true;
//                       controller.selectedNiyuktAdhikari.value = "इतर";
//                       controller.selectedNiyuktAdhikariId.value = "";
//                       controller.fetchOtherOfficers();
//                     } else {
//                       controller.isItarSelected.value = false;
//                       final selectedOfficer = controller.officers
//                           .firstWhere((sp) => sp['officer_name'] == val);
//                       controller.selectedNiyuktAdhikari.value =
//                           selectedOfficer['officer_name'].toString();
//                       controller.selectedNiyuktAdhikariId.value =
//                           selectedOfficer['officer_id'].toString();
//                     }
//                   },
//                 );
//               }),

//               const SizedBox(height: 15),

//               // इतर अधिकारी Dropdown
//               Obx(() {
//                 if (controller.isItarSelected.value) {
//                   return buildSearchableDropdown(
//                     label: "इतर अधिकारी निवडा",
//                     items: controller.otherOfficers
//                         .map((o) => o['officer_name']?.toString() ?? "")
//                         .toList(),
//                     value: controller.selectedOtherOfficer.value.isNotEmpty
//                         ? controller.selectedOtherOfficer.value
//                         : null,
//                     searchController: itarSearchController,
//                     hintText: "इतर अधिकारी शोधा",
//                     onChanged: (val) {
//                       if (val == null) return;
//                       final selectedOfficer = controller.otherOfficers
//                           .firstWhere((o) => o['officer_name'] == val);
//                       controller.selectedOtherOfficer.value =
//                           selectedOfficer['officer_name'].toString();
//                       controller.selectedOtherOfficerId.value =
//                           selectedOfficer['officer_id'].toString();
//                     },
//                   );
//                 }
//                 return const SizedBox.shrink();
//               }),

//               const SizedBox(height: 15),

//               _buildMultilineTextField("सूचना", controller.soochnaController),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await controller.submitForm(widget.visitorId);
//                     // Show popup message on success
//                     // if (controller.submitSuccess.value) {
//                     //   // Go back to previous page after short delay
//                     //   Future.delayed(const Duration(seconds: 1), () {
//                     //     Navigator.pop(context, true);
//                     //   });
//                     // }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//                     minimumSize: const Size(300, 55),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     textStyle: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   child: Obx(() => controller.isSubmitting.value
//                       ? const SizedBox(
//                           height: 18,
//                           width: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ))
//                       : const Text("समाविष्ट करा")),
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

//   Widget _buildMultilineTextField(String label, TextEditingController controller) {
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

//   Widget buildSearchableDropdown({
//     required String label,
//     required List<String> items,
//     required TextEditingController searchController,
//     String? value,
//     required Function(String?) onChanged,
//     required String hintText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//         const SizedBox(height: 6),
//         InkWell(
//           onTap: () {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder: (_) {
//                 final filteredItems = <String>[...items].obs;
//                 searchController.clear();
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     height: 400,
//                     child: Column(
//                       children: [
//                         TextField(
//                           controller: searchController,
//                           decoration: InputDecoration(
//                             labelText: "Search",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                           onChanged: (val) {
//                             filteredItems.value = items
//                                 .where((e) => e.toLowerCase().contains(val.toLowerCase()))
//                                 .toList();
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         Expanded(
//                           child: Obx(() => ListView.builder(
//                                 itemCount: filteredItems.length,
//                                 itemBuilder: (_, index) {
//                                   final item = filteredItems[index];
//                                   return ListTile(
//                                     title: Text(item),
//                                     onTap: () {
//                                       onChanged(item);
//                                       Navigator.pop(context);
//                                     },
//                                   );
//                                 },
//                               ))),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(value ?? hintText,
//                     style: TextStyle(color: value == null ? Colors.grey : Colors.black)),
//                 const Icon(Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

























// working code -------------------------------------------------- 25/09/2025--------11.25am----------
// // lib/Screen/View/Forms/sp_visitor_form.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_form_controller.dart';

// class SpVisitorFormScreen extends StatelessWidget {
//   final int visitorId;
//   const SpVisitorFormScreen({super.key, required this.visitorId});

//   @override
//   Widget build(BuildContext context) {
//     final SpVisitorControllerForm controller =
//         Get.put(SpVisitorControllerForm());

//     // Fetch on open
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchVisitorForm(visitorId);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागत फॉर्म"),
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
//           child: Column(
//             children: [
//               _buildReadOnlyField("अर्जदाराचे नाव", data["name"]),
//               _buildReadOnlyField("सध्याचा पत्ता", data["current_address"]),
//               _buildReadOnlyField("मोबाईल नंबर (SMS)", data["sms_number"]),
//               _buildReadOnlyField("मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
//               _buildReadOnlyField("तक्रारीचे स्वरूप / भेटीचे कारण", data["reason"]),
//               _buildReadOnlyField("तुम्हाला कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
//               _buildReadOnlyField("संबंधित पोलिस स्टेशन", data["police_station_id_name"]),
//               _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
//               _buildReadOnlyField("नियुक्तीची वेळ", data["time_slot"]),
//               _buildReadOnlyField("स्थिती", data["status"]),

//               // Editable dropdown for नियुक्त अधिकारी (fetched from API)
//               Obx(() {
//                 final officers = controller.officers;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: DropdownButtonFormField<String>(
//                     value: controller.selectedNiyuktAdhikari.value.isEmpty
//                         ? null
//                         : controller.selectedNiyuktAdhikari.value,
//                     decoration: InputDecoration(
//                       labelText: "नियुक्त अधिकारी",
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     items: officers.map((e) {
//                       return DropdownMenuItem<String>(
//                         value: e['officer_id'].toString(),
//                         child: Text(e['officer_name']?.toString() ?? ''),
//                       );
//                     }).toList(),
//                     onChanged: (val) {
//                       controller.selectedNiyuktAdhikari.value = val ?? '';
//                     },
//                   ),
//                 );
//               }),

//               _buildMultilineTextField("सूचना", controller.soochnaController),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     // simple validation
//                     Navigator.pop(context, true);
//                     if (controller.selectedNiyuktAdhikari.value.isEmpty) {
//                       Get.snackbar("त्रुटी", "कृपया नियुक्त अधिकारी निवडा");
//                       return;
//                     }
//                     if (controller.soochnaController.text.trim().isEmpty) {
//                       Get.snackbar("त्रुटी", "कृपया सूचना भरा");
//                       return;
//                     }

//                     await controller.submitForm(visitorId);
//                   },
//                   style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//                         minimumSize: const Size(300, 55),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         textStyle: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                   child: Obx(() => controller.isSubmitting.value
//                       ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                       : const Text("समाविष्ट करा")),
                      
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

//   Widget _buildMultilineTextField(String label, TextEditingController controller) {
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
// import 'package:sp_manage_system/Screen/View/Forms/sp_form_controller.dart';

// class SpVisitorFormScreen extends StatelessWidget {
//   final int visitorId;
//   const SpVisitorFormScreen({super.key, required this.visitorId});

//   @override
//   Widget build(BuildContext context) {
//     final SpVisitorControllerForm controller =
//         Get.put(SpVisitorControllerForm());
//     controller.fetchVisitorForm(visitorId);

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
//               _buildReadOnlyField("मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
//               _buildReadOnlyField("तक्रारीचे स्वरूप / भेटीचे कारण", data["reason"]),
//               _buildReadOnlyField("तुम्हाला कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
//               _buildReadOnlyField("संबंधित पोलिस स्टेशन", data["police_station_id_name"]),
//               _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
//               _buildReadOnlyField("नियुक्तीची वेळ", data["time_slot"]),
//               _buildReadOnlyField("स्थिती", data["status"]),

//               // Editable dropdown for नियुक्त अधिकारी
//               Obx(() => 
//               _buildDropdown(
//   "नियुक्त अधिकारी",
//   controller.selectedNiyuktAdhikari.value,
//   controller.officers
//       .map((e) => {"id": e["officer_id"].toString(), "name": e["officer_name"]})
//       .toList(),
//   (val) => controller.selectedNiyuktAdhikari.value = val ?? '',
// ),

//               ),

//               _buildMultilineTextField("सूचना", controller.soochnaController),

//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                  //   controller.submitForm(visitorId);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(fontSize: 16),
//                   ),
//                   child: const Text("सबमिट करा"),
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

//   Widget _buildDropdown(
//     String label,
//     String? selectedValue,
//     List<Map<String, dynamic>> options,
//     void Function(String?) onChanged,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: DropdownButtonFormField<String>(
//         value: selectedValue != "" ? selectedValue : null,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         items: options
//             .map((e) => DropdownMenuItem(
//                   value: e["id"].toString(),
//                   child: Text(e["name"].toString()),
//                 ))
//             .toList(),
//         onChanged: onChanged,
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
//         maxLines: 3,
//       ),
//     );
//   }
// }
