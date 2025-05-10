import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_1.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_2.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_3.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_4.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_5.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_6.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_7.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_8.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/months%20text/month_9.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class MonthDetailScreen extends StatelessWidget {
  final String monthTitle;
  final String imagePath;

  const MonthDetailScreen({
    super.key,
    required this.monthTitle,
    required this.imagePath,
  });

  Widget _getMonthWidget() {
    switch (monthTitle.toLowerCase()) {
      case 'the first month':
        return const Month1();
      case 'the second month':
        return const Month2();
      case 'the third month':
        return const Month3();
      case 'the fourth month':
        return const Month4();
      case 'the fifth month':
        return const Month5();
      case 'the sixth month':
        return const Month6();
      case 'the seventh month':
        return const Month7();
      case 'the eighth month':
        return const Month8();
      case 'the ninth month':
        return const Month9();
      default:
        return const Center(
          child: Text(
            'Content not available for this month.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar with Logo
            const CustomAppBarWithLogo(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              imagePath,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: -18,
                            left: MediaQuery.of(context).size.width * 0.5 - 155,
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
                                monthTitle,
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
                      const SizedBox(height: 30),

                      // Show the correct month content
                      _getMonthWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
