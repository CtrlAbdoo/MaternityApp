import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/Q6.dart';
import 'package:maternity_app/presentation/Questions/q2.dart';
import 'package:maternity_app/presentation/Questions/q9.dart';

class Q1 extends StatefulWidget {
  @override
  _Q1State createState() => _Q1State();
}

class _Q1State extends State<Q1> {
  List<bool> isSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD6E7), Color(0xFFB5E4F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                // Top Image
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.2),
                  height: screenHeight * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/pregnant.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Question Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Are you currently pregnant?",
                    style: GoogleFonts.inriaSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Options
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.07),
                  child: Column(
                    children: [
                      _buildOptionButton(0, "Yes", Q6()),
                      SizedBox(height: screenHeight * 0.02),
                      _buildOptionButton(1, "No", Q2()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, String text, Widget page) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFF87CEEB),
            offset: Offset(6, 6),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
        width: 370,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = false;
              }
              isSelected[index] = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF965391).withOpacity(isSelected[index] ? 1.0 : 0.59),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 30,
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.inriaSerif(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}