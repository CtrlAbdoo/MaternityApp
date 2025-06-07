import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/q1.dart';
import 'package:maternity_app/presentation/login/login_view.dart';
import 'package:maternity_app/presentation/Questions/q2.dart';
import 'package:maternity_app/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

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

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Q1()),
          );

          print('User registered and data saved successfully!');
        }
      } catch (e) {
        print('Error registering user');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed')),
        );
      }
    } else {
      print('Form is invalid!');
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
            image: AssetImage('assets/images/Sign_Up.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new_sharp,
                      color: Colors.black),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo2.png',
                        height: screenHeight * 0.08, width: screenWidth * 0.1),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Mamativity',
                      style: GoogleFonts.inriaSerif(
                        textStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenWidth * 0.1),
                child: Text(
                  'Create\nAccount',
                  style: GoogleFonts.inriaSerif(
                    textStyle: TextStyle(
                        fontSize: screenWidth * 0.10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration:
                                  const InputDecoration(labelText: 'First Name'),
                                  validator: (value) =>
                                      InputValidator.validateName(value),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration:
                                  const InputDecoration(labelText: 'Last Name'),
                                  validator: (value) =>
                                      InputValidator.validateName(value),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (value) =>
                                InputValidator.validateEmail(value),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
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
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(labelText: 'Phone'),
                            validator: (value) =>
                                InputValidator.validatePhoneNumber(value),
                          ),
                          SizedBox(height: screenHeight * 0.1),


                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LoginView()));
                                },
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.inriaSerif(
                                    textStyle: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: _registerUser,
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

                          SizedBox(height: screenHeight * 0.07),

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
