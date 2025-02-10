import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/Q6.dart';

class Q5 extends StatefulWidget {
  @override
  _Q5State createState() => _Q5State();
}

class _Q5State extends State<Q5> {
  int? selectedPregnancy;
  int? selectedFirstPregnancy;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            // Remove fixed height to allow scrolling
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
                  margin: EdgeInsets.only(top: screenHeight * 0.03),
                  height: screenHeight * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/pregnant.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // First Question
                _buildQuestionSection(
                  question: "Are you currently pregnant?",
                  selectedIndex: selectedPregnancy,
                  onSelected: (index) => setState(() => selectedPregnancy = index),
                ),
                // Second Question
                _buildQuestionSection(
                  question: "Is this your first pregnancy?",
                  selectedIndex: selectedFirstPregnancy,
                  onSelected: (index) => setState(() => selectedFirstPregnancy = index),
                ),
                // Spacer to push button to bottom
                SizedBox(height: screenHeight * 0.05), // Replace Expanded with SizedBox
                // Continue Button
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                  child: Container(
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Q6(), // Replace with actual next page
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBBE2F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.011,
                          horizontal: screenWidth * 0.142,
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: GoogleFonts.inriaSerif(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection({
    required String question,
    required int? selectedIndex,
    required Function(int?) onSelected,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          Text(
            question,
            style: GoogleFonts.inriaSerif(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Column(
            children: [
              _buildOptionButton(
                isSelected: selectedIndex == 0,
                text: "Yes",
                onPressed: () => onSelected(0),
              ),
              SizedBox(height: 20),
              _buildOptionButton(
                isSelected: selectedIndex == 1,
                text: "No",
                onPressed: () => onSelected(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required bool isSelected,
    required String text,
    required VoidCallback onPressed,
  }) {
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
        width: 370, // Fixed width from original code
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF965391).withOpacity(isSelected ? 1.0 : 0.59),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
          child: Text(
            text,
            style: GoogleFonts.inriaSerif(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}