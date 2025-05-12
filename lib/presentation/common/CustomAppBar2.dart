import 'package:flutter/material.dart';

class CustomAppBarWithBackArrow extends StatelessWidget {
  const CustomAppBarWithBackArrow({super.key});

  void _onBackTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onSearchTap() {
    print("Search icon tapped");
  }

  void _onNotificationTap() {
    print("Notification icon tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Left section: Back Arrow
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _onBackTap(context),
                  child: const Icon(Icons.arrow_back_ios, size: 24, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),

        Center(
          child: Image.asset(
            'assets/images/logo3.png',
            height: 55,
          ),
        ),
      ],
    );
  }
}
