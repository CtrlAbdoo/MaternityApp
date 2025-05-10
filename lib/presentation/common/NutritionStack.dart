import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionStack extends StatelessWidget {
  final String imagePath;
  final String text;

  const NutritionStack({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // The Image
          Image.asset(
            imagePath,
            width: double.infinity,
            height: 118,
            fit: BoxFit.cover,
          ),

          // Semi-transparent container starting from the bottom
          Positioned(
            bottom: 0, // Aligns the container to the bottom of the stack
            left: 0,
            right: 0,
            child: Container(
              height: 35, // Height of the semi-transparent overlay
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4), // Black with opacity
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 7,
            left: 10,
            child: Text(
              text,
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}