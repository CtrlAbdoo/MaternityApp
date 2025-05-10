
import 'package:flutter/material.dart';

/// This is a utility class to generate placeholder images
/// for the children and newborns screens.
/// 
/// In a real app, you would use actual images instead.
class ChildrenNewbornsImageCreator {
  static Future<void> createPlaceholderImages() async {
    // Create images for each topic
    final topics = [
      "Child Growth Stages",
      "Complementary Feeding",
      "Daily Baby Care",
      "Baby Health and Common Illnesses",
      "Sensory and Motor Skills Development"
    ];
    
    for (String topic in topics) {
      await _createTopicImage(topic);
    }
  }

  static Future<void> _createTopicImage(String topic) async {
    // Create a global key to identify the RepaintBoundary
    final key = GlobalKey();
    
    // Create a placeholder image with topic title
    final widget = RepaintBoundary(
      key: key,
      child: Container(
        width: 300,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getColorsForTopic(topic),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              if (topic.contains("Growth"))
                Positioned(
                  left: 20,
                  bottom: 10,
                  child: _buildTopicIcon(topic),
                )
              else if (topic.contains("Feeding"))
                Positioned(
                  right: 20,
                  top: 10,
                  child: _buildTopicIcon(topic),
                )
              else
                Positioned(
                  right: 20,
                  bottom: 10,
                  child: _buildTopicIcon(topic),
                ),
              Center(
                child: Text(
                  topic,
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
  
  static Widget _buildTopicIcon(String topic) {
    // Different icons for different topics
    IconData icon;
    double size = 40;
    
    if (topic.contains("Growth")) {
      icon = Icons.child_care;
      size = 40;
    } else if (topic.contains("Feeding")) {
      icon = Icons.restaurant;
      size = 35;
    } else if (topic.contains("Care")) {
      icon = Icons.baby_changing_station;
      size = 40;
    } else if (topic.contains("Health") || topic.contains("Illness")) {
      icon = Icons.healing;
      size = 35;
    } else if (topic.contains("Motor") || topic.contains("Sensory")) {
      icon = Icons.sports_gymnastics;
      size = 40;
    } else {
      icon = Icons.info_outline;
      size = 35;
    }
    
    return Icon(
      icon,
      size: size,
      color: Colors.white.withOpacity(0.7),
    );
  }
  
  static List<Color> _getColorsForTopic(String topic) {
    if (topic.contains("Growth")) {
      return [Colors.pink.shade200, Colors.pink.shade100];
    } else if (topic.contains("Feeding")) {
      return [Colors.purple.shade200, Colors.purple.shade100];
    } else if (topic.contains("Care")) {
      return [Colors.blue.shade200, Colors.blue.shade100];
    } else if (topic.contains("Health") || topic.contains("Illness")) {
      return [Colors.teal.shade200, Colors.teal.shade100];
    } else if (topic.contains("Motor") || topic.contains("Sensory")) {
      return [Colors.amber.shade200, Colors.amber.shade100];
    } else {
      return [Colors.grey.shade200, Colors.grey.shade100];
    }
  }
} 