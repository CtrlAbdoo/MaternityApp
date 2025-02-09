import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/q1.dart';
import 'package:maternity_app/presentation/login/login_view.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:maternity_app/validation.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Background Image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Sign_Up.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar with Back Arrow, Logo, and Title
              AppBar(
                backgroundColor: Colors.transparent, // Transparent AppBar
                elevation: 0, // Remove shadow
                centerTitle: true, // Center the title content
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.black,
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min, // Use minimum space for the row content
                  children: [
                    Image.asset(
                      'assets/images/logo2.png', // Replace with your logo path
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
              ),

              // Title: Create Account
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenWidth * 0.1,
                ),
                child: Text(
                  'Create\nAccount',
                  style: GoogleFonts.inriaSerif(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Form Section
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // First Name and Last Name
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    labelStyle: GoogleFonts.inriaSerif(
                                      textStyle: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: ColorManager.txtEditor_font_color,
                                      ),
                                    ),
                                  ),
                                  validator: (value) =>
                                      InputValidator.validateName(value),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    labelStyle: GoogleFonts.inriaSerif(
                                      textStyle: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: ColorManager.txtEditor_font_color,
                                      ),
                                    ),
                                  ),
                                  validator: (value) =>
                                      InputValidator.validateName(value),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Email Field
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
                            validator: (value) =>
                                InputValidator.validateEmail(value),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Password Field with Visibility Toggle
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.inriaSerif(
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: ColorManager.txtEditor_font_color,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) =>
                                InputValidator.validatePassword(value),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Phone Field
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: GoogleFonts.inriaSerif(
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: ColorManager.txtEditor_font_color,
                                ),
                              ),
                            ),
                            validator: (value) =>
                                InputValidator.validatePhoneNumber(value),
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Sign-Up Button (Circular Arrow)
                          Row(
                            children: [
                              // "Sign up" Text
                              Text(
                                'Sign up',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.inriaSerif(
                                  textStyle: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Spacer(),

                              // Circular Button
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Q1(),
                                      ),
                                    );
                                    print('Form is valid!');
                                  } else {
                                    print('Form is invalid!');
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFB6E8F8), // Light Blue
                                        Color(0xFF90CAF9), // Sky Blue
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(screenWidth * 0.06),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                    size: screenWidth * 0.06,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.07),

                          // Sign-In Link
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginView(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.inriaSerif(
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
