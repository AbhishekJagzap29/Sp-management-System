import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  final String userType;
  const AdminDashboardScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _dashboardCard(Icons.people, 'Manage Users'),
          _dashboardCard(Icons.analytics, 'Reports'),
          _dashboardCard(Icons.settings, 'Settings'),
          _dashboardCard(Icons.logout, 'Logout'),
        ],
      ),
    );
  }

  Widget _dashboardCard(IconData icon, String title) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
