import 'package:flutter/material.dart';

class CustomAppBarWithLogo extends StatelessWidget {
  const CustomAppBarWithLogo({super.key});

  void _onMenuTap(BuildContext context) {
    print("Menu icon tapped");
    Scaffold.of(context).openDrawer();
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
        // Left section: Menu, Search, and Notification Icons
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _onMenuTap(context),
                child: const Icon(Icons.menu, size: 28, color: Colors.black87),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _onSearchTap,
                child: const Icon(Icons.search, size: 28, color: Colors.black87),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _onNotificationTap,
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_active, size: 28, color: Colors.black87),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
