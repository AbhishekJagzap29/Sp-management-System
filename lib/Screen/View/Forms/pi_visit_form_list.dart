import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/View/Forms/pi_form.dart';
import '../../Constant/app_color.dart';
import 'pi_visit_form_controller.dart';

class PiVisitFormListScreen extends StatelessWidget {
  const PiVisitFormListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PiVisitController controller = Get.put(PiVisitController());
    controller.fetchVisitors();

    return Scaffold(
      appBar: AppBar(
        title: const Text("अभ्यागतांची यादी"),
        centerTitle: true,
        backgroundColor: backGroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                controller.selectedDate.value = pickedDate;
                controller.applyFilters();
              }
            },
          ),
          if (controller.selectedDate.value != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.selectedDate.value = null;
                controller.applyFilters();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "नाव किंवा पोलिस ठाणे शोधा...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                controller.applyFilters();
              },
            ),
          ),

          // 📋 Visitor List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredVisitors.isEmpty) {
                return const Center(
                    child: Text("कोणतेही Assigned अभ्यागत नाहीत"));
              }

              return ListView.builder(
                itemCount: controller.filteredVisitors.length,
                itemBuilder: (context, index) {
                  final visitor = controller.filteredVisitors[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: backGroundColor,
                        child: Text(
                          visitor.name.isNotEmpty ? visitor.name[0] : "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(visitor.name),
                      subtitle: Text(
                        "पोलिस ठाणे: ${visitor.policeStation ?? ''}\n"
                        "अधिकारी: ${visitor.officerToMeet ?? ''}\n"
                        "दिनांक: ${visitor.date ?? ''}",
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: visitor.status == "Assigned"
                              ? Colors.green
                              : const Color.fromARGB(255, 97, 103, 190),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          visitor.status.isNotEmpty
                              ? visitor.status[0].toUpperCase() +
                                  visitor.status.substring(1).toLowerCase()
                              : '',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                      onTap: () {
                        Get.to(() => PiFormScreen(visitorId: visitor.id));
                      },
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
















// // lib/Screen/View/Forms/pi_visit_form_list.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_form.dart';
// import '../../Constant/app_color.dart';
// import 'pi_visit_form_controller.dart';

// class PiVisitFormListScreen extends StatelessWidget {
//   const PiVisitFormListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final PiVisitController controller = Get.put(PiVisitController());
//     controller.fetchVisitors(); // fetch on load

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागतांची यादी"),
//         centerTitle: true,
//         backgroundColor: backGroundColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_month),
//             onPressed: () async {
//               final pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: controller.selectedDate.value ?? DateTime.now(),
//                 firstDate: DateTime(2020),
//                 lastDate: DateTime(2100),
//               );
//               if (pickedDate != null) {
//                 controller.selectedDate.value = pickedDate;
//                 controller.applyFilters();
//               }
//             },
//           ),
//           if (controller.selectedDate.value != null)
//             IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 controller.selectedDate.value = null;
//                 controller.applyFilters();
//               },
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // 🔍 Search Bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: controller.searchController,
//               decoration: InputDecoration(
//                 hintText: "नाव किंवा पोलिस ठाणे शोधा...",
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: controller.searchController.text.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () {
//                           controller.searchController.clear();
//                           controller.applyFilters();
//                         },
//                       )
//                     : null,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onChanged: (value) {
//                 controller.applyFilters();
//               },
//             ),
//           ),

//           // 📋 Visitor List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (controller.filteredVisitors.isEmpty) {
//                 return const Center(
//                     child: Text("कोणतेही Assigned अभ्यागत नाहीत"));
//               }

//               return ListView.builder(
//                 itemCount: controller.filteredVisitors.length,
//                 itemBuilder: (context, index) {
//                   final visitor = controller.filteredVisitors[index];
//                   return Card(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: backGroundColor,
//                         child: Text(
//                           visitor.name.isNotEmpty
//                               ? visitor.name[0]
//                               : "?",
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       title: Text(visitor.name),
//                       subtitle: Text(
//                         "पोलिस ठाणे: ${visitor.policeStation ?? ''}\n"
//                         "अधिकारी: ${visitor.officerToMeet ?? ''}\n"
//                         "दिनांक: ${visitor.date ?? ''}",
//                       ),
//                       trailing: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: visitor.status == "Assigned"
//                               ? Colors.green
//                               : const Color.fromARGB(255, 97, 103, 190),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           visitor.status.isNotEmpty
//                               ? visitor.status[0].toUpperCase() +
//                                   visitor.status.substring(1).toLowerCase()
//                               : '',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 14),
//                         ),
//                       ),
//                       onTap: () {
//                         Get.to(() => PiFormScreen(visitorId: visitor.id));
//                       },
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }























// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_form.dart';
// import '../../Constant/app_color.dart';
// import 'pi_visit_form_controller.dart';

// class PiVisitFormListScreen extends StatelessWidget {
//   const PiVisitFormListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final PiVisitController controller = Get.put(PiVisitController());
//     controller.fetchVisitors(); // fetch on load

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागतांची यादी"),
//         centerTitle: true,
//         backgroundColor: backGroundColor,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.visitors.isEmpty) {
//           return const Center(child: Text("कोणतेही Assigned अभ्यागत नाहीत"));
//         }

//         return ListView.builder(
//           itemCount: controller.visitors.length,
//           itemBuilder: (context, index) {
//             final visitor = controller.visitors[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: backGroundColor,
//                   child: Text(
//                     visitor.name.isNotEmpty ? visitor.name[0] : "?",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 title: Text(visitor.name),
//                 subtitle: Text(
//                   "पोलिस ठाणे: ${visitor.policeStation ?? ''}\n"
//                   "अधिकारी: ${visitor.officerToMeet ?? ''}",
//                 ),
//                 trailing: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: visitor.status == "Assigned"
//                         ? Colors.green
//                         : const Color.fromARGB(255, 97, 103, 190),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   // child: Text(
//                   //   visitor.status,
//                   //   style: const TextStyle(color: Colors.white, fontSize: 14),
//                   // ),
//                   child: Text(
//                       visitor.status.isNotEmpty
//                         ? visitor.status[0].toUpperCase() + visitor.status.substring(1).toLowerCase()
//                         : '',
//                       style: const TextStyle(color: Colors.white, fontSize: 14),
//                   ),

//                 ),
//                 onTap: () {
//                     Get.to(() => PiFormScreen(visitorId: visitor.id));
//                 },
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

