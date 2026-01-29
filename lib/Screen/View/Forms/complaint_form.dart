import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/View/Forms/complaint_form_controller.dart';

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final ComplaintFormController controller = Get.put(ComplaintFormController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController smsMobileController = TextEditingController();
  final TextEditingController officeNumberController = TextEditingController(); // ✅ New field

  bool isSameNumber = false;
  String? selectedSP;
  String? selectedPoliceStation;
  DateTime? appointmentDate;
  String? selectedAppointmentTime;

  String? metPrabhari;
  String? metSDPO;
  String? metAdditionalSP;
  String? visitSameReason;

  // Search controllers for dropdowns
  final TextEditingController spSearchController = TextEditingController();
  final TextEditingController policeStationSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchSPList();
    controller.fetchPoliceStations();
    controller.fetchTimeSlots();
  }

  String? _mapYesNo(String? value) {
    if (value == "होय") return "yes";
    if (value == "नाही") return "no";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("अर्ज"),
        backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
        centerTitle: true,
      ),
      body: GetBuilder<ComplaintFormController>(builder: (_) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildFormField(controller: nameController, label: "अर्जदाराचे नाव"),
                    const SizedBox(height: 15),
                    buildFormField(controller: addressController, label: "सध्याचा पत्ता", maxLines: 2),
                    const SizedBox(height: 15),

                    if (!isSameNumber)
                      buildMobileField(controller: smsMobileController, label: "मोबाईल नंबर (SMS)"),
                    if (!isSameNumber) const SizedBox(height: 15),

                    buildMobileField(controller: mobileController, label: "मोबाईल नंबर (WhatsApp)"),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isSameNumber,
                          onChanged: (val) {
                            setState(() {
                              isSameNumber = val ?? false;
                              if (isSameNumber) {
                                mobileController.text = smsMobileController.text;
                              } else {
                                mobileController.clear();
                              }
                            });
                          },
                        ),
                        const Text("SMS आणि WhatsApp नंबर सारखे आहे का?"),
                      ],
                    ),
                    const SizedBox(height: 15),

                    buildSearchableDropdown(
                      label: 'तुम्हाला कोणाला भेटायचे आहे ?',
                      value: selectedSP,
                      onChanged: (val) {
                        setState(() {
                          selectedSP = val;
                          if (val != null) {
                            final selectedOfficer = controller.spOfficers.firstWhere((sp) => sp.spName == val);
                            controller.selectedSpId = selectedOfficer.spId.toString();
                          }
                        });
                      },
                      items: controller.spOfficers.map((sp) => sp.spName).toList(),
                      searchController: spSearchController,
                      hintText: "तुम्हाला कोणाला भेटायचे आहे ?",
                    ),

                    const SizedBox(height: 15),

                    buildFormField(controller: reasonController, label: "तक्रारीचे स्वरूप / भेटीचे कारण", maxLines: 3),
                    const SizedBox(height: 15),

                    buildSearchableDropdown(
                      label: "संबंधित पोलिस स्टेशन?",
                      value: selectedPoliceStation,
                      onChanged: (val) {
                        setState(() {
                          selectedPoliceStation = val;
                          if (val != null) {
                            final selectedPS =
                                controller.policeStations.firstWhere((ps) => ps.policeStationName == val);
                            controller.selectedPoliceStationId = selectedPS.policeStationId.toString();
                          }
                        });
                      },
                      items: controller.policeStations.map((ps) => ps.policeStationName).toList(),
                      searchController: policeStationSearchController,
                      hintText: "संबंधित पोलिस स्टेशन?",
                    ),

                    const SizedBox(height: 15),

                    buildDropdown(
                        label: "संबंधित प्रभारीची भेट घेतली?",
                        value: metPrabhari,
                        onChanged: (val) => setState(() => metPrabhari = val)),
                    const SizedBox(height: 15),

                    buildDropdown(
                        label: "संबंधित SDPOची भेट घेतली?",
                        value: metSDPO,
                        onChanged: (val) => setState(() => metSDPO = val)),
                    const SizedBox(height: 15),

                    buildDropdown(
                        label: "संबंधित Additional SPची भेट घेतली?",
                        value: metAdditionalSP,
                        onChanged: (val) => setState(() => metAdditionalSP = val)),
                    const SizedBox(height: 15),

                    buildDropdown(
                      label: "आधी याच कारणासाठी भेट दिली आहे का?",
                      value: visitSameReason,
                      onChanged: (val) => setState(() => visitSameReason = val),
                    ),

                    const SizedBox(height: 15),

                    /// ✅ New Field: E-office Number
                    buildFormField(
                      controller: officeNumberController,
                      label: "ई-ऑफिस क्रमांक",
                      type: TextInputType.text,
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      readOnly: true,
                      validator: (_) => appointmentDate == null ? "कृपया तारीख निवडा" : null,
                      decoration: InputDecoration(
                        labelText: "नियुक्तीची तारीख",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() {
                                appointmentDate = picked;
                              });
                            }
                          },
                        ),
                      ),
                      controller: TextEditingController(
                        text: appointmentDate != null
                            ? "${appointmentDate!.day}-${appointmentDate!.month}-${appointmentDate!.year}"
                            : "",
                      ),
                    ),

                    const SizedBox(height: 15),

                    buildDropdowns(
                      label: "नियुक्तीची वेळ",
                      value: selectedAppointmentTime,
                      onChanged: (val) {
                        setState(() {
                          selectedAppointmentTime = val;
                          if (val != null) {
                            final selectedSlot = controller.timeSlots.firstWhere((slot) => slot.label == val);
                            controller.selectedTimeSlotValue = selectedSlot.value;
                            controller.selectedTimeSlotLabel = selectedSlot.label;
                          }
                        });
                      },
                      items: controller.timeSlots.map((slot) => slot.label).toList(),
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
                          minimumSize: const Size(300, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final formData = {
                              "name": nameController.text,
                              "sms_number": smsMobileController.text,
                              "is_same_number": isSameNumber,
                              "whatsapp_number": mobileController.text,
                              "current_address": addressController.text,
                              "reason": reasonController.text,
                              "sp_id": controller.selectedSpId,
                              "police_station_id": controller.selectedPoliceStationId,
                              "prabhari_meeting": _mapYesNo(metPrabhari),
                              "sdpo_meeting": _mapYesNo(metSDPO),
                              "additional_sp_meeting": _mapYesNo(metAdditionalSP),
                              "visit_same_reason": _mapYesNo(visitSameReason),
                              "appointment_date": appointmentDate != null
                                  ? "${appointmentDate!.year}-${appointmentDate!.month}-${appointmentDate!.day}"
                                  : null,
                              "time_slot": controller.selectedTimeSlotValue,
                              "e_office": officeNumberController.text, // ✅ sending to backend
                            };

                            controller.setSubmitting(true);
                            final result = await controller.createVisitor(formData);
                            controller.setSubmitting(false);

                            if (result["status"] == "success") {
                              customSnackBar("यशस्वी", "नवीन भेट नोंदवण्यात आली आहे");
                              Navigator.pop(context, true);
                            } else {
                              customSnackBar("त्रुटी", result["message"], isError: true);
                            }
                          } else {
                            customSnackBar("त्रुटी", "कृपया सर्व फील्ड योग्य भरा", isError: true);
                          }
                        },
                        child: Obx(() => controller.isSubmitting.value
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text("समाविष्ट करा")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void customSnackBar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      "",
      "",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      backgroundColor: const Color(0xFF607D8B),
      borderRadius: 12,
      borderWidth: 2,
      borderColor: Colors.black26,
      icon: Icon(isError ? Icons.close_rounded : Icons.done_all, color: Colors.white),
      titleText: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      messageText: Text(message, style: const TextStyle(fontSize: 14, color: Colors.white)),
      duration: const Duration(seconds: 3),
    );
  }

  // === Helper Widgets ===
  Widget buildFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "कृपया $label भरा";
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 6, 51, 131), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget buildMobileField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "कृपया $label भरा";
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) return "कृपया वैध 10 अंकी मोबाईल नंबर भरा";
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        counterText: "",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 6, 51, 131), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget buildDropdowns({
    required String label,
    required String? value,
    required void Function(String?) onChanged,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 6, 51, 131), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      value: value,
      validator: (val) => val == null ? "कृपया निवडा" : null,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: value,
      validator: (val) => val == null ? "कृपया निवडा" : null,
      items: const [
        DropdownMenuItem(value: "होय", child: Text("होय")),
        DropdownMenuItem(value: "नाही", child: Text("नाही")),
      ],
      onChanged: onChanged,
    );
  }

  Widget buildSearchableDropdown({
    required String label,
    required String? value,
    required void Function(String?) onChanged,
    required List<String> items,
    required TextEditingController searchController,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: Text(value ?? hintText,
                style: TextStyle(color: value != null ? Colors.black : Colors.grey.shade600)),
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(hintText: "शोधा...", border: OutlineInputBorder()),
                  onChanged: (query) => setState(() {}),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  children: items
                      .where((item) =>
                          item.toLowerCase().contains(searchController.text.toLowerCase()))
                      .map((filtered) => ListTile(
                            title: Text(filtered),
                            onTap: () => onChanged(filtered),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}













// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/complaint_form_controller.dart';

// class ComplaintFormScreen extends StatefulWidget {
//   const ComplaintFormScreen({super.key});

//   @override
//   State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
// }

// class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
//   final ComplaintFormController controller = Get.put(ComplaintFormController());

//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController reasonController = TextEditingController();
//   final TextEditingController smsMobileController = TextEditingController();
//   final TextEditingController officeNumberController = TextEditingController();

//   bool isSameNumber = false;
//   String? selectedSP;
//   String? selectedPoliceStation;
//   DateTime? appointmentDate;
//   String? selectedAppointmentTime;

//   String? metPrabhari;
//   String? metSDPO;
//   String? metAdditionalSP;
//   String? visitSameReason;

//   // Search controllers for dropdowns
//   final TextEditingController spSearchController = TextEditingController();
//   final TextEditingController policeStationSearchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchSPList();
//     controller.fetchPoliceStations();
//     controller.fetchTimeSlots();
//   }

//   /// ✅ Convert Marathi → API expected value
//   String? _mapYesNo(String? value) {
//     if (value == "होय") return "yes";
//     if (value == "नाही") return "no";
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अर्ज"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//         centerTitle: true,
//       ),
//       body: GetBuilder<ComplaintFormController>(builder: (_) {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     buildFormField(
//                         controller: nameController, label: "अर्जदाराचे नाव"),
//                     const SizedBox(height: 15),
//                     buildFormField(
//                         controller: addressController,
//                         label: "सध्याचा पत्ता",
//                         maxLines: 2),
//                     const SizedBox(height: 15),

//                     if (!isSameNumber)
//                       buildMobileField(
//                         controller: smsMobileController,
//                         label: "मोबाईल नंबर (SMS)",
//                       ),
//                     if (!isSameNumber) const SizedBox(height: 15),

//                     buildMobileField(
//                       controller: mobileController,
//                       label: "मोबाईल नंबर (WhatsApp)",
//                     ),

//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: isSameNumber,
//                           onChanged: (val) {
//                             setState(() {
//                               isSameNumber = val ?? false;
//                               if (isSameNumber) {
//                                 mobileController.text =
//                                     smsMobileController.text;
//                               } else {
//                                 mobileController.clear();
//                               }
//                             });
//                           },
//                         ),
//                         const Text("SMS आणि WhatsApp नंबर सारखे आहे का?"),
//                       ],
//                     ),
//                     const SizedBox(height: 15),

//                     // Searchable SP Dropdown
//                     buildSearchableDropdown(
//                       label: 'तुम्हाला कोणाला भेटायचे आहे ?',
//                       value: selectedSP,
//                       onChanged: (val) {
//                         setState(() {
//                           selectedSP = val;
//                           if (val != null) {
//                             final selectedOfficer = controller.spOfficers
//                                 .firstWhere((sp) => sp.spName == val);
//                             controller.selectedSpId =
//                                 selectedOfficer.spId.toString();
//                           }
//                         });
//                       },
//                       items: controller.spOfficers
//                           .map((sp) => sp.spName)
//                           .toList(),
//                       searchController: spSearchController,
//                       hintText: "तुम्हाला कोणाला भेटायचे आहे ?",
//                     ),

//                     const SizedBox(height: 15),

//                     buildFormField(
//                       controller: reasonController,
//                       label: "तक्रारीचे स्वरूप / भेटीचे कारण",
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 15),

//                     // Searchable Police Station Dropdown
//                     buildSearchableDropdown(
//                       label: "संबंधित पोलिस स्टेशन?",
//                       value: selectedPoliceStation,
//                       onChanged: (val) {
//                         setState(() {
//                           selectedPoliceStation = val;
//                           if (val != null) {
//                             final selectedPS = controller.policeStations
//                                 .firstWhere(
//                                     (ps) => ps.policeStationName == val);
//                             controller.selectedPoliceStationId =
//                                 selectedPS.policeStationId.toString();
//                           }
//                         });
//                       },
//                       items: controller.policeStations
//                           .map((ps) => ps.policeStationName)
//                           .toList(),
//                       searchController: policeStationSearchController,
//                       hintText: "संबंधित पोलिस स्टेशन?",
//                     ),

//                     const SizedBox(height: 15),

//                     buildDropdown(
//                         label: "संबंधित प्रभारीची भेट घेतली?",
//                         value: metPrabhari,
//                         onChanged: (val) => setState(() => metPrabhari = val)),
//                     const SizedBox(height: 15),

//                     buildDropdown(
//                         label: "संबंधित SDPOची भेट घेतली?",
//                         value: metSDPO,
//                         onChanged: (val) => setState(() => metSDPO = val)),
//                     const SizedBox(height: 15),

//                     buildDropdown(
//                         label: "संबंधित Additional SPची भेट घेतली?",
//                         value: metAdditionalSP,
//                         onChanged: (val) =>
//                             setState(() => metAdditionalSP = val)),
//                     const SizedBox(height: 15),

//                     buildDropdown(
//                       label: "आधी याच कारणासाठी भेट दिली आहे का?",
//                       value: visitSameReason,
//                       onChanged: (val) =>
//                           setState(() => visitSameReason = val),
//                     ),
//                     const SizedBox(height: 15),

//                     TextFormField(
//                       readOnly: true,
//                       validator: (_) => appointmentDate == null
//                           ? "कृपया तारीख निवडा"
//                           : null,
//                       decoration: InputDecoration(
//                         labelText: "नियुक्तीची तारीख",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.calendar_today),
//                           onPressed: () async {
//                             DateTime? picked = await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(2020),
//                               lastDate: DateTime(2030),
//                             );
//                             if (picked != null) {
//                               setState(() {
//                                 appointmentDate = picked;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                       controller: TextEditingController(
//                         text: appointmentDate != null
//                             ? "${appointmentDate!.day}-${appointmentDate!.month}-${appointmentDate!.year}"
//                             : "",
//                       ),
//                     ),
//                     const SizedBox(height: 15),

//                     buildDropdowns(
//                       label: "नियुक्तीची वेळ",
//                       value: selectedAppointmentTime,
//                       onChanged: (val) {
//                         setState(() {
//                           selectedAppointmentTime = val;
//                           if (val != null) {
//                             final selectedSlot = controller.timeSlots
//                                 .firstWhere((slot) => slot.label == val);
//                             controller.selectedTimeSlotValue =
//                                 selectedSlot.value;
//                             controller.selectedTimeSlotLabel =
//                                 selectedSlot.label;
//                           }
//                         });
//                       },
//                       items: controller.timeSlots
//                           .map((slot) => slot.label)
//                           .toList(),
//                     ),

//                     const SizedBox(height: 30),

//                     // ✅ Submit Button with Popup Style
//                     Center(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//                           minimumSize: const Size(300, 55),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           textStyle: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             final formData = {
//                               "name": nameController.text,
//                               "sms_number": smsMobileController.text,
//                               "is_same_number": isSameNumber,
//                               "whatsapp_number": mobileController.text,
//                               "current_address": addressController.text,
//                               "reason": reasonController.text,
//                               "sp_id": controller.selectedSpId,
//                               "police_station_id":
//                                   controller.selectedPoliceStationId,
//                               "prabhari_meeting": _mapYesNo(metPrabhari),
//                               "sdpo_meeting": _mapYesNo(metSDPO),
//                               "additional_sp_meeting":
//                                   _mapYesNo(metAdditionalSP),
//                               "visit_same_reason":
//                                   _mapYesNo(visitSameReason),
//                               "appointment_date": appointmentDate != null
//                                   ? "${appointmentDate!.year}-${appointmentDate!.month}-${appointmentDate!.day}"
//                                   : null,
//                               "time_slot": controller.selectedTimeSlotValue,
//                               "e_office": officeNumberController.text,
//                             };

//                             controller.setSubmitting(true);
//                             final result = await controller.createVisitor(formData);
//                             controller.setSubmitting(false);

//                             if (result["status"] == "success") {
//                               customSnackBar("यशस्वी", "नवीन भेट नोंदवण्यात आली आहे");
//                               Navigator.pop(context, true);
//                             } else {
//                               customSnackBar("त्रुटी", result["message"], isError: true);
//                             }
//                           } else {
//                             customSnackBar("त्रुटी", "कृपया सर्व फील्ड योग्य भरा", isError: true);
//                           }
//                         },
//                         child: Obx(() => controller.isSubmitting.value
//                             ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Text("समाविष्ट करा")),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   /// ✅ Custom Popup (same style as your screenshot)
//   void customSnackBar(String title, String message, {bool isError = false}) {
//     Get.snackbar(
//       "",
//       "",
//       snackPosition: SnackPosition.BOTTOM,
//       margin: const EdgeInsets.all(10),
//       backgroundColor: const Color(0xFF607D8B), 
//       borderRadius: 12,
//       borderWidth: 2,
//       borderColor: Colors.black26,
//       icon: Icon(
//         isError ? Icons.close_rounded : Icons.done_all,
//         color: Colors.white,
//       ),
//       titleText: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//       messageText: Text(
//         message,
//         style: const TextStyle(
//           fontSize: 14,
//           color: Colors.white,
//         ),
//       ),
//       duration: const Duration(seconds: 3),
//     );
//   }

//   // ========================= WIDGET HELPERS =========================
//   Widget buildFormField({
//     required TextEditingController controller,
//     required String label,
//     int maxLines = 1,
//     TextInputType type = TextInputType.text,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: type,
//       maxLines: maxLines,
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return "कृपया $label भरा";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 6, 51, 131), width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//     );
//   }

//   Widget buildMobileField({
//     required TextEditingController controller,
//     required String label,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.phone,
//       maxLength: 10,
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return "कृपया $label भरा";
//         }
//         if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//           return "कृपया वैध 10 अंकी मोबाईल नंबर भरा";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: label,
//         counterText: "",
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 6, 51, 131), width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//     );
//   }

