import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomButton.dart';
import 'package:maternity_app/presentation/common/CustomDropdown.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class ExerciseLogScreen extends StatefulWidget {
  @override
  _ExerciseLogScreenState createState() => _ExerciseLogScreenState();
}

class _ExerciseLogScreenState extends State<ExerciseLogScreen> {
  String? selectedExerciseTime;
  String? selectedPregnancyExercise;
  String? selectedActivityLevel;
  String? selectedExerciseReminder;
  String? selectedSpecificExercises;
  final TextEditingController notesController = TextEditingController();

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

              // Logo and Title
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
                            "Exercise log :",
                            style: GoogleFonts.inriaSerif(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF0C4993),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/exercise_icon.png',
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Exercise Time
              Text(
                textAlign: TextAlign.center,
                "How much time can you devote to exercise daily?",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              CustomDropdown(
                title: "Add option",
                options: ["5 minutes", "10 minutes", "20 minutes or more"],
                onSelected: (value) => setState(() => selectedExerciseTime = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Pregnancy Exercise
              Text(
                textAlign: TextAlign.center,
                "Do you want to exercise during pregnancy and after childbirth?",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              CustomDropdown(
                title: "Add option",
                options: ["During pregnancy", "After pregnancy"],
                onSelected: (value) => setState(() => selectedPregnancyExercise = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Activity Level
              Text(
                textAlign: TextAlign.center,
                "What is your current activity level?",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              CustomDropdown(
                title: "Add option",
                options: ["Lazy", "Average activity", "Very active"],
                onSelected: (value) => setState(() => selectedActivityLevel = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Exercise Reminder
              Text(
                textAlign: TextAlign.center,
                "Would you like to receive notifications to remind you when to exercise?",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              CustomDropdown(
                title: "Add option",
                options: ["Yes", "No"],
                onSelected: (value) => setState(() => selectedExerciseReminder = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Specific Exercises
              Text(
                textAlign: TextAlign.center,
                "Do you need specific exercises to relieve back pain or strengthen the pelvis?",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              CustomDropdown(
                title: "Add option",
                options: ["Yes", "No"],
                onSelected: (value) => setState(() => selectedSpecificExercises = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Health Restrictions (Notes)
              Text(
                textAlign: TextAlign.center,
                "Do you have any health restrictions that prevent you from doing some exercises?",
                style: GoogleFonts.inriaSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                textAlign: TextAlign.center,
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "For notes",
                  hintStyle: GoogleFonts.inriaSerif(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                      // Save data and proceed
                    },
                    text: "Save and continue",
                    backgroundColor: ColorManager.BG2_Gradient,
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
