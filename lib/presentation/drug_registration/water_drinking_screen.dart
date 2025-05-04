import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomButton.dart';
import 'package:maternity_app/presentation/common/CustomDropdown.dart';
import 'package:maternity_app/presentation/drug_registration/exercise_logScreen.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class WaterDrinkingScreen extends StatefulWidget {
  @override
  _WaterDrinkingScreenState createState() => _WaterDrinkingScreenState();
}

class _WaterDrinkingScreenState extends State<WaterDrinkingScreen> {
  String? selectedDailyIntake;
  String? selectedGoal;
  String? selectedReminder;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Logo
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: screenHeight * 0.08,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Water drinking record :",
                            style: GoogleFonts.inriaSerif(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF0C4993),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/water_drop.png',
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Daily Intake
              Text(
                textAlign: TextAlign.center,
                "How much water do you usually drink daily",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              CustomDropdown(
                title: "Add option",
                options: ["Less than 1 liter", "Between 1 - 2 liters", "More than 2 liters"],
                onSelected: (value) => setState(() => selectedDailyIntake = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Water Goal
              Text(
                textAlign: TextAlign.center,
                "What is the limit you want to reach daily",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              CustomDropdown(
                title: "Add option",
                options: ["1.5 liters", "2 liters", "3 liters"],
                onSelected: (value) => setState(() => selectedGoal = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Reminder Notifications
              Text(
                textAlign: TextAlign.center,
                "Would you like to receive water reminder notifications?",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              CustomDropdown(
                title: "Add option",
                options: ["Every hour", "Every two hours", "Without notifications"],
                onSelected: (value) => setState(() => selectedReminder = value),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "Back",
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.05,
                  ),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ExerciseLogScreen()));
                    },
                    text: "Save and continue",
                    backgroundColor: ColorManager.BG2_Gradient, // Adjust as needed
                    textColor: Colors.black,
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.05,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
