import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Breastfeeding/breast_feeding_natural_screen.dart';
import 'package:maternity_app/presentation/Breastfeeding/formula_feeding_artificial_screen.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class BreastFeedingScreen extends StatelessWidget {
  const BreastFeedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBarWithLogo(),

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
                      'Your breastfeeding journey',
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
                        // Text
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Congratulations on motherhood! Breastfeeding is not just a means of nutrition; it's also a means of love and connection between you and your baby. We're here to support you and walk with you on this journey, from the first moment until weaning.",
                            style: GoogleFonts.inriaSerif(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Image
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/breastfeeding_intro.png',
                              fit: BoxFit.cover,
                              height: 155,
                              width: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Problems and solutions title
                    Text(
                      'Here are some problems and solutions for breastfeeding',
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Breastfeeding (Natural) card
                    _buildOptionCard(
                      context,
                      title: 'Breastfeeding (Natural)',
                      imagePath: 'assets/images/breastfeeding_natural.png',
                    ),
                    const SizedBox(height: 20),

                    // Formula Feeding (Artificial) card
                    _buildOptionCard(
                      context,
                      title: 'Formula Feeding (Artificial)',
                      imagePath: 'assets/images/formula_feeding.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, {required String title, required String imagePath}) {
    return InkWell(
      onTap: () {
        // Navigate to the respective screen
        if (title == 'Breastfeeding (Natural)') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BreastfeedingNaturalScreen()));
        } else if (title == 'Formula Feeding (Artificial)') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FormulaFeedingArtificialScreen()));
        }
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
                        gradient: ColorManager.BG2_Gradient.withOpacity(0.8),
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
