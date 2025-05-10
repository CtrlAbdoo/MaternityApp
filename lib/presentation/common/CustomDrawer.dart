import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/drawer/maternity_bag.dart';
import 'package:maternity_app/presentation/screens/children_newborns/children_newborns_screen.dart';
import 'package:maternity_app/presentation/screens/pregnancy_problems/pregnancy_problems_screen.dart';
import 'package:maternity_app/presentation/settings/settings_dialog.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 224,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD0E8FF), Color(0xFFF5D7EB)],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Profile Image
           const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/profile.png'), // Replace with actual image path
            ),
            const SizedBox(height: 10),
            // Name
            Text(
              'Manar Ahmed',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Divider
            const Divider(color: Colors.black54, thickness: 1, indent: 40, endIndent: 40),
            const SizedBox(height: 10),
            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(Icons.person, 'Profile', () {
                    // Add navigation for Profile if needed
                  }),
                  _buildDrawerItem(Icons.shopping_bag, 'Maternity bag', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MaternityBagScreen()),
                    );
                  }),
                  _buildDrawerItem(Icons.health_and_safety, 'Pregnancy problems', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PregnancyProblemsScreen()),
                    );
                  }),
                  _buildDrawerItem(Icons.child_care, 'Children and newborns', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChildrenNewbornsScreen()),
                    );
                  }),
                
                  _buildDrawerItem(Icons.settings, 'Settings', () {
                    // Show settings dialog
                    showSettingsDialog(context);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: GoogleFonts.inriaSerif(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      onTap: onTap, // Calls the passed function when tapped
    );
  }
}
