import 'package:flutter/material.dart';
import 'package:maternity_app/CurvedNavigationBar.dart';
import 'package:maternity_app/presentation/drug_registration/drug_registration_screen.dart';
import 'package:maternity_app/presentation/home/home_page/home_page.dart';
import 'package:maternity_app/presentation/home/pregnancy%20series%20screens/pregnancy_series_screen.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class CustomNavigationBar extends StatefulWidget {
  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    Center(child: Text('Add Page')),
    PregnancySeriesScreen(),
    HomePage(),
    Center(child: Text('Add Page')),
    Center(child: Text('Add Page')),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex], // Main content

          // Floating Action Button positioned higher
          Positioned(
            right: 12.5,
            bottom: 25, // Adjust this value to move it higher above the nav bar
            child: Container(
              width: 56, // Standard FAB size
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: ColorManager.BG3_Gradient,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4), // Soft shadow effect
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DrugRegistrationScreen()),
                    );
                  });
                },
                backgroundColor: Colors.transparent, // Make FAB itself transparent
                elevation: 0, // Prevents default FAB shadow from interfering
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.black, size: 32),
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 64,
        index: _selectedIndex,
        animationDuration: Duration(milliseconds: 300),
        items: [
          _buildNavItem('assets/images/search.png', 0),
          _buildNavItem('assets/images/add.png', 1),
          _buildNavItem('assets/images/home.png', 2, isCenter: true),
          _buildNavItem('assets/images/doctor.png', 3),
          _buildNavItem('assets/images/article.png', 4),
        ],
        onTap: _onTap,
      ),
    );
  }

  Widget _buildNavItem(String imagePath, int index, {bool isCenter = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: _selectedIndex == index
              ? BoxDecoration(
            shape: BoxShape.circle,
            gradient: ColorManager.BG_Gradient,
          )
              : null,
          child: Image.asset(
            imagePath,
            width: 30,
            height: 30,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
