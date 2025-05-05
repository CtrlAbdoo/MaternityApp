import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maternity_app/presentation/Questions/q2.dart';
import 'package:maternity_app/presentation/forgot_password/forgot_password_view.dart';
import 'package:maternity_app/presentation/forgot_password/reset_password_view.dart';
import 'package:maternity_app/presentation/home/navi_bar.dart';
import 'package:maternity_app/presentation/login/login_view.dart';
import 'package:maternity_app/presentation/register/register_view.dart';
import 'package:maternity_app/presentation/screens/children_newborns/children_newborns_screen.dart';
import 'package:maternity_app/presentation/splash/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String resetPasswordRoute = "/ResetPassword";
  static const String naviBar = "/NaviBar";
  static const String q1 = "/Q1";
  static const String childrenNewborns = "/children-newborns";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashView());
       case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginView());
       case Routes.registerRoute:
         return MaterialPageRoute(builder: (_) => RegisterView());
       case Routes.forgotPasswordRoute:
         return MaterialPageRoute(builder: (_) =>  ForgotPasswordView());
      case Routes.resetPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView());
      case Routes.naviBar:
        return MaterialPageRoute(builder: (context) => CustomNavigationBar(),);
      case Routes.q1:
        return MaterialPageRoute(builder: (_) =>  Q2());
      case Routes.childrenNewborns:
        return MaterialPageRoute(builder: (_) => const ChildrenNewbornsScreen());
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
