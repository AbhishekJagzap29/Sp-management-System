import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_form.dart';
import 'package:sp_manage_system/Screen/View/Forms/sp_visit_form_controller.dart';

class VisitFormListScreen extends StatelessWidget {
  const VisitFormListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VisitFormController controller = Get.put(VisitFormController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("अभ्यागतांची यादी"),
        backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
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
          // 🔍 Search Bar + Status Filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
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
                const SizedBox(width: 8),
                Obx(() {
                  return DropdownButton<String>(
                    value: controller.selectedStatus.value,
                    hint: const Text("स्थिती"),
                    items: controller.statusOptions
                        .map((status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.selectedStatus.value = value;
                      controller.applyFilters();
                    },
                  );
                }),
              ],
            ),
          ),

          // 📋 Visitors List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredVisitors.isEmpty) {
                return const Center(child: Text("अभ्यागतांची नोंद आढळली नाही"));
              }

              return ListView.builder(
                itemCount: controller.filteredVisitors.length,
                itemBuilder: (context, index) {
                  final visitor = controller.filteredVisitors[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.person,
                          color: Color.fromARGB(255, 11, 80, 136)),
                      title: Text(visitor["name"] ?? "नाव उपलब्ध नाही"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("भेट क्रमांक: ${visitor["sequence_number"] ?? "-"}"),
                          Text(
                              "पोलिस स्टेशन: ${visitor["police_station_name"] ?? "-"}"),
                          Text(
                              "अधिकारी: ${visitor["officer_to_meet_name"] ?? "-"}"),
                          Text("स्थिती: ${visitor["status"] ?? "-"}"),
                          Text("दिनांक: ${visitor["date"] ?? "-"}"),
                          
                        ],
                      ),
                      onTap: () {
                        final visitorId = visitor["visitor_id"];
                        if (visitorId != null) {
                          Get.to(() =>
                              SpVisitorFormScreen(visitorId: visitorId));
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
















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_form.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_visit_form_controller.dart';

// class VisitFormListScreen extends StatelessWidget {
//   const VisitFormListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final VisitFormController controller = Get.put(VisitFormController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागतांची यादी"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
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
//           // 🔍 Search Bar + Status Filter
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller.searchController,
//                     decoration: InputDecoration(
//                       hintText: "नाव किंवा पोलिस ठाणे शोधा...",
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon: controller.searchController.text.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 controller.searchController.clear();
//                                 controller.applyFilters();
//                               },
//                             )
//                           : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       controller.applyFilters();
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Obx(() {
//                   return DropdownButton<String>(
//                     value: controller.selectedStatus.value,
//                     hint: const Text("स्थिती"),
//                     items: controller.statusOptions
//                         .map((status) => DropdownMenuItem<String>(
//                               value: status,
//                               child: Text(status),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       controller.selectedStatus.value = value;
//                       controller.applyFilters();
//                     },
//                   );
//                 }),
//               ],
//             ),
//           ),

//           // 📋 Visitors List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (controller.filteredVisitors.isEmpty) {
//                 return const Center(child: Text("अभ्यागतांची नोंद आढळली नाही"));
//               }

//               return ListView.builder(
//                 itemCount: controller.filteredVisitors.length,
//                 itemBuilder: (context, index) {
//                   final visitor = controller.filteredVisitors[index];
//                   return Card(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: ListTile(
//                       leading: const Icon(Icons.person,
//                           color: Color.fromARGB(255, 11, 80, 136)),
//                       title: Text(visitor["name"] ?? "नाव उपलब्ध नाही"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                               "पोलिस स्टेशन: ${visitor["police_station_name"] ?? "-"}"),
//                           Text(
//                               "अधिकारी: ${visitor["officer_to_meet_name"] ?? "-"}"),
//                           Text("स्थिती: ${visitor["status"] ?? "-"}"),
//                           Text("दिनांक: ${visitor["date"] ?? "-"}"),
//                         ],
//                       ),
//                       onTap: () {
//                         final visitorId = visitor["visitor_id"];
//                         if (visitorId != null) {
//                           Get.to(() =>
//                               SpVisitorFormScreen(visitorId: visitorId));
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


















// // lib/Screen/View/Forms/sp_visit_form_list.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_form.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_visit_form_controller.dart';

// class VisitFormListScreen extends StatelessWidget {
//   const VisitFormListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final VisitFormController controller = Get.put(VisitFormController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागतांची यादी"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
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
//           // 🔍 Search Bar + Status Filter
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller.searchController,
//                     decoration: InputDecoration(
//                       hintText: "नाव किंवा पोलिस ठाणे शोधा...",
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon: controller.searchController.text.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 controller.searchController.clear();
//                                 controller.applyFilters();
//                               },
//                             )
//                           : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       controller.applyFilters();
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Obx(() {
//                   return DropdownButton<String>(
//                     value: controller.selectedStatus.value,
//                     hint: const Text("स्थिती"),
//                     items: controller.statusOptions
//                         .map((status) => DropdownMenuItem<String>(
//                               value: status,
//                               child: Text(status),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       controller.selectedStatus.value = value;
//                       controller.applyFilters();
//                     },
//                   );
//                 }),
//               ],
//             ),
//           ),

//           // 📋 Visitors List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (controller.filteredVisitors.isEmpty) {
//                 return const Center(child: Text("अभ्यागतांची नोंद आढळली नाही"));
//               }

//               return ListView.builder(
//                 itemCount: controller.filteredVisitors.length,
//                 itemBuilder: (context, index) {
//                   final visitor = controller.filteredVisitors[index];
//                   return Card(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: ListTile(
//                       leading: const Icon(Icons.person,
//                           color: Color.fromARGB(255, 11, 80, 136)),
//                       title: Text(visitor["name"] ?? "नाव उपलब्ध नाही"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("पोलिस स्टेशन: ${visitor["police_station_name"] ?? "-"}"),
//                           Text("अधिकारी: ${visitor["officer_to_meet_name"] ?? "-"}"),
//                           Text("स्थिती: ${visitor["status"] ?? "-"}"),
//                           Text("दिनांक: ${visitor["date"] ?? "-"}"),
//                         ],
//                       ),
//                       onTap: () {
//                         final visitorId = visitor["visitor_id"];
//                         if (visitorId != null) {
//                           Get.to(() => SpVisitorFormScreen(visitorId: visitorId));
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























// // lib/Screen/View/Forms/sp_visit_form_list.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_form.dart';
// import 'package:sp_manage_system/Screen/View/Forms/sp_visit_form_controller.dart';

// class VisitFormListScreen extends StatelessWidget {
//   const VisitFormListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final VisitFormController controller = Get.put(VisitFormController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("अभ्यागतांची यादी"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
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

//           // 📋 Visitors List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (controller.filteredVisitors.isEmpty) {
//                 return const Center(child: Text("अभ्यागतांची नोंद आढळली नाही"));
//               }

//               return ListView.builder(
//                 itemCount: controller.filteredVisitors.length,
//                 itemBuilder: (context, index) {
//                   final visitor = controller.filteredVisitors[index];
//                   return Card(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: ListTile(
//                       leading: const Icon(Icons.person,
//                           color: Color.fromARGB(255, 11, 80, 136)),
//                       title: Text(visitor["name"] ?? "नाव उपलब्ध नाही"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("पोलिस स्टेशन: ${visitor["police_station_name"] ?? "-"}"),
//                           Text("अधिकारी: ${visitor["officer_to_meet_name"] ?? "-"}"),
//                           Text("स्थिती: ${visitor["status"] ?? "-"}"),
//                           Text("दिनांक: ${visitor["date"] ?? "-"}"),
//                         ],
//                       ),
//                       onTap: () {
//                         final visitorId = visitor["visitor_id"];
//                         if (visitorId != null) {
//                           Get.to(() => SpVisitorFormScreen(visitorId: visitorId));
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

