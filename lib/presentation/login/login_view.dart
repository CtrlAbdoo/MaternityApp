import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/q1.dart';
import 'package:maternity_app/presentation/register/register_view.dart';
import 'package:maternity_app/presentation/forgot_password/forgot_password_view.dart';
import 'package:maternity_app/validation.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تسجيل الدخول ناجح!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Q1()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "⚠️ خطأ في تسجيل الدخول!";
      if (e.code == 'wrong-password') {
        errorMessage = "❌ كلمة المرور غير صحيحة.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "❌ البريد الإلكتروني غير مسجل.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "⚠️ تم تعطيل هذا الحساب.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Sign_In.png'), // صورة الخلفية
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
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

              // Welcome Text
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenWidth * 0.1),
                child: Text(
                  'Welcome\nBack',
                  style: GoogleFonts.inriaSerif(
                    textStyle: TextStyle(
                        fontSize: screenWidth * 0.10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                            validator: (value) =>
                                InputValidator.validateEmail(value),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Password Field
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

                          // Forgot Password
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordView()));
                            },
                            child: Center(
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.inriaSerif(
                                  textStyle: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),

                          // Login Button
                          GestureDetector(
                            onTap: _isLoading ? null : _login,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFB6E8F8),
                                    Color(0xFF90CAF9)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: EdgeInsets.all(screenWidth * 0.06),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.black)
                                  : Icon(Icons.arrow_forward,
                                      color: Colors.black,
                                      size: screenWidth * 0.06),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.07),

                          // Sign Up Link
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterView()));
                            },
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.inriaSerif(
                                  textStyle: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
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
