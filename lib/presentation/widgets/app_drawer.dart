import 'package:flutter/material.dart';
import 'package:maternity_app/presentation/screens/pregnancy_problems/pregnancy_problems_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildNavigationItem(
            context,
            title: 'Home',
            icon: Icons.home_outlined,
            onTap: () {
              Navigator.pop(context);
              // Navigate to home if not already there
            },
          ),
          _buildNavigationItem(
            context,
            title: 'Pregnancy Problems',
            icon: Icons.healing_outlined,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PregnancyProblemsScreen(),
                ),
              );
            },
          ),
          _buildNavigationItem(
            context,
            title: 'My Pregnancy',
            icon: Icons.pregnant_woman_outlined,
            onTap: () {
              Navigator.pop(context);
              // Navigate to pregnancy dashboard
            },
          ),
          _buildNavigationItem(
            context,
            title: 'Medications',
            icon: Icons.medication_outlined,
            onTap: () {
              Navigator.pop(context);
              // Navigate to medications screen
            },
          ),
          _buildNavigationItem(
            context,
            title: 'Appointments',
            icon: Icons.calendar_today_outlined,
            onTap: () {
              Navigator.pop(context);
              // Navigate to appointments screen
            },
          ),
          _buildNavigationItem(
            context,
            title: 'Health Tracking',
            icon: Icons.favorite_border_outlined,
            onTap: () {
              Navigator.pop(context);
              // Navigate to health tracking screen
            },
          ),
          const Divider(),
          _buildNavigationItem(
            context,
            title: 'Settings',
            icon: Icons.settings_outlined,
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings screen
            },
          ),
          _buildNavigationItem(
            context,
            title: 'Help & Support',
            icon: Icons.help_outline,
            onTap: () {
              Navigator.pop(context);
              // Navigate to help screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.shade100,
            Colors.blue.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Maternity App',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your pregnancy companion',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          // TODO: Replace with user data when available
          const Text(
            'Hello, Mom!',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
} 