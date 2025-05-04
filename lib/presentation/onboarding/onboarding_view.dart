import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/register/register_view.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:maternity_app/presentation/resources/font_manager.dart';
import 'package:maternity_app/presentation/resources/values_manager.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onButtonPressed;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonText,
    required this.currentIndex,
    required this.totalPages,
    required this.onButtonPressed,
  }) : super(key: key);

  // Inside the OnboardingPage class
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight = mediaQuery.size.height;
    final double screenWidth = mediaQuery.size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Column(
        children: [
          // Progress Indicator Row at the Top
          Container(
            width: double.infinity, // Makes the Row take full width
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.06),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Spread children
              children: List.generate(totalPages, (index) {
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Color(0xFF89DDF7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Title (Bigger but Responsive)
          Text(
            title,
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.075, // Increased font size
                fontWeight: FontWeightManager.bold,
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.primary_font_color,
              ),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenHeight * 0.04),

          // Image (Increased Size)
          Image.asset(
            imagePath,
            height: screenHeight * 0.38, // Increased height
            width: screenWidth * 0.88, // Slightly increased width
            fit: BoxFit.contain,
          ),

          SizedBox(height: screenHeight * 0.04),

          // Description (Bigger but Responsive)
          Text(
            description,
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.045, // Increased font size
                fontWeight: FontWeightManager.regular,
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.secondary_font_color,
              ),
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterView()));// Example: Go back
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeightManager.medium,
                        color: ColorManager.grey_color,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.015,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.blue.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.04),
        ],
      ),
    );
  }
}
