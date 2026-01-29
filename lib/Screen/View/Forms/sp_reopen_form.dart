import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sp_reopen_controller.dart';

class SpReopenFormScreen extends StatelessWidget {
  final int visitorId;
  const SpReopenFormScreen({super.key, required this.visitorId});

  @override
  Widget build(BuildContext context) {
    final SpReopenController controller = Get.put(SpReopenController());

    // Fetch visitor form after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchVisitorForm(visitorId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("अर्ज पुन्हा उघडा"),
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
              _buildReadOnlyField("नियुक्त अधिकारी नाव", data["officer_name"]),
              _buildReadOnlyField("SP अभिप्राय", data["feedback"]),
              _buildReadOnlyField("तक्रारदाराशी भेटीची तारीख निश्चित केली आहे का?", data["date_fixed"]),
              _buildReadOnlyField("PI अभिप्राय", data["pi_feedback"]),
              _buildReadOnlyField("स्थिती", data["status"]),

              const SizedBox(height: 20),

              // अर्ज पुन्हा उघडा बटण
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.reopenForm(visitorId);
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
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("अर्ज पुन्हा उघडा")),
                      
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
