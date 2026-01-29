// lib/Screen/View/Forms/sp_closed_list.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_closed_controller.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_reopen_form.dart';
import '../../Constant/app_color.dart';

class SpClosedListScreen extends StatelessWidget {
  const SpClosedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SpClosedController controller = Get.put(SpClosedController());
    controller.fetchClosedForms();

    return Scaffold(
      appBar: AppBar(
        title: const Text("पूर्ण झालेले अर्ज"),
        backgroundColor: backGroundColor,
        centerTitle: true,
        actions: [
          // 📅 Date filter
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
          Obx(() => controller.selectedDate.value != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.selectedDate.value = null;
                    controller.applyFilters();
                  },
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search bar
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

          // 📋 Closed Forms List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredForms.isEmpty) {
                return const Center(
                  child: Text("सध्या कोणतेही बंद अर्ज उपलब्ध नाहीत"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.filteredForms.length,
                itemBuilder: (context, index) {
                  final form = controller.filteredForms[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle,
                          color: Color.fromARGB(255, 29, 156, 50)),
                      title: Text(form['name'] ?? "नाव उपलब्ध नाही"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Text("भेट क्रमांक: ${form["sequence_number"] ?? "-"}"),
                          Text("अधिकारी: ${form['officer_to_meet_name'] ?? '-'}"),
                          Text("पोलीस स्टेशन: ${form['police_station_name'] ?? '-'}"),
                          Text("दिनांक: ${form['date'] ?? ''}"),
                          Text(
                              "स्थिती: ${(form['status'] ?? 'पूर्ण').toString().capitalizeFirst}"),
                        ],
                      ),
                      onTap: () {
                        final visitorId = form['id'] ?? form['visitor_id'];
                        if (visitorId != null) {
                          Get.to(() => SpReopenFormScreen(visitorId: visitorId));
                        } else {
                          Get.snackbar("त्रुटी", "Visitor ID उपलब्ध नाही");
                        }
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




















// // lib/Screen/View/Forms/sp_closed_list.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_closed_controller.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_reopen_form.dart';
// import '../../Constant/app_color.dart';

// class SpClosedListScreen extends StatelessWidget {
//   const SpClosedListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final SpClosedController controller = Get.put(SpClosedController());
//     controller.fetchClosedForms();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("पूर्ण झालेले अर्ज"),
//         backgroundColor: backGroundColor,
//         centerTitle: true,
//         actions: [
//           // 📅 Date filter
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
//           Obx(() => controller.selectedDate.value != null
//               ? IconButton(
//                   icon: const Icon(Icons.clear),
//                   onPressed: () {
//                     controller.selectedDate.value = null;
//                     controller.applyFilters();
//                   },
//                 )
//               : const SizedBox.shrink()),
//         ],
//       ),
//       body: Column(
//         children: [
//           // 🔍 Search bar
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

//           // 📋 Closed Forms List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (controller.filteredForms.isEmpty) {
//                 return const Center(
//                   child: Text("सध्या कोणतेही बंद अर्ज उपलब्ध नाहीत"),
//                 );
//               }

//               return ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: controller.filteredForms.length,
//                 itemBuilder: (context, index) {
//                   final form = controller.filteredForms[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     child: ListTile(
//                       leading: const Icon(Icons.check_circle,
//                           color: Color.fromARGB(255, 29, 156, 50)),
//                       title: Text(form['name'] ?? "नाव उपलब्ध नाही"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("अधिकारी: ${form['officer_to_meet_name'] ?? '-'}"),
//                           Text("पोलीस स्टेशन: ${form['police_station_name'] ?? '-'}"),
//                           Text("दिनांक: ${form['date'] ?? ''}"),
//                           Text(
//                               "स्थिती: ${(form['status'] ?? 'पूर्ण').toString().capitalizeFirst}"),
//                         ],
//                       ),
//                       onTap: () {
//                         final visitorId = form['id'] ?? form['visitor_id'];
//                         if (visitorId != null) {
//                           Get.to(() => SpReopenFormScreen(visitorId: visitorId));
//                         } else {
//                           Get.snackbar("त्रुटी", "Visitor ID उपलब्ध नाही");
//                         }
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
















// // lib/Screen/View/Forms/sp_closed_list.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_closed_controller.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_reopen_form.dart';
// import '../../Constant/app_color.dart';

// class SpClosedListScreen extends StatelessWidget {
//   const SpClosedListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final SpClosedController controller = Get.put(SpClosedController());
//     controller.fetchClosedForms();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("पूर्ण झालेले अर्ज"),
//         backgroundColor: backGroundColor,
//         centerTitle: true,
//         actions: [
//           // 📅 Date filter
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
//           // 🔍 Search bar
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

//           // 📋 Closed Forms List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (controller.filteredForms.isEmpty) {
//                 return const Center(
//                   child: Text("सध्या कोणतेही बंद अर्ज उपलब्ध नाहीत"),
//                 );
//               }

//               return ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: controller.filteredForms.length,
//                 itemBuilder: (context, index) {
//                   final form = controller.filteredForms[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     child: ListTile(
//                       leading: const Icon(Icons.check_circle,
//                           color: Color.fromARGB(255, 29, 156, 50)),
//                       title: Text(form['name'] ?? "नाव उपलब्ध नाही"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("अधिकारी: ${form['officer_to_meet_name'] ?? '-'}"),
//                           Text("पोलीस स्टेशन: ${form['police_station_name'] ?? '-'}"),
//                           Text("दिनांक: ${form['date'] ?? ''}"),
//                           Text(
//                               "स्थिती: ${(form['status'] ?? 'पूर्ण').toString().capitalizeFirst}"),
//                         ],
//                       ),
//                       onTap: () {
//                         final visitorId = form['id'] ?? form['visitor_id'];
//                         if (visitorId != null) {
//                           Get.to(() => SpReopenFormScreen(visitorId: visitorId));
//                         } else {
//                           Get.snackbar("त्रुटी", "Visitor ID उपलब्ध नाही");
//                         }
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
// import 'package:sp_manage_system/Screen/View/Forms/sp_closed_controller.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_reopen_form.dart';

// class SpClosedListScreen extends StatelessWidget {
//   const SpClosedListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final SpClosedController controller = Get.put(SpClosedController());
    
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchClosedForms();
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("पूर्ण झालेले अर्ज"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.closedForms.isEmpty) {
//           return const Center(
//             child: Text("सध्या कोणतेही बंद अर्ज उपलब्ध नाहीत"),
//           );
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: controller.closedForms.length,
//           itemBuilder: (context, index) {
//             final form = controller.closedForms[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: ListTile(
//                 leading: const Icon(Icons.check_circle, color: Color.fromARGB(255, 29, 156, 50)),
//                 title: Text(form['name'] ?? "नाव उपलब्ध नाही"),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("अधिकारी: ${form['officer_to_meet_name'] ?? '-'}"),
//                     Text("पोलीस स्टेशन: ${form['police_station_name'] ?? '-'}"),
//                     Text("स्थिती: ${(form['status'] ?? 'पूर्ण').toString().capitalizeFirst}"),
//                   ],
//                 ),
//                 onTap: () {
//                   final visitorId = form['id'] ?? form['visitor_id'];
//                   if (visitorId != null) {
//                       Get.to(() => SpReopenFormScreen(visitorId: visitorId));
//                   } else {
//                       Get.snackbar("त्रुटी", "Visitor ID उपलब्ध नाही");
//                   }
//                 },
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

