import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/core/utils/app_theme.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:maternity_app/presentation/screens/children_newborns/topic_details_screen.dart';

class ChildrenNewbornsScreen extends StatelessWidget {
  static const routeName = '/children-newborns';

  const ChildrenNewbornsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        "title": "Child Growth Stages",
        "icon": Icons.child_care,
        "color": Colors.pink,
        "image": "assets/images/ChildGrowthStages.png",
        "description": "Learn about normal growth and developmental milestones from birth through early childhood."
      },
      {
        "title": "Complementary Feeding (Introducing Solid Foods)",
        "icon": Icons.restaurant,
        "color": Colors.purple,
        "image": "assets/images/Complementary.png",
        "description": "Guidelines for introducing solid foods, nutritional needs, and feeding practices for infants."
      },
      {
        "title": "Daily Baby Care",
        "icon": Icons.baby_changing_station,
        "color": Colors.blue,
        "image": "assets/images/BabyCare.png", 
        "description": "Essential routines for bathing, diapering, skin care, and establishing healthy sleep patterns."
      },
      {
        "title": "Baby Health and Common Illnesses",
        "icon": Icons.healing,
        "color": Colors.teal,
        "image": "assets/images/BabyHealth.png",
        "description": "Recognizing and managing common childhood illnesses, vaccination schedules, and when to call the doctor."
      },
      {
        "title": "Sensory and Motor Skills Development",
        "icon": Icons.sports_gymnastics,
        "color": Colors.amber,
        "image": "assets/images/Sensory.png",
        "description": "Activities and milestones for developing fine and gross motor skills, and sensory capabilities."
      },
    ];

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBarWithBackArrow(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Children and Newborns',
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
           
                    
                    
                    // Section Cards
                    ...topics.map((topic) => Column(
                      children: [
                        _buildOptionCard(
                          context, 
                          title: topic['title'],
                          imagePath: topic['image'],
                          category: "Children and newborns",
                        ),
                        const SizedBox(height: 20),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    required String category,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicDetailsScreen(
              title: title,
              category: category,
            ),
          ),
        );
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(5), // Slightly thicker border
          decoration: BoxDecoration(
            gradient: ColorManager.BG3_Gradient,
            borderRadius: BorderRadius.circular(53),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: ColorManager.BG2_Gradient,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey.withOpacity(0.5),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorManager.BG2_Gradient.colors[0].withOpacity(0.8),
                            ColorManager.BG2_Gradient.colors[1].withOpacity(0.8),
                          ],
                          begin: ColorManager.BG2_Gradient.begin,
                          end: ColorManager.BG2_Gradient.end,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 7, left: 10, right: 10),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 