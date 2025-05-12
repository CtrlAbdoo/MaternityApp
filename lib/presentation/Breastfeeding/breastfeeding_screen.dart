import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Breastfeeding/breastfeeding_details_screen.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class BreastfeedingScreen extends StatelessWidget {
  const BreastfeedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        "title": "Breastfeeding (Natural)",
        "icon": Icons.favorite,
        "color": Colors.pink,
        "image": "assets/images/breastfeeding.png",
        "description": "Learn about the benefits and techniques of breastfeeding."
      },
      {
        "title": "Formula Feeding (Artificial)",
        "icon": Icons.local_drink,
        "color": Colors.blue,
        "image": "assets/images/formula_feeding.png",
        "description": "Understanding formula feeding options and guidelines."
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
                      'Breastfeeding',
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      'Nourishing Your Baby',
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Description with image
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Whether you choose to breastfeed or use formula, we're here to support you in providing the best nutrition for your baby. Learn about different feeding methods, techniques, and tips to ensure your baby's healthy growth and development.",
                            style: GoogleFonts.inriaSerif(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 20),

                    // Sections Title
                    Text(
                      'Explore Feeding Options',
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section Cards
                    ...topics.map((topic) => Column(
                      children: [
                        _buildOptionCard(
                          context, 
                          title: topic['title'],
                          imagePath: topic['image'],
                          category: "Breastfeeding",
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
            builder: (context) => BreastfeedingDetailsScreen(
              title: title,
              category: category,
            ),
          ),
        );
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(5), // Gradient border thickness
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
                    padding: const EdgeInsets.only(bottom: 7),
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