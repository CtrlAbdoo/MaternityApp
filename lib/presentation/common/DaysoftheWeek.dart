import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaysoftheWeek extends StatefulWidget {
  const DaysoftheWeek({super.key});

  @override
  State<DaysoftheWeek> createState() => _DaysoftheWeekState();
}

class _DaysoftheWeekState extends State<DaysoftheWeek> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = DateTime.now().weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
          .asMap()
          .entries
          .map((entry) {
        final int index = entry.key;
        final String day = entry.value;
        final bool isSelected = index == _selectedIndex;

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            day,
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? const Color(0xFF0874F8)
                    : const Color(0xFF0874F8).withOpacity(0.89),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
