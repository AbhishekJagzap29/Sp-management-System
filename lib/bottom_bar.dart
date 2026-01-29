// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/admin_dashboard.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/general_officer_dashboard.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/pi_officer_dashboard.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/sp_officer_dashboard.dart';

// class BottomNavBar extends StatefulWidget {
//   final String userType;
//   const BottomNavBar({Key? key, required this.userType}) : super(key: key);

//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (index == 0) {
//       if (widget.userType == 'admin') {
//         Get.offAll(() => AdminDashboardScreen(userType: widget.userType));
//       } else if (widget.userType == 'officer') {
//         Get.offAll(() => OfficerDashboardScreen(userType: widget.userType));
//       } else if (widget.userType == 'sp_officer') {
//         Get.offAll(() => SpOfficerDashboardScreen(userType: widget.userType));
//       } else if (widget.userType == 'pi_officer') {
//         Get.offAll(() => PiOfficerDashboardScreen(
//               userType: widget.userType,
//               policeStationId: 0,
//             ));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.dashboard,
//             color: _selectedIndex == 0 ? Colors.black : Colors.blue,
//           ),
//           label: 'माहिती पटल',
//           backgroundColor: _selectedIndex == 0 ? Colors.blue : Colors.grey,
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.person,
//             color: _selectedIndex == 1 ? Colors.black : Colors.blue,
//           ),
//           label: 'प्रोफाइल',
//           backgroundColor: _selectedIndex == 1 ? Colors.blue : Colors.grey,
//         ),
//       ],
//       currentIndex: _selectedIndex,
//       selectedItemColor: Colors.black,
//       unselectedItemColor: backGroundColor,
//       onTap: _onItemTapped,
//       type: BottomNavigationBarType.fixed,
//     );
//   }
// }
















import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/admin_dashboard.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/general_officer_dashboard.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/pi_officer_dashboard.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/sp_officer_dashboard.dart';

class BottomNavBar extends StatefulWidget {
  final String userType;
  const BottomNavBar({Key? key, required this.userType}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      if (widget.userType == 'admin') {
        Get.offAll(() => AdminDashboardScreen(userType: widget.userType));
      } else if (widget.userType == 'officer') {
        Get.offAll(() => OfficerDashboardScreen(userType: widget.userType));
      } else if (widget.userType == 'sp_officer') {
        Get.offAll(() => SpOfficerDashboardScreen(userType: widget.userType));
      } else if (widget.userType == 'pi_officer') {
        Get.offAll(() => PiOfficerDashboardScreen(userType: widget.userType));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dashboard,
            color: _selectedIndex == 0 ? Colors.black : Colors.blue,
          ),
          label: 'माहिती पटल',
          backgroundColor: _selectedIndex == 0 ? Colors.blue : Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: _selectedIndex == 1 ? Colors.black : Colors.blue,
          ),
          label: 'प्रोफाइल',
          backgroundColor: _selectedIndex == 1 ? Colors.blue : Colors.grey,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: backGroundColor,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
