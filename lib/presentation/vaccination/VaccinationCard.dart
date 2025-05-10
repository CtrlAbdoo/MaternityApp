import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:maternity_app/presentation/vaccination/VaccinationDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VaccinationCard extends StatefulWidget {
  final String date;
  final String age;
  final String name;
  final String description;
  final String status;
  final String howToGive;
  final String sideEffects;
  final String availability;
  final String doseSize;

  const VaccinationCard({
    required this.date,
    required this.age,
    required this.name,
    required this.description,
    required this.status,
    required this.howToGive,
    required this.sideEffects,
    required this.availability,
    required this.doseSize,
    super.key,
  });

  @override
  State<VaccinationCard> createState() => _VaccinationCardState();
}

class _VaccinationCardState extends State<VaccinationCard> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();
  }

  // Load the checkbox state from SharedPreferences
  Future<void> _loadCheckboxState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isChecked = prefs.getBool('checkbox_${widget.name}') ?? false;
    });
  }

  // Save the checkbox state to SharedPreferences
  Future<void> _saveCheckboxState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkbox_${widget.name}', value);
  }


  @override
  Widget build(BuildContext context) {
    final bool isCompulsory = widget.status.toLowerCase() == 'compulsory';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VaccinationDetailScreen(
              name: widget.name,
              date: widget.date,
              age: widget.age,
              description: widget.description,
              status: widget.status,
              howToGive: widget.howToGive,
              doseSize: widget.doseSize,
              sideEffects: widget.sideEffects,
              availability: widget.availability,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: ColorManager.BG4_Gradient,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  const Icon(Icons.brightness_1, color: Color(0xFFDE1313), size: 10),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Text(
                            'Vaccination appointment',
                            style: GoogleFonts.inriaSerif(
                              fontSize: 12,
                              color: const Color(0x50000000),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.date,
                            style: GoogleFonts.inriaSerif(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      'the age: ${widget.age}',
                      style: GoogleFonts.inriaSerif(
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),


              // Name + Checkbox + Badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.name,
                      style: GoogleFonts.inriaSerif(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),


                  Checkbox(
                    value: isChecked,
                    onChanged: (val) {
                      setState(() {
                        isChecked = val ?? false;
                        _saveCheckboxState(isChecked);
                      });
                    },
                    side: const BorderSide(color: Colors.black),
                  ),

                  // Compulsory Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCompulsory ? const Color(0xFFB90C0C) : Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.status.toLowerCase(),
                      style: GoogleFonts.inriaSerif(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),



              // Description
              Text(
                widget.description,
                style: GoogleFonts.inriaSerif(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}