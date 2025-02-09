import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maternity_app/presentation/Questions/q1.dart';
import 'package:maternity_app/presentation/forgot_password/forgot_password_view.dart';
import 'package:maternity_app/presentation/forgot_password/reset_password_view.dart';
import 'package:maternity_app/presentation/login/login_view.dart';
import 'package:maternity_app/presentation/register/register_view.dart';
import 'package:maternity_app/presentation/splash/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String ResetPasswordRoute = "/ResetPassword";
  static const String Q1 = "/Q1";

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
       case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginView());
       case Routes.registerRoute:
         return MaterialPageRoute(builder: (_) => RegisterView());
       case Routes.forgotPasswordRoute:
         return MaterialPageRoute(builder: (_) =>  ForgotPasswordView());
      case Routes.ResetPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView());
      case Routes.Q1:
        return MaterialPageRoute(builder: (_) =>  Q1());
      default:
        return unDefinedRoute();
    }
  }
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text(
                "No Route Found"), // todo move this string to strings manager
          ),
          body: const Center(
              child: Text(
                  "No Route Found")), // todo move this string to strings manager
        ));
  }
}
