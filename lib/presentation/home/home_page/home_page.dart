import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/DaysoftheWeek.dart';
import 'package:maternity_app/presentation/common/NutritionStack.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/baby_bg4.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) => CustomAppBar(),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x42FFFFFF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Feb 25, 2024',
                  style: GoogleFonts.inriaSerif(
                    textStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '34 Weeks & 6 days',
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'My Baby Like',
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0C4993),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'A Cantaloupe',
                    style: GoogleFonts.inriaSerif(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C4993),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/cantaloupe.png',
                    height: 31,
                    width: 40,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              DaysoftheWeek(),
              const SizedBox(height: 7),
              Text(
                'Advice for you, mom',
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      NutritionStack(
                        imagePath: 'assets/images/healthy_food.png',
                        text: 'Healthy nutrition',
                      ),
                      SizedBox(height: 20),
                      NutritionStack(
                        imagePath: 'assets/images/physical_activity.png',
                        text: 'Physical activity',
                      ),
                      SizedBox(height: 20),
                      NutritionStack(
                        imagePath: 'assets/images/rest_and_sleep.png',
                        text: 'Rest and sleep',
                      ),
                      SizedBox(height: 20),
                      NutritionStack(
                        imagePath: 'assets/images/baby_care_tips.png',
                        text: 'Baby care tips',
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
}