import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/forgot_password/reset_password_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:maternity_app/presentation/resources/routes_manager.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [Color(0xFFF5D7EB), Color(0xFFD0E8FF)],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: Row(
                children: [
                  // Back button
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: ColorManager.BG3_Gradient,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.all(1.5), // thickness of the border
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.55), // inner content background
                        borderRadius:
                            BorderRadius.circular(37), // slightly smaller
                      ),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0x51FFFFFF),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white70),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ), // your content here
                    ),
                  ),

                  const SizedBox(width: 16),
                  // Setting title
                  Text(
                    "Settings",
                    style: GoogleFonts.inriaSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Reset password option
                  _buildSettingOption(
                    context,
                    'Reset password',
                    () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPasswordView()),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Divider(height: 1, thickness: 0.5),
                  ),
                  // Sign out option
                  _buildSettingOption(
                    context,
                    'Sign out',
                    () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pop(context); // Close dialog
                      Navigator.pushReplacementNamed(
                          context, Routes.loginRoute);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Divider(height: 1, thickness: 0.5),
                  ),

                  const SizedBox(height: 35),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(
      BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inriaSerif(
                fontSize: 24,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return ColorManager.BG3_Gradient.createShader(bounds);
              },
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 49,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the settings dialog
void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => const SettingsDialog(),
  );
}