//   Widget buildDropdowns({
//     required String label,
//     required String? value,
//     required void Function(String?) onChanged,
//     required List<String> items,
//   }) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 6, 51, 131), width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//       value: value,
//       validator: (val) => val == null ? "कृपया निवडा" : null,
//       items: items
//           .map((item) => DropdownMenuItem(
//                 value: item,
//                 child: Text(item),
//               ))
//           .toList(),
//       onChanged: onChanged,
//     );
//   }

//   Widget buildDropdown({
//     required String label,
//     required String? value,
//     required void Function(String?) onChanged,
//   }) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 6, 51, 131), width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//       value: value,
//       validator: (val) => val == null ? "कृपया निवडा" : null,
//       items: const [
//         DropdownMenuItem(value: "होय", child: Text("होय")),
//         DropdownMenuItem(value: "नाही", child: Text("नाही")),
//       ],
//       onChanged: onChanged,
//     );
//   }

//   Widget buildSearchableDropdown({
//     required String label,
//     required String? value,
//     required void Function(String?) onChanged,
//     required List<String> items,
//     required TextEditingController searchController,
//     required String hintText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: ExpansionTile(
//             title: Text(
//               value ?? hintText,
//               style: TextStyle(
//                 color: value != null ? Colors.black : Colors.grey.shade600,
//               ),
//             ),
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: searchController,
//                   decoration: const InputDecoration(
//                     hintText: "शोधा...",
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (query) => setState(() {}),
//                 ),
//               ),
//               SizedBox(
//                 height: 150,
//                 child: ListView(
//                   children: items
//                       .where((item) => item
//                           .toLowerCase()
//                           .contains(searchController.text.toLowerCase()))
//                       .map((filtered) => ListTile(
//                             title: Text(filtered),
//                             onTap: () {
//                               onChanged(filtered);
//                               //Navigator.pop(context);
//                             },
//                           ))
//                       .toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }































