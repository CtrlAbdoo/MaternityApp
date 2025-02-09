import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/q3.dart';

class Q2 extends StatefulWidget {
  @override
  _Q2State createState() => _Q2State();
}

class _Q2State extends State<Q2> {
  bool isBoySelected = false;
  bool isGirlSelected = false;

  void _onGenderSelected(String gender) {
    setState(() {
      if (gender == "Boy") {
        isBoySelected = true;
        isGirlSelected = false;
      } else {
        isBoySelected = false;
        isGirlSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.02),
            // Title
            Text(
              "Determine the gender of\nthe child",
              style: GoogleFonts.inriaSerif(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: screenHeight * 0.01),

            // Boy Option
            GestureDetector(
              onTap: () => _onGenderSelected("Boy"),
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.33,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/boy_image.png'), // Replace with actual image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isBoySelected,
                        onChanged: (value) => _onGenderSelected("Boy"),
                      ),
                      Text(
                        "Boy",
                        style: GoogleFonts.inriaSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Girl Option
            GestureDetector(
              onTap: () => _onGenderSelected("Girl"),
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.31,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/girl_image.png'), // Replace with actual image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isGirlSelected,
                        onChanged: (value) => _onGenderSelected("Girl"),
                      ),
                      Text(
                        "Girl",
                        style: GoogleFonts.inriaSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Skip and Continue Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Skip",
                    style: GoogleFonts.inriaSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0x51000000),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.009,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF87CEEB),
                        offset: Offset(6, 6),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25), // Matches the button's border radius
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Q3(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFBBE2F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.142,
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.inriaSerif(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
