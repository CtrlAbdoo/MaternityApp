import 'package:flutter/material.dart';

class CustomAppBarWithBackArrow extends StatelessWidget {
  final VoidCallback? onBackPressed;
  
  const CustomAppBarWithBackArrow({
    super.key, 
    this.onBackPressed,
  });

  void _onBackTap(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
    } else {
      Navigator.of(context).pop();
    }
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
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
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