// // //working with dropdown feilds------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
// import 'package:sp_manage_system/Screen/View/Forms/complaint_form_controller.dart';

// class ComplaintFormScreen extends StatefulWidget {
//   const ComplaintFormScreen({super.key});

//   @override
//   State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
// }

// class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
//   final ComplaintFormController controller = Get.put(ComplaintFormController());

//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController reasonController = TextEditingController();
//   final TextEditingController smsMobileController = TextEditingController();
//   final TextEditingController officeNumberController = TextEditingController();

//   bool isSameNumber = false;
//   String? selectedSP;
//   String? selectedPoliceStation;
//   DateTime? appointmentDate;
//   String? selectedAppointmentTime;

//   String? metPrabhari;
//   String? metSDPO;
//   String? metAdditionalSP;
//   String? visitSameReason; // ✅ New field

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchSPList();
//     controller.fetchPoliceStations();
//     controller.fetchTimeSlots();
//   }

//   /// ✅ Convert Marathi → API expected value
//   String? _mapYesNo(String? value) {
//     if (value == "होय") return "yes";
//     if (value == "नाही") return "no";
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("अर्ज"),
//           centerTitle: true,
//           backgroundColor: backGroundColor,
//         ),
//         body: GetBuilder<ComplaintFormController>(builder: (_) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       buildFormField(
//                           controller: nameController, label: "अर्जदाराचे नाव"),
//                       const SizedBox(height: 15),
//                       buildFormField(
//                           controller: addressController,
//                           label: "सध्याचा पत्ता",
//                           maxLines: 2),
//                       const SizedBox(height: 15),

