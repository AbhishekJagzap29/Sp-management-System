import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/View/Forms/pi_sub_form.dart';
import '../../Constant/app_color.dart';
import 'pi_submitted_controller.dart';

class PiSubmittedListScreen extends StatelessWidget {
  const PiSubmittedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PiSubmittedController controller = Get.put(PiSubmittedController());
    controller.fetchSubmittedForms();

    return Scaffold(
      appBar: AppBar(
        title: const Text("सादर केलेले अर्ज"),
        centerTitle: true,
        backgroundColor: backGroundColor,
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

          // 📋 Submitted List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredList.isEmpty) {
                return const Center(child: Text("डेटा उपलब्ध नाही"));
              }

              return ListView.builder(
                itemCount: controller.filteredList.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredList[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.description,
                          color: Color.fromARGB(255, 11, 80, 136)),
                      title: Text(item['name'] ?? 'नाव उपलब्ध नाही'),
                      subtitle: Text(
                        "स्थिती: ${item['status'] ?? 'अज्ञात'}\n"
                        "पोलीस ठाणे: ${item['police_station_name'] ?? ''}\n"
                        "दिनांक: ${item['date'] ?? ''}",
                      ),
                      onTap: () {
                        Get.to(() => PiSubFormScreen(
                              visitorId: item['visitor_id'],
                            ));
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













// // lib/Screen/View/Forms/pi_submitted_list.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/View/Forms/pi_sub_form.dart';
// import '../../Constant/app_color.dart';
// import 'pi_submitted_controller.dart';

// class PiSubmittedListScreen extends StatelessWidget {
//   const PiSubmittedListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final PiSubmittedController controller = Get.put(PiSubmittedController());
//     controller.fetchSubmittedForms();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("सादर केलेले अर्ज"),
//         centerTitle: true,
//         backgroundColor: backGroundColor,
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

//           // 📋 Submitted List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (controller.filteredList.isEmpty) {
//                 return const Center(child: Text("डेटा उपलब्ध नाही"));
//               }

//               return ListView.builder(
//                 itemCount: controller.filteredList.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.filteredList[index];
//                   return Card(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: ListTile(
//                       leading: const Icon(Icons.description,
//                           color: Color.fromARGB(255, 11, 80, 136)),
//                       title: Text(item['name'] ?? 'नाव उपलब्ध नाही'),
//                       subtitle: Text(
//                         "स्थिती: ${item['status'] ?? 'अज्ञात'}\n"
//                         "पोलीस ठाणे: ${item['police_station_name'] ?? ''}\n"
//                         "दिनांक: ${item['date'] ?? ''}",
//                       ),
//                       onTap: () {
//                         Get.to(() => PiSubFormScreen(
//                               visitorId: item['visitor_id'],
//                             ));
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
// import 'package:sp_manage_system/Screen/View/Forms/pi_sub_form.dart';
// import 'pi_submitted_controller.dart';

// class PiSubmittedListScreen extends StatelessWidget {
//   const PiSubmittedListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final PiSubmittedController controller = Get.put(PiSubmittedController());
//     controller.fetchSubmittedForms();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("सादर केलेले अर्ज"),
//         backgroundColor: const Color.fromRGBO(6, 51, 131, 1),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.submittedList.isEmpty) {
//           return const Center(child: Text("डेटा उपलब्ध नाही"));
//         }

//         return ListView.builder(
//           itemCount: controller.submittedList.length,
//           itemBuilder: (context, index) {
//             final item = controller.submittedList[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//               child: ListTile(
//                 leading: const Icon(Icons.description, color: Color.fromARGB(255, 11, 80, 136)),
//                 title: Text(item['name'] ?? 'नाव उपलब्ध नाही'),
//                 subtitle: Text(
//                     "स्थिती: ${item['status'] ?? 'अज्ञात'}\nपोलीस ठाणे: ${item['police_station_name'] ?? '---'}"),
//                 onTap: () {
//                     Get.to(() => PiSubFormScreen(visitorId: item['visitor_id']));
//                 },
//               ),
              
//             );
//           },
          
//         );
//       }),
//     );
//   }
// }





