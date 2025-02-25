import 'package:flutter/material.dart';

class ColorManager {
  static Color primary_font_color = const Color(0xff000000);
  static Color secondary_font_color = const Color(0xff625B60);
  static Color txtEditor_font_color = const Color(0xff322E31);
  static Color grey_color = const Color(0xff4C4A4A);
  static const LinearGradient skyBlueGradient = LinearGradient(
    colors: [
      Color(0xffFFFFFF),
      Color(0xff89DDF7),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static LinearGradient BG_Gradient = LinearGradient(
    colors: [
      Color(0xFFFFCFFA),
      Color(0xFFCBF3FF)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient BG1_Gradient = LinearGradient(
    colors: [
      Color(0xFFFFB7F8),
      Color(0xFF89DDF7)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient BG2_Gradient = LinearGradient(
    colors: [
      Color(0xFFFFCFFA),
      Color(0xFFCBF3FF)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient BG3_Gradient = LinearGradient(
    colors: [
      Color(0xFFCBF3FF),
      Color(0xFFFFCFFA)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}