//                       if (!isSameNumber)
//                         buildMobileField(
//                           controller: smsMobileController,
//                           label: "मोबाईल नंबर (SMS)",
//                         ),
//                       if (!isSameNumber) const SizedBox(height: 15),

//                       buildMobileField(
//                         controller: mobileController,
//                         label: "मोबाईल नंबर (WhatsApp)",
//                       ),

//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: isSameNumber,
//                             onChanged: (val) {
//                               setState(() {
//                                 isSameNumber = val ?? false;
//                                 if (isSameNumber) {
//                                   mobileController.text =
//                                       smsMobileController.text;
//                                 } else {
//                                   mobileController.clear();
//                                 }
//                               });
//                             },
//                           ),
//                           const Text("SMS आणि WhatsApp नंबर सारखे आहे का?"),
//                         ],
//                       ),
//                       const SizedBox(height: 15),

//                       buildDropdowns(
//                         label: "तुम्हाला कोणाला भेटायचे आहे?",
//                         value: selectedSP,
//                         onChanged: (val) {
//                           setState(() {
//                             selectedSP = val;
//                             final selectedOfficer = controller.spOfficers
//                                 .firstWhere((sp) => sp.spName == val);
//                             controller.selectedSpId =
//                                 selectedOfficer.spId.toString();
//                           });
//                         },
//                         items: controller.spOfficers
//                             .map((sp) => sp.spName)
//                             .toList(),
//                       ),

