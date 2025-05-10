import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/login/login_view.dart';

class StatusMessage extends StatefulWidget {
  final String imageAsset;
  final String mainText;
  final String secondaryText;
  final Color mainTextColor;
  final Color secondaryTextColor;
  final Color buttonBorderColor;
  final Color buttonIconColor;
  final Color backgroundColor;
  final Widget nextPage;

  const StatusMessage({
    super.key,
    required this.imageAsset,
    required this.mainText,
    required this.secondaryText,
    required this.mainTextColor,
    required this.secondaryTextColor,
    required this.buttonBorderColor,
    required this.buttonIconColor,
    required this.backgroundColor,
    required this.nextPage,
  });

  @override
  _StatusMessageState createState() => _StatusMessageState();
}

class _StatusMessageState extends State<StatusMessage> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image
        Image.asset(
          widget.imageAsset,
          height: screenHeight * 0.3,
          width: screenHeight * 0.3,
        ),
        const SizedBox(height: 10),
        // Main Text
        Text(
          widget.mainText,
          style: GoogleFonts.inriaSerif(
            textStyle: TextStyle(
              fontSize: 48,
              color: widget.mainTextColor,
            ),
          ),
        ),
        const SizedBox(height: 5),
        // Secondary Text
        Text(
          widget.secondaryText,
          textAlign: TextAlign.center,
          style: GoogleFonts.inriaSerif(
            textStyle: TextStyle(
              fontSize: 24,
              color: widget.secondaryTextColor,
            ),
          ),
        ),
        const SizedBox(height: 15),
        // Next Button
        Row(
          children: [
            // "Next" Label
            Text(
              'Next',
              style: GoogleFonts.inriaSerif(
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: widget.buttonIconColor,
                ),
              ),
            ),
            const Spacer(),
            // Circular Button with Shadow
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.nextPage,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(4, 4), // Offset to simulate light coming from top-left (shadow on bottom-right)
                      blurRadius: 6, // How blurry the shadow is
                      spreadRadius: 1, // How much the shadow spreads
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.backgroundColor,
                    border: Border.all(
                      color: widget.buttonBorderColor,
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: Icon(
                    Icons.arrow_forward,
                    color: widget.buttonIconColor,
                    size: screenWidth * 0.06,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}