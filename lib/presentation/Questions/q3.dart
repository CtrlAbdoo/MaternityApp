import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/q4.dart';

class Q3 extends StatefulWidget {
  const Q3({super.key});

  @override
  _Q3State createState() => _Q3State();
}

class _Q3State extends State<Q3> {
  Map<String, bool> selections = {
    "Boy": false,
    "Girl": false,
    "Twin girls": false,
    "Twin boys": false,
    "Twin": false,
  };

  Color _getCheckboxColor(String gender) {
    return (gender == "Boy" || gender == "Twin boys") ? Colors.blue : Colors.pink;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Center(
              child: Text(
                "Determine the gender of\nthe child",
                style: GoogleFonts.inriaSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: selections.keys.map((gender) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selections[gender] = !selections[gender]!;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: selections[gender],
                                onChanged: (value) {
                                  setState(() {
                                    selections[gender] = value!;
                                  });
                                },
                                activeColor: _getCheckboxColor(gender),
                              ),
                              Text(
                                gender,
                                style: GoogleFonts.inriaSerif(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            'assets/images/${gender.toLowerCase()}_image.png',
                            height: screenHeight * 0.11, // Ensuring uniform height
                            width: screenWidth * 0.37,  // Ensuring uniform width
                            fit: BoxFit.fill,          // Ensures the image fits properly within the set dimensions
                          ),

                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Skip",
                      style: GoogleFonts.inriaSerif(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0x51000000),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Q4()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBBE2F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.1,
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.inriaSerif(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}