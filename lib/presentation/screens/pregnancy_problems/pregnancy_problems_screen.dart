import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/core/utils/app_theme.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:maternity_app/presentation/screens/pregnancy_problems/month_problems_screen.dart';

class PregnancyProblemsScreen extends StatelessWidget {
  static const routeName = '/pregnancy-problems';

  const PregnancyProblemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pregnancyProblems = [
      {"title": "First month problems", "month": 1},
      {"title": "Second month problems", "month": 2},
      {"title": "Third month problems", "month": 3},
      {"title": "Fourth month problems", "month": 4},
      {"title": "Fifth month problems", "month": 5},
      {"title": "Sixth month problems", "month": 6},
      {"title": "Seventh month problems", "month": 7},
      {"title": "Problems of the eighth month", "month": 8},
      {"title": "Ninth month problems", "month": 9},
    ];

    return SafeArea(child:  Scaffold(
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) => const CustomAppBarWithLogo(),
            ),
            const SizedBox(height: 10),
            Text(
              'Pregnancy problems',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: pregnancyProblems.map((data) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MonthProblemsScreen(
                              month: data['month'],
                              title: data['title'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: _buildMonthImage(data['month']),
                              ),
                              Positioned(
                                bottom: -18,
                                left: MediaQuery.of(context).size.width * 0.5 - 155, // Centers it
                                child: Container(
                                  width: 278,
                                  height: 63,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: ColorManager.BG2_Gradient,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    data['title'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inriaSerif(
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 38), // Spacing between items
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildMonthImage(int month) {
    final String imagePath = 'assets/images/pregnancy/${_getMonthImageName(month)}.png';
    
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColorsForMonth(month),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Try to load the image
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // If image fails to load, show an icon
              return Center(
                child: _getIconForMonth(month),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getMonthImageName(int month) {
    switch (month) {
      case 1: return 'first_month';
      case 2: return 'second_month';
      case 3: return 'third_month';
      case 4: return 'fourth_month';
      case 5: return 'fifth_month';
      case 6: return 'sixth_month';
      case 7: return 'seventh_month';
      case 8: return 'eighth_month';
      case 9: return 'ninth_month';
      default: return 'placeholder';
    }
  }

  List<Color> _getGradientColorsForMonth(int month) {
    switch (month) {
      case 1:
        return [Colors.pink.shade100, Colors.pink.shade50];
      case 2:
        return [Colors.purple.shade100, Colors.purple.shade50];
      case 3:
        return [Colors.indigo.shade100, Colors.indigo.shade50];
      case 4:
        return [Colors.blue.shade100, Colors.blue.shade50];
      case 5:
        return [Colors.cyan.shade100, Colors.cyan.shade50];
      case 6:
        return [Colors.teal.shade100, Colors.teal.shade50];
      case 7:
        return [Colors.green.shade100, Colors.green.shade50];
      case 8:
        return [Colors.amber.shade100, Colors.amber.shade50];
      case 9:
        return [Colors.orange.shade100, Colors.orange.shade50];
      default:
        return [Colors.grey.shade100, Colors.grey.shade50];
    }
  }

  Widget _getIconForMonth(int month) {
    IconData icon;
    double size = 40;
    
    if (month <= 3) {
      icon = Icons.pregnant_woman;
    } else if (month <= 6) {
      icon = Icons.child_friendly;
    } else {
      icon = Icons.baby_changing_station;
    }
    
    return Icon(
      icon,
      size: size,
      color: Colors.white.withOpacity(0.7),
    );
  }
} 