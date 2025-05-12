import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/drawer/maternity_bag.dart';
import 'package:maternity_app/presentation/profile/account_info_screen.dart';
import 'package:maternity_app/presentation/screens/children_newborns/children_newborns_screen.dart';
import 'package:maternity_app/presentation/screens/pregnancy_problems/pregnancy_problems_screen.dart';
import 'package:maternity_app/presentation/settings/settings_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = 'Loading...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user data from Firestore
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          final firstName = userData.data()?['firstName'] as String? ?? '';
          final lastName = userData.data()?['lastName'] as String? ?? '';
          
          if (mounted) {
            setState(() {
              userName = '$firstName $lastName'.trim();
              if (userName.isEmpty) {
                userName = user.email ?? 'User';
              }
              isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              userName = user.email ?? 'User';
              isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            userName = 'Guest';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user name: $e');
      if (mounted) {
        setState(() {
          userName = 'User';
          isLoading = false;
        });
      }
    }
  }

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
            const Image(image: const AssetImage('assets/images/logo3.png'), height: 80),
            
            const SizedBox(height: 20),
            // Name
            isLoading 
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                  ),
                )
              : Text(
                  userName,
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
          
            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(Icons.person, 'Profile', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountInfoScreen()),
                    ).then((_) => _loadUserName()); // Reload name when returning from profile
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
