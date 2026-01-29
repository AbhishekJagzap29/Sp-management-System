import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notif_form_controller.dart';

class NotifFormScreen extends StatelessWidget {
  final int visitorId;
  const NotifFormScreen({super.key, required this.visitorId});

  @override
  Widget build(BuildContext context) {
    final NotifFormController controller = Get.put(NotifFormController());

    // Fetch visitor form when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchVisitorForm(visitorId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("अर्ज तपशील"),
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
              _buildReadOnlyField("क्रमांक", data["sequence_number"]),
              _buildReadOnlyField("अर्जदाराचे नाव", data["name"]),
              _buildReadOnlyField("सध्याचा पत्ता", data["current_address"]),
              _buildReadOnlyField("मोबाईल नंबर (SMS)", data["sms_number"]),
              _buildReadOnlyField("मोबाईल नंबर (WhatsApp)", data["whatsapp_number"]),
              _buildReadOnlyField("भेटीचे कारण", data["reason"]),
              _buildReadOnlyField("कोणाला भेटायचे आहे?", data["officer_to_meet_name"]),
              _buildReadOnlyField("पोलिस स्टेशन", data["police_station_id_name"]),
              _buildReadOnlyField("नियुक्तीची तारीख", data["appointment_date"]),
              _buildReadOnlyField("वेळ", data["time_slot"]),
              _buildReadOnlyField("ई-ऑफिस", data["e_office"]),
              _buildReadOnlyField("समान कारण?", data["visit_same_reason"]),
              _buildReadOnlyField("अधिकारी नाव", data["officer_name"]),
              _buildReadOnlyField("SP अभिप्राय", data["feedback"]),
              _buildReadOnlyField("भेट तारीख निश्चित?", data["date_fixed"]),
              _buildReadOnlyField("PI अभिप्राय", data["pi_feedback"]),
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
