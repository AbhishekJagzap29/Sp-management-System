


import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';
import 'package:sp_manage_system/bottom_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color themeColor = const Color.fromARGB(255, 33, 96, 148);
  String name = '';
  String userType = '';

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  void loadUserDetails() async {
    await preferences.init();
    setState(() {
      name = preferences.getString(SharedPreference.userName) ?? 'अज्ञात';
      userType = preferences.getString(SharedPreference.userType) ?? 'अज्ञात';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('प्रोफाइल'), 
        centerTitle: true,
        backgroundColor: backGroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 6, 51, 131),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: TextStyle(
                      color: backGroundColor,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildInfoTile(Icons.person, "पूर्ण नाव", name), 
                const Divider(),
                _buildInfoTile(Icons.badge, "वापरकर्त्याचा प्रकार", userType.capitalizeFirst ?? 'अज्ञात'), 
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => preferences.logOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text("लॉग आउट"), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: backGroundColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: const TextStyle(color: Colors.black87)),
    );
  }
}
