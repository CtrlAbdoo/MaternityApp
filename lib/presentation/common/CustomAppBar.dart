import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  void _onMenuTap(BuildContext context) {
    print("Menu icon tapped");
    // Open the drawer using Scaffold
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _onMenuTap(context), // Pass context to the handler
            child: const Icon(Icons.menu, size: 28, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          // GestureDetector(
          //   onTap: _onSearchTap,
          //   child: const Icon(Icons.search, size: 28, color: Colors.black87),
          // ),
          // const SizedBox(width: 10),
          // GestureDetector(
          //   onTap: _onNotificationTap,
          //   child: Stack(
          //     children: [
          //       const Icon(Icons.notifications_none_rounded, size: 28, color: Colors.black87),
          //       Positioned(
          //         right: 2,
          //         top: 2,
          //         child: Container(
          //           width: 8,
          //           height: 8,
          //           decoration: const BoxDecoration(
          //             color: Colors.red,
          //             shape: BoxShape.circle,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

        ],
      ),
    );
  }
}