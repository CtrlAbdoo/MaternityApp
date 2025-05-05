import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/MotherHealth/general_womens_health_screen.dart';
import 'package:maternity_app/presentation/MotherHealth/womens_health_after_childbirth_screen.dart';
import 'package:maternity_app/presentation/MotherHealth/womens_health_before_pregnancy_screen.dart';
import 'package:maternity_app/presentation/MotherHealth/womens_health_during_pregnancy_screen.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class MothersHealthScreen extends StatelessWidget {
  const MothersHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
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
                      'Mothers Health',
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
                      'Your Health, Your Power',
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
                            "Mama, your health is the foundation of your life – and your family's too. Care for yourself through pregnancy, childbirth, and beyond. We're here to guide you every step with simple tips and trusted advice.",
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
                      'Explore key stages of Women\'s Health',
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
                    _buildOptionCard(
                      context,
                      title: 'General Women\'s Health',
                      imagePath: 'assets/images/general_health.png',
                    ),
                    const SizedBox(height: 20),

                    _buildOptionCard(
                      context,
                      title: 'Women\'s Health Before Pregnancy',
                      imagePath: 'assets/images/before_pregnancy.png',
                    ),
                    const SizedBox(height: 20),

                    _buildOptionCard(
                      context,
                      title: 'Women\'s Health During Pregnancy',
                      imagePath: 'assets/images/during_pregnancy.png',
                    ),
                    const SizedBox(height: 20),

                    _buildOptionCard(
                      context,
                      title: 'Women\'s Health After Childbirth',
                      imagePath: 'assets/images/after_childbirth.png',
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
        // Navigate based on title
        if (title == 'General Women\'s Health') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneralWomensHealthScreen()));
        } else if (title == 'Women\'s Health Before Pregnancy') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const WomensHealthBeforePregnancyScreen()));
        } else if (title == 'Women\'s Health During Pregnancy') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const WomensHealthDuringPregnancyScreen()));
        } else if (title == 'Women\'s Health After Childbirth') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const WomensHealthAfterChildbirthScreen()));
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
