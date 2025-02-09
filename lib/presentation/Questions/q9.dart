import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/q5.dart';

class Q9 extends StatefulWidget {
  @override
  _Q9State createState() => _Q9State();
}

class _Q9State extends State<Q9> {
  List<bool> isSelected = [false, false, false];

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
                  margin: EdgeInsets.only(top: screenHeight * 0.03),
                  height: screenHeight * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/pregnant2.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Question Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Are you suffering from\nstress?",
                    style: GoogleFonts.inriaSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Options
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildOptionButton(0, "Yes"),
                        SizedBox(height: screenHeight * 0.02),
                        _buildOptionButton(1, "No"),
                        SizedBox(height: screenHeight * 0.02),
                        _buildOptionButton(2, "sometimes"),
                      ],
                    ),
                  ),
                ),

                // Continue Button (Sticky at the Bottom)
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
                            builder: (context) => Q5(),
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

  Widget _buildOptionButton(int index, String text) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFF87CEEB), // Sky-blue shadow
            offset: Offset(6, 6), // Downward-right direction
            blurRadius: 10, // Soft blur effect
            spreadRadius: 2, // Slightly expand the shadow area
          ),
        ],
        borderRadius: BorderRadius.circular(25), // Matches the button's border radius
      ),
      child: SizedBox(
        width: 370,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              // Reset all selections to false
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = false;
              }
              // Select the current button
              isSelected[index] = true;
            });
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