//                       const SizedBox(height: 15),

//                       buildFormField(
//                         controller: reasonController,
//                         label: "तक्रारीचे स्वरूप / भेटीचे कारण",
//                         maxLines: 3,
//                       ),
//                       const SizedBox(height: 15),

//                       buildDropdowns(
//                         label: "संबंधित पोलिस स्टेशन",
//                         value: selectedPoliceStation,
//                         onChanged: (val) {
//                           setState(() {
//                             selectedPoliceStation = val;
//                             final selectedPS = controller.policeStations
//                                 .firstWhere(
//                                     (ps) => ps.policeStationName == val);
//                             controller.selectedPoliceStationId =
//                                 selectedPS.policeStationId.toString();
//                           });
//                         },
//                         items: controller.policeStations
//                             .map((ps) => ps.policeStationName)
//                             .toList(),
//                       ),

//                       const SizedBox(height: 15),

//                       buildDropdown(
//                           label: "संबंधित प्रभारीची भेट घेतली?",
//                           value: metPrabhari,
//                           onChanged: (val) => setState(() => metPrabhari = val)),
//                       const SizedBox(height: 15),

//                       buildDropdown(
//                           label: "संबंधित SDPOची भेट घेतली?",
//                           value: metSDPO,
//                           onChanged: (val) => setState(() => metSDPO = val)),
//                       const SizedBox(height: 15),

