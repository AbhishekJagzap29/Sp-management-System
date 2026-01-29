// import 'package:flutter/material.dart';
// import 'package:sp_manage_system/Screen/Constant/app_color.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/admin_dashboard.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/general_officer_dashboard.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/pi_officer_dashboard.dart';
// import 'package:sp_manage_system/Screen/View/Dashboards/sp_officer_dashboard.dart';
// import 'package:sp_manage_system/Screen/View/ProfileScreen/profile_screen.dart';

// class HomeScreen extends StatefulWidget {
//   final String userType;
//   const HomeScreen({super.key, required this.userType});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

// List<Widget> getScreens() {
//   final userType = widget.userType.toLowerCase().trim();

//   if (userType == 'admin') {
//     return [
//       AdminDashboardScreen(userType: widget.userType),
//       const ProfileScreen(),
//     ];
//   } else if (userType == 'officer') {
//     return [
//       OfficerDashboardScreen(userType: widget.userType),
//       const ProfileScreen(),
//     ];
//   } else if (userType == 'sp_officer') {
//     return [
//       SpOfficerDashboardScreen(userType: widget.userType),
//       const ProfileScreen(),
//     ];
//   } else if (userType == 'pi_officer') {
//     return [
//       PiOfficerDashboardScreen(userType: widget.userType, policeStationId: 0), // TODO: Replace 0 with actual policeStationId
//       const ProfileScreen(),
//     ];
//   } else {
//     return [
//       const Center(child: Text("Invalid User Type")),
//       const ProfileScreen(),
//     ];
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     final screens = getScreens();
//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) => setState(() => _selectedIndex = index),
//         selectedItemColor: backGroundColor,
//         unselectedItemColor: const Color.fromARGB(255, 71, 69, 69),
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'माहिती पटल',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'प्रोफाइल',
//           ),
//         ],
//       ),
//     );
//   }
// }



















import 'package:flutter/material.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/admin_dashboard.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/general_officer_dashboard.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/pi_officer_dashboard.dart';
import 'package:sp_manage_system/Screen/View/Dashboards/sp_officer_dashboard.dart';
import 'package:sp_manage_system/Screen/View/ProfileScreen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userType;
  const HomeScreen({super.key, required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

List<Widget> getScreens() {
  final userType = widget.userType.toLowerCase().trim();

  if (userType == 'admin') {
    return [
      AdminDashboardScreen(userType: widget.userType),
      const ProfileScreen(),
    ];
  } else if (userType == 'officer') {
    return [
      OfficerDashboardScreen(userType: widget.userType),
      const ProfileScreen(),
    ];
  } else if (userType == 'sp_officer') {
    return [
      SpOfficerDashboardScreen(userType: widget.userType),
      const ProfileScreen(),
    ];
  } else if (userType == 'pi_officer') {
    return [
      PiOfficerDashboardScreen(userType: widget.userType,),
      const ProfileScreen(),
    ];
  } else {
    return [
      const Center(child: Text("Invalid User Type")),
      const ProfileScreen(),
    ];
  }
}


  @override
  Widget build(BuildContext context) {
    final screens = getScreens();
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: backGroundColor,
        unselectedItemColor: const Color.fromARGB(255, 71, 69, 69),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'माहिती पटल',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'प्रोफाइल',
          ),
        ],
      ),
    );
  }
}
