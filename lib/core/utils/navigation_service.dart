import 'package:flutter/material.dart';

/// A service that provides centralized navigation functionality.
/// This allows navigation from anywhere in the app without requiring a BuildContext.
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get navigator => navigatorKey.currentState;

  /// Navigate to a named route
  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigator!.pushNamed(routeName, arguments: arguments);
  }

  /// Replace the current route with a new named route
  static Future<dynamic> replaceTo(String routeName, {Object? arguments}) {
    return navigator!.pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Push a new route onto the navigator and remove all previous routes
  static Future<dynamic> navigateToNewRoot(String routeName, {Object? arguments}) {
    return navigator!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  /// Navigate back to the previous route
  static void goBack() {
    if (navigator!.canPop()) {
      navigator!.pop();
    }
  }

  /// Navigate back multiple steps
  static void goBackMultiple(int times) {
    int count = 0;
    while (count < times && navigator!.canPop()) {
      navigator!.pop();
      count++;
    }
  }

  /// Navigate back until a specific route
  static void goBackUntil(String routeName) {
    navigator!.popUntil(ModalRoute.withName(routeName));
  }
} 