//                       buildDropdown(
//                           label: "संबंधित Additional SPची भेट घेतली?",
//                           value: metAdditionalSP,
//                           onChanged: (val) =>
//                               setState(() => metAdditionalSP = val)),
//                       const SizedBox(height: 15),

//                       /// ✅ New field for "visit_same_reason"
//                       buildDropdown(
//                         label: "आधी याच कारणासाठी भेट दिली आहे का?",
//                         value: visitSameReason,
//                         onChanged: (val) =>
//                             setState(() => visitSameReason = val),
//                       ),
//                       const SizedBox(height: 15),

//                       TextFormField(
//                         readOnly: true,
//                         validator: (_) => appointmentDate == null
//                             ? "कृपया तारीख निवडा"
//                             : null,
//                         decoration: InputDecoration(
//                           labelText: "नियुक्तीची तारीख",
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                           suffixIcon: IconButton(
//                             icon: const Icon(Icons.calendar_today),
//                             onPressed: () async {
//                               DateTime? picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime(2020),
//                                 lastDate: DateTime(2030),
//                               );
//                               if (picked != null) {
//                                 setState(() {
//                                   appointmentDate = picked;
//                                 });
//                               }
//                             },
//                           ),
//                         ),
//                         controller: TextEditingController(
//                           text: appointmentDate != null
//                               ? "${appointmentDate!.day}-${appointmentDate!.month}-${appointmentDate!.year}"
//                               : "",
//                         ),
//                       ),
//                       const SizedBox(height: 15),

//                       buildDropdowns(
//                         label: "नियुक्तीची वेळ",
//                         value: selectedAppointmentTime,
//                         onChanged: (val) {
//                           setState(() {
//                             selectedAppointmentTime = val;
//                             final selectedSlot = controller.timeSlots
//                                 .firstWhere((slot) => slot.label == val);
//                             controller.selectedTimeSlotValue =
//                                 selectedSlot.value;
//                             controller.selectedTimeSlotLabel =
//                                 selectedSlot.label;
//                           });
//                         },
//                         items: controller.timeSlots
//                             .map((slot) => slot.label)
//                             .toList(),
//                       ),

//                       const SizedBox(height: 30),

//                       Center(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromRGBO(6, 51, 131, 1),
//                             minimumSize: const Size(300, 55),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             textStyle: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               final formData = {
//                                 "name": nameController.text,
//                                 "sms_number": smsMobileController.text,
//                                 "is_same_number": isSameNumber,
//                                 "whatsapp_number": mobileController.text,
//                                 "current_address": addressController.text,
//                                 "reason": reasonController.text,
//                                 "sp_id": controller.selectedSpId,
//                                 "police_station_id":
//                                     controller.selectedPoliceStationId,
//                                 "prabhari_meeting": _mapYesNo(metPrabhari),
//                                 "sdpo_meeting": _mapYesNo(metSDPO),
//                                 "additional_sp_meeting":
//                                     _mapYesNo(metAdditionalSP),
//                                 "visit_same_reason":
//                                     _mapYesNo(visitSameReason), // ✅ Added
//                                 "appointment_date": appointmentDate != null
//                                     ? "${appointmentDate!.year}-${appointmentDate!.month}-${appointmentDate!.day}"
//                                     : null,
//                                 "time_slot": controller.selectedTimeSlotValue,
//                                 "e_office": officeNumberController.text,
//                               };

//                               final result =
//                                   await controller.createVisitor(formData);

//                               if (result["status"] == "success") {
//                                 successSnackBar("यशस्वी", "नवीन भेट नोंदवण्यात आली आहे");
//                                 Navigator.pop(context, true);
//                               } else {
//                                 errorSnackBar("त्रुटी", result["message"]);
//                               }
//                             } else {
//                               errorSnackBar(
//                                   "त्रुटी", "कृपया सर्व फील्ड योग्य भरा");
//                             }
//                           },
//                           child: const Text("समाविष्ट करा"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }));
//   }

//   Widget buildFormField({
//     required TextEditingController controller,
//     required String label,
//     int maxLines = 1,
//     TextInputType type = TextInputType.text,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: type,
//       maxLines: maxLines,
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return "कृपया $label भरा";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 6, 51, 131), width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//     );
//   }

