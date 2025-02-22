import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final dynamic backgroundColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.black,
    this.backgroundColor = const Color(0xFFBBE2F4),
    this.width,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: backgroundColor is Color ? backgroundColor : null,
      ).copyWith(
        foregroundColor: WidgetStateProperty.all<Color>(textColor),
        backgroundColor: backgroundColor is LinearGradient
            ? WidgetStateProperty.all<Color>(Colors.transparent)
            : null,
        shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
      ),
      child: Container(
        width: width,
        height: height, // Fixed height applied
        alignment: Alignment.center, // Center text
        decoration: BoxDecoration(
          gradient: backgroundColor is LinearGradient ? backgroundColor : null,
          color: backgroundColor is Color ? backgroundColor : null,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.inriaSerif(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
