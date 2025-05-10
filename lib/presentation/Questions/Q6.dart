import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/Questions/q8.dart';
import 'package:maternity_app/presentation/Questions/q7.dart';
import 'package:maternity_app/presentation/Questions/q3.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class Q6 extends StatefulWidget {
  const Q6({super.key});

  @override
  _Q6State createState() => _Q6State();
}

class _Q6State extends State<Q6> {
  bool _isVisibile = false;
  static var text = "";
  bool isYesSelected = false;
  bool isNoSelected = false;
  int selectedYear = DateTime.now().year;
  int selectedMonth = 1;
  int selectedDay = 1;

  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  @override
  void initState() {
    super.initState();
    // Initialize month controller to middle position aligned with selectedMonth
    int initialMonthIndex = (10000 ~/ 2) - (10000 ~/ 2 % 12) + (selectedMonth - 1);
    _monthController = FixedExtentScrollController(initialItem: initialMonthIndex);

    // Initialize day controller to middle position aligned with selectedDay
    int initialDayIndex = (10000 ~/ 2) - (10000 ~/ 2 % 31) + (selectedDay - 1);
    _dayController = FixedExtentScrollController(initialItem: initialDayIndex);

    // Initialize year controller to middle position aligned with selectedYear
    int initialYearIndex = (10000 ~/ 2) - (10000 ~/ 2 % 100) + (DateTime.now().year - selectedYear);
    _yearController = FixedExtentScrollController(initialItem: initialYearIndex);
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog() {
    final selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: ColorManager.BG1_Gradient,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                'Child history',
                style: GoogleFonts.inriaSerif(
                  fontSize: 24,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                '${_getDayOfWeek(selectedDate)} ${selectedDate.day} - ${_getMonthName(selectedDate.month)}',
                style: GoogleFonts.inriaSerif(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Q7(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x35FFFFFF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    ),
                    child: Text(
                      "Sure",
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x35FFFFFF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    ),
                    child: Text(
                      "Change",
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDayOfWeek(DateTime date) {
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][date.weekday - 1];
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD6E7), Color(0xFFB5E4F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                // Top Image
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.03),
                  height: screenHeight * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/MAE 1.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Question Title
                Text(
                  "In which month of pregnancy are you now?",
                  style: GoogleFonts.inriaSerif(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Yes/No Buttons
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isVisibile = true;
                            isYesSelected = true;
                            isNoSelected = false;
                            text = "Enter the pregnancy start date\ndetermined by your doctor.";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF965391)
                              .withOpacity(isYesSelected ? 1.0 : 0.59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          minimumSize: Size(screenWidth * 0.87, screenHeight * 0.05), // Set width & height
                        ),
                        child: Text(
                          "Pregnancy start date",
                          style: GoogleFonts.inriaSerif(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isVisibile = true;
                            isYesSelected = false;
                            isNoSelected = true;
                            text = "Enter the date of the first day of\nyour last menstrual period.";
                          });
                        },
                        style: ElevatedButton.styleFrom(

                          backgroundColor: const Color(0xFF965391)
                              .withOpacity(isNoSelected ? 1.0 : 0.59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          minimumSize: Size(screenWidth * 0.87, screenHeight * 0.05), // Set width & height
                        ),
                        child: Text(
                          "Last menstrual period",
                          style: GoogleFonts.inriaSerif(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Date of Birth Picker
                Visibility(
                  visible: _isVisibile,
                  child: Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.02),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x8889DDF7), Color(0x88FC8CF4)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(-4, -4),
                          blurRadius: 8,
                          spreadRadius: -4,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          offset: const Offset(4, 4),
                          blurRadius: 8,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          text,
                          style: GoogleFonts.inriaSerif(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.013),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Months Picker
                            Expanded(
                              child: SizedBox(
                                height: screenHeight * 0.2,
                                child: ListWheelScrollView.useDelegate(
                                  controller: _monthController,
                                  itemExtent: 40,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      selectedMonth = (index % 12) + 1;
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      int monthIndex = index % 12;
                                      bool isSelected = selectedMonth == monthIndex + 1;
                                      return Center(
                                        child: Text(
                                          const [
                                            'Jan', 'Feb', 'Mar', 'Apr',
                                            'May', 'Jun', 'Jul', 'Aug',
                                            'Sep', 'Oct', 'Nov', 'Dec'
                                          ][monthIndex],
                                          style: GoogleFonts.inriaSerif(
                                            fontSize: isSelected ? 24 : 20,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.black : Colors.grey,

                                          ),
                                        ),
                                      );
                                    },
                                    childCount: 10000,
                                  ),
                                ),
                              ),
                            ),
                            // Days Picker
                            Expanded(
                              child: SizedBox(
                                height: screenHeight * 0.2,
                                child: ListWheelScrollView.useDelegate(
                                  controller: _dayController,
                                  itemExtent: 40,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      selectedDay = (index % 31) + 1;
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      int dayIndex = (index % 31) + 1;
                                      bool isSelected = selectedDay == dayIndex;
                                      return Center(
                                        child: Text(
                                          "$dayIndex",
                                          style: GoogleFonts.inriaSerif(
                                            fontSize: isSelected ? 24 : 20,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.black : Colors.grey,

                                          ),
                                        ),
                                      );
                                    },
                                    childCount: 10000,
                                  ),
                                ),
                              ),
                            ),
                            // Years Picker
                            Expanded(
                              child: SizedBox(
                                height: screenHeight * 0.2,
                                child: ListWheelScrollView.useDelegate(
                                  controller: _yearController,
                                  itemExtent: 40,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      selectedYear = DateTime.now().year - (index % 100);
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      int yearOffset = index % 100;
                                      int year = DateTime.now().year - yearOffset;
                                      bool isSelected = selectedYear == year;
                                      return Center(
                                        child: Text(
                                          "$year",
                                          style: GoogleFonts.inriaSerif(
                                            fontSize: isSelected ? 24 : 20,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.black : Colors.grey,

                                          ),
                                        ),
                                      );
                                    },
                                    childCount: 10000,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.03, bottom: screenHeight * 0.04),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x5087CEEB),
                                offset: Offset(6, 6),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ElevatedButton(
                            onPressed: _showConfirmationDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0x35FFFFFF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.011,
                                horizontal: screenWidth * 0.142,
                              ),
                            ),
                            child: Text(
                              "Start",
                              style: GoogleFonts.inriaSerif(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