//   Widget buildMobileField({
//     required TextEditingController controller,
//     required String label,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.phone,
//       maxLength: 10,
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return "कृपया $label भरा";
//         }
//         if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//           return "कृपया वैध 10 अंकी मोबाईल नंबर भरा";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: label,
//         counterText: "",
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 6, 51, 131), width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//     );
//   }

//   Widget buildDropdowns({
//     required String label,
//     required String? value,
//     required void Function(String?) onChanged,
//     required List<String> items,
//   }) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 6, 51, 131), width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//       value: value,
//       validator: (val) => val == null ? "कृपया निवडा" : null,
//       items: items
//           .map((item) => DropdownMenuItem(
//                 value: item,
//                 child: Text(item),
//               ))
//           .toList(),
//       onChanged: onChanged,
//     );
//   }

//   Widget buildDropdown({
//     required String label,
//     required String? value,
//     required void Function(String?) onChanged,
//   }) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Color.fromARGB(255, 6, 51, 131), width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//       value: value,
//       validator: (val) => val == null ? "कृपया निवडा" : null,
//       items: const [
//         DropdownMenuItem(value: "होय", child: Text("होय")),
//         DropdownMenuItem(value: "नाही", child: Text("नाही")),
//       ],
//       onChanged: onChanged,
//     );
//   }
// }












