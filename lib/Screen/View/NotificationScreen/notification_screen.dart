import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/API/Apis/api_response.dart';
import 'package:sp_manage_system/API/Response%20Model/notification_response_model.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_form.dart';
import 'package:sp_manage_system/Screen/View/Forms/pi_form.dart';
import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  final String callerDashboard; 
  const NotificationScreen({Key? key, required this.callerDashboard}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Color themeColor = const Color(0xFF216094);
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    controller.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("अधिसूचना"),
        backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
        centerTitle: true,
      ),
      body: GetBuilder<NotificationController>(
        builder: (controller) {
          if (controller.notificationResponse.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.notificationResponse.status == Status.ERROR) {
            return Center(
              child: Text(
                controller.notificationResponse.message ??
                    'अधिसूचना लोड करताना त्रुटी आली',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (controller.notificationData == null ||
              controller.notificationData!.notifications.isEmpty) {
            return const Center(child: Text("कोणत्याही नवीन अधिसूचना उपलब्ध नाहीत"));
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: controller.notificationData!.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notif = controller.notificationData!.notifications[index];
                return GestureDetector(
                  onTap: () {
                    if (notif.visitorId != null) {
                      _openForm(notif.visitorId!);
                    }
                  },
                  child: _buildNotificationCard(notif),
                );
              },
            );
          }
        },
      ),
    );
  }

  /// Open form automatically based on dashboard
  void _openForm(int visitorId) {
    if (widget.callerDashboard == "sp") {
      Get.to(() => SpVisitorFormScreen(visitorId: visitorId));
    } else if (widget.callerDashboard == "pi") {
      Get.to(() => PiFormScreen(visitorId: visitorId));
    } else {
      // fallback
      Get.to(() => SpVisitorFormScreen(visitorId: visitorId));
    }
  }

  Widget _buildNotificationCard(NotificationModel notif) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: themeColor, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notif.title,
            style: TextStyle(
              fontSize: 16,
              color: themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 16, thickness: 1),
          Text(
            notif.message,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Date: ${notif.date}",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          )
        ],
      ),
    );
  }
}














// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/API/Apis/api_response.dart';
// import 'package:sp_manage_system/API/Response%20Model/notification_response_model.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notif_form.dart';
// import 'package:sp_manage_system/Screen/View/NotificationScreen/notification_controller.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({Key? key}) : super(key: key);

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final Color themeColor = const Color(0xFF216094);
//   final NotificationController controller = Get.put(NotificationController());

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अधिसूचना"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//         centerTitle: true,
//       ),
//       body: GetBuilder<NotificationController>(
//         builder: (controller) {
//           if (controller.notificationResponse.status == Status.LOADING) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (controller.notificationResponse.status == Status.ERROR) {
//             return Center(
//               child: Text(
//                 controller.notificationResponse.message ??
//                     'अधिसूचना लोड करताना त्रुटी आली',
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           } else if (controller.notificationData == null ||
//               controller.notificationData!.notifications.isEmpty) {
//             return const Center(child: Text("कोणत्याही नवीन अधिसूचना उपलब्ध नाहीत"));
//           } else {
//             return ListView.separated(
//               padding: const EdgeInsets.all(12),
//               itemCount: controller.notificationData!.notifications.length,
//               separatorBuilder: (context, index) => const SizedBox(height: 10),
//               itemBuilder: (context, index) {
//                 final notif = controller.notificationData!.notifications[index];
//                 //return _buildNotificationCard(notif);
//                 return GestureDetector(
//                   onTap: () {
//                     if (notif.visitorId != null) {
//                         Get.to(() => NotifFormScreen(visitorId: notif.visitorId!));
//                     }
//                   },
//                   child: _buildNotificationCard(notif),
//                );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildNotificationCard(NotificationModel notif) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: themeColor, width: 1),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           )
//         ],
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             notif.title,
//             style: TextStyle(
//               fontSize: 16,
//               color: themeColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Divider(height: 16, thickness: 1),
//           Text(
//             notif.message,
//             style: const TextStyle(fontSize: 14, color: Colors.black87),
//           ),
//           const SizedBox(height: 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Date: ${notif.date}",
//                 style: const TextStyle(fontSize: 12, color: Colors.black54),
//               ),
//               // TextButton.icon(
//               //   // onPressed: () {
//               //   //   Navigator.push(
//               //   //     context,
//               //   //     MaterialPageRoute(
//               //   //       builder: (context) =>
//               //   //           DetailComplaintScreen(complaintId: notif.complaintId!),
//               //   //     ),
//               //   //   );
//               //   // },
//               //   style: TextButton.styleFrom(
//               //     foregroundColor: themeColor,
//               //   ),
//               //   icon: const Icon(Icons.arrow_forward, size: 16),
//               //   label: const Text("View Complaint"),
//               // ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
