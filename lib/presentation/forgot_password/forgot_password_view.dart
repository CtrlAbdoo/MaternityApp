import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maternity_app/presentation/forgot_password/oops_message.dart';
import 'package:maternity_app/presentation/forgot_password/success_message.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:maternity_app/validation.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();


  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email address.')),
      );
      return;
    }

    try {
      // First check if the email exists in Firestore
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OopsMessage()));
        return;
      }

      // If email exists, send the reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;

      Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessMessage()));
    } catch (error) {
      debugPrint('Error sending reset email: $error');
      if (!mounted) return;

      Navigator.push(context, MaterialPageRoute(builder: (context) => const OopsMessage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Sign_In.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context, screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.06),
              _buildHeaderText(screenWidth),
              SizedBox(height: screenHeight * 0.04),
              _buildForm(screenHeight, screenWidth, context),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, double screenHeight, double screenWidth) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.black,
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo2.png',
            height: screenHeight * 0.08,
            width: screenWidth * 0.1,
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            'Mamativity',
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(double screenWidth) {
    return Column(
      children: [
        Center(
          child: Text(
            'Forgot Password',
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.09,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            'Reset account password and access\nyour personal account again',
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(
      double screenHeight, double screenWidth, BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400, // Reduced max width for better mobile experience
          ),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: GoogleFonts.inriaSerif(
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: ColorManager.txtEditor_font_color,
                        ),
                      ),
                    ),
                    validator: (value) => InputValidator.validateEmail(value),
                  ),
                  SizedBox(height: screenHeight * 0.3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next',
                        style: GoogleFonts.inriaSerif(
                          textStyle: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _sendPasswordResetEmail(context);
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFB6E8F8), Color(0xFF90CAF9)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          child: Icon(Icons.arrow_forward,
                              color: Colors.black,
                              size: screenWidth * 0.06),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
