
import 'package:flutter/material.dart';

/// This is a utility class to generate placeholder images
/// for the pregnancy problems screen.
/// 
/// In a real app, you would use actual images instead.
class PregnancyImageCreator {
  static Future<void> createPlaceholderImages() async {
    // Create images for each month
    for (int i = 1; i <= 9; i++) {
      await _createMonthImage(i);
    }
  }

  static Future<void> _createMonthImage(int month) async {
    // Create a global key to identify the RepaintBoundary
    final key = GlobalKey();
    
    // Create a placeholder image with month number
    final widget = RepaintBoundary(
      key: key,
      child: Container(
        width: 300,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getColorsForMonth(month),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              if (month % 3 == 1)
                Positioned(
                  left: 20,
                  bottom: 10,
                  child: _buildPregnancyIcon(month),
                )
              else if (month % 3 == 2)
                Positioned(
                  right: 20,
                  top: 10,
                  child: _buildPregnancyIcon(month),
                )
              else
                Positioned(
                  right: 20,
                  bottom: 10,
                  child: _buildPregnancyIcon(month),
                ),
              Center(
                child: Text(
                  'Month $month',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  static Widget _buildPregnancyIcon(int month) {
    // Different icons for different trimesters
    IconData icon;
    double size = 40;
    
    if (month <= 3) {
      icon = Icons.pregnant_woman;
      size = 30;
    } else if (month <= 6) {
      icon = Icons.child_friendly;
      size = 35;
    } else {
      icon = Icons.baby_changing_station;
      size = 40;
    }
    
    return Icon(
      icon,
      size: size,
      color: Colors.white.withOpacity(0.7),
    );
  }
  
  static List<Color> _getColorsForMonth(int month) {
    switch (month) {
      case 1:
        return [Colors.pink.shade200, Colors.pink.shade100];
      case 2:
        return [Colors.purple.shade200, Colors.purple.shade100];
      case 3:
        return [Colors.indigo.shade200, Colors.indigo.shade100];
      case 4:
        return [Colors.blue.shade200, Colors.blue.shade100];
      case 5:
        return [Colors.cyan.shade200, Colors.cyan.shade100];
      case 6:
        return [Colors.teal.shade200, Colors.teal.shade100];
      case 7:
        return [Colors.green.shade200, Colors.green.shade100];
      case 8:
        return [Colors.amber.shade200, Colors.amber.shade100];
      case 9:
        return [Colors.orange.shade200, Colors.orange.shade100];
      default:
        return [Colors.grey.shade200, Colors.grey.shade100];
    }
  }
} 