import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomButton.dart';
import 'package:maternity_app/presentation/common/CustomDropdown.dart';
import 'package:maternity_app/presentation/drug_registration/water_drinking_screen.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class DrugRegistrationScreen extends StatefulWidget {
  @override
  _DrugRegistrationScreenState createState() => _DrugRegistrationScreenState();
}

class _DrugRegistrationScreenState extends State<DrugRegistrationScreen> {
  String? selectedPotion;
  String? selectedRepetition;
  String? selectedRecipient;
  List<TimeOfDay> selectedTimes = [TimeOfDay(hour: 4, minute: 30)]; // Start with one default time

  Future<void> _selectTime(BuildContext context, int? index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (index != null) {
          selectedTimes[index] = picked; // Update existing time
        } else {
          selectedTimes.add(picked); // Add new time to the list
        }
      });
    }
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Section
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.3,
                ),
              ),

              // Title Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Drug registration:",
                    style: GoogleFonts.inriaSerif(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF0C4993),
                    ),
                  ),
                  Image.asset(
                    'assets/images/drug.png',
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.25,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Medicine Name Field
              Text("Name of the medicine", style: GoogleFonts.inriaSerif(fontSize: screenWidth * 0.05)),
              _buildTextField("",  screenWidth * 0.8),
              SizedBox(height: screenHeight * 0.01),

              // Potion Dropdown
              Text("Potion", style: GoogleFonts.inriaSerif(fontSize: screenWidth * 0.05)),
              CustomDropdown(
                title: "Potion",
                options: ["1 tablet / 5 ml", "2 tablets / 10 ml"],
                onSelected: (value) => setState(() => selectedPotion = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Repetition Dropdown
              Text("Repetition", style: GoogleFonts.inriaSerif(fontSize: screenWidth * 0.05)),
              CustomDropdown(
                title: "Repetition",
                options: ["Once daily", "Twice daily"],
                onSelected: (value) => setState(() => selectedRepetition = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Set Time Picker Section
              Text("Set time", style: GoogleFonts.inriaSerif(fontSize: screenWidth * 0.05)),

              // Display all selected times
              Column(
                children: selectedTimes
                    .asMap()
                    .entries
                    .map((entry) => _buildTimePicker(context, entry.key, entry.value))
                    .toList(),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Add Another Time Button
              Center(
                child: CustomButton(
                  onPressed: () => _selectTime(context, null),
                  text: "Add another time",
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.05,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Recipient Dropdown
              Text("Is this medicine for you or your son?", style: GoogleFonts.inriaSerif(fontSize: screenWidth * 0.05)),
              CustomDropdown(
                title: "Add option",
                options: ["for my son", "for me"],
                onSelected: (value) => setState(() => selectedRecipient = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Instructions Field
              _buildTextField("With food \\ on an empty\nstomach", screenWidth * 0.6),
              SizedBox(height: screenHeight * 0.02),

              // Buttons Row
              SizedBox(
                width: screenWidth * 0.9, // Ensure Row has enough space
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.33, // Reduce width
                      child: CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Back",
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.53, // Reduce width
                      child: CustomButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WaterDrinkingScreen()));
                        },
                        text: "Save and continue",
                        backgroundColor: ColorManager.BG2_Gradient,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: width,
        child: TextField(
          maxLines: null,
          minLines: 1,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inriaSerif(fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          style: GoogleFonts.inriaSerif(fontSize: 16),
        ),
      ),
    );
  }


  Widget _buildTimePicker(BuildContext context, int index, TimeOfDay time) {
    return GestureDetector(
      onTap: () => _selectTime(context, index),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: ColorManager.BG_Gradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}",
              style: GoogleFonts.inriaSerif(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  selectedTimes.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
