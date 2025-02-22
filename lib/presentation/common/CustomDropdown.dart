import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(String) onSelected;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          selectedOption = value;
        });
        widget.onSelected(value);
      },
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      itemBuilder: (BuildContext context) {
        return widget.options.map((String option) {
          return PopupMenuItem<String>(
            value: option,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                option,
                style: GoogleFonts.inriaSerif(fontSize: 18, color: Colors.black),
              ),
            ),
          );
        }).toList();
      },
      child: SizedBox(
        width: 230,
        height: 50,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  selectedOption ?? widget.title,
                  style: GoogleFonts.inriaSerif(fontSize: 18, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}