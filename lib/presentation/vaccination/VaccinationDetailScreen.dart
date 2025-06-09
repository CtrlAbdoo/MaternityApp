import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';

class VaccinationDetailScreen extends StatelessWidget {
  final String name;
  final String date;
  final String age;
  final String status;
  final String description;
  final String howToGive;
  final String sideEffects;
  final String availability;
  final String doseSize;

  const VaccinationDetailScreen({
    required this.name,
    required this.date,
    required this.age,
    required this.status,
    required this.description,
    required this.howToGive,
    required this.sideEffects,
    required this.availability,
    required this.doseSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isCompulsory = status.toLowerCase() == 'compulsory';

    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) => const CustomAppBarWithBackArrow(),
              ),
              const SizedBox(height: 10),
              Text(
                'Vaccination Information',
                style: GoogleFonts.inriaSerif(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: MediaQuery.of(context).size.height > 500
                    ? 500
                    : MediaQuery.of(context).size.height * 0.85,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDBF3FE), Color(0xFFF8D4F6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with Checkbox
                      Row(
                        children: [

                          Expanded(
                            child: Text(
                              name,
                              style: GoogleFonts.inriaSerif(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
      
                      // Date and Age
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Vaccination appointment\n$date',
                              style: GoogleFonts.inriaSerif(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'the age :\n$age',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.inriaSerif(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 8),
      
                      // Badge
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompulsory ? Colors.red : Colors.purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.inriaSerif(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
      
                      const SizedBox(height: 16),
      
                      // Sections
                      Text('How to give', style: boldTitleStyle()),
                      Text(howToGive, style: bodyTextStyle()),
      
                      const SizedBox(height: 12),
      
                      Text('Dose size', style: boldTitleStyle()),
                      Text(doseSize, style: bodyTextStyle()), 
      
                      const SizedBox(height: 12),
      
                      Text('Prevention', style: boldTitleStyle()),
                      Text(description, style: bodyTextStyle()),
      
                      const SizedBox(height: 12),
      
                      Text('Side effects', style: boldTitleStyle()),
                      Text(sideEffects, style: bodyTextStyle()),
      
                      const SizedBox(height: 12),
      
                      Text('Availability locations', style: boldTitleStyle()),
                      Text(availability, style: bodyTextStyle()),
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

  TextStyle boldTitleStyle() {
    return GoogleFonts.inriaSerif(fontSize: 14, fontWeight: FontWeight.bold);
  }

  TextStyle bodyTextStyle() {
    return GoogleFonts.inriaSerif(fontSize: 14, color: Colors.black54);
  }
}
