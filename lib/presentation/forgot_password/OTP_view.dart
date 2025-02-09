import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:maternity_app/presentation/forgot_password/reset_password_view.dart';

class VerificationCodeView extends StatefulWidget {
  const VerificationCodeView({Key? key}) : super(key: key);

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  final TextEditingController _otpController = TextEditingController();
  int _timer = 60; // Countdown in seconds
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timer > 0) {
          _timer--;
        } else {
          _countdownTimer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    setState(() {
      _timer = 60; // Reset timer
    });
    _startTimer();
    // Add functionality for resending code
  }

  void _onKeypadPress(String value) {
    if (_otpController.text.length < 4) {
      setState(() {
        _otpController.text += value;
      });
    }
  }

  void _onDeletePress() {
    if (_otpController.text.isNotEmpty) {
      setState(() {
        _otpController.text = _otpController.text
            .substring(0, _otpController.text.length - 1);
      });
    }
  }

  void _onNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPasswordView(),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Background Image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Sign_In.png'), // Replace with your image
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar with logo
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/logo2.png', // Replace with your logo path
                      height: screenHeight * 0.05,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Mamativity',
                      style: GoogleFonts.inriaSerif(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Title and description
              Center(
                child: Column(
                  children: [
                    Text(
                      'Verification Code',
                      style: GoogleFonts.inriaSerif(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'We have sent you an OTP code',
                      style: GoogleFonts.inriaSerif(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // OTP Input Boxes
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _otpController.text.length > index
                            ? _otpController.text[index]
                            : '',
                        style: GoogleFonts.inriaSerif(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Timer and Resend Code
              Center(
                child: Text.rich(
                  TextSpan(
                    text: _timer > 0
                        ? 'Wait For 00:${_timer.toString().padLeft(2, '0')} '
                        : '',
                    style: GoogleFonts.inriaSerif(
                      color: Colors.black45,
                      fontSize: screenWidth * 0.04,
                    ),
                    children: [
                      TextSpan(
                        text: 'Send Again',
                        style: GoogleFonts.inriaSerif(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _timer == 0 ? _resendCode : null,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.1),

              // "Next" Text and Arrow Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Row(
                  children: [
                    Text(
                      'Next',
                      style: GoogleFonts.inriaSerif(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _onNext,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFB6E8F8), Color(0xFF90CAF9)],
                          ),
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.06),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Custom Numeric Keypad
              Container(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF9D9F0), Color(0xFFB3E5FC)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    _buildKeypadRow(['1', '2', '3']),
                    _buildKeypadRow(['4', '5', '6']),
                    _buildKeypadRow(['7', '8', '9']),
                    _buildKeypadRow(['', '0', 'delete']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key == 'delete') {
          return GestureDetector(
            onTap: _onDeletePress,
            child: Container(
              width: 80,
              height: 60,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.backspace_outlined,
                size: 28,
                color: Colors.black54,
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: key.isNotEmpty ? () => _onKeypadPress(key) : null,
          child: Container(
            width: 80,
            height: 60,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              key,
              style: GoogleFonts.inriaSerif(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
