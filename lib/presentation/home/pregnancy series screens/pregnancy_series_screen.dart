import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/month_detail_screen.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class PregnancySeriesScreen extends StatelessWidget {
  const PregnancySeriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> pregnancyMonths = [
      {"month": "The first month", "image": "assets/images/first_month.png"},
      {"month": "The second month", "image": "assets/images/second_month.png"},
      {"month": "The third month", "image": "assets/images/third_month.png"},
      {"month": "The fourth month", "image": "assets/images/fourth_month.png"},
      {"month": "The fifth month", "image": "assets/images/fifth_month.png"},
      {"month": "The sixth month", "image": "assets/images/sixth_month.png"},
      {"month": "The seventh month", "image": "assets/images/seventh_month.png"},
      {"month": "The eighth month", "image": "assets/images/eighth_month.png"},
      {"month": "The ninth month", "image": "assets/images/ninth_month.png"},
    ];

    return Scaffold(
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) => CustomAppBarWithLogo(),
            ),
            const SizedBox(height: 10),
            Text(
              'Weekly pregnancy series',
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
                  children: pregnancyMonths.map((data) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MonthDetailScreen(
                              monthTitle: data['month']!,
                              imagePath: data['image']!,
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
                                child: Image.asset(
                                  data['image']!,
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
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
                                    data['month']!,
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
                          const SizedBox(height: 38), // Adjust spacing between items
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
    );
  }
}
