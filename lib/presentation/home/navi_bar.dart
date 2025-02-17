import 'package:flutter/material.dart';
import 'package:maternity_app/CurvedNavigationBar.dart';
import 'package:maternity_app/presentation/home/home_page/home_page.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class CustomNavigationBar extends StatefulWidget {
  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    Center(child: Text('Home Page')),
    Center(child: Text('Search Page')),
    HomePage(),
    Center(child: Text('Add Page')),
    Center(child: Text('Articles Page')),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.white,
        buttonBackgroundColor: Colors.transparent,
        height: 70, // Increased height to accommodate text
        index: _selectedIndex,
        animationDuration: Duration(milliseconds: 300),
        items: [
          _buildNavItem('assets/images/search.png',  0),
          _buildNavItem('assets/images/add.png',  1),
          _buildNavItem('assets/images/home.png',  2, isCenter: true),
          _buildNavItem('assets/images/doctor.png',  3),
          _buildNavItem('assets/images/article.png',  4),
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
          width: 50, // Standardized width for all icons
          height: 50, // Standardized height for all icons
          decoration: _selectedIndex == index
              ? BoxDecoration(
            shape: BoxShape.circle,
            gradient: ColorManager.BG_Gradient,
          )
              : null,
          child: Image.asset(
            imagePath,
            width: 30, // Standardized width for the image
            height: 30, // Standardized height for the image
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}