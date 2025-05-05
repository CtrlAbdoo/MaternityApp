import 'package:flutter/material.dart';
import 'package:maternity_app/core/di/injection_container.dart' as di;
import 'package:maternity_app/core/utils/app_theme.dart';
import 'package:maternity_app/core/utils/navigation_service.dart';
import 'package:maternity_app/presentation/resources/routes_manager.dart';
import 'package:maternity_app/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:maternity_app/presentation/viewmodels/medication/medication_viewmodel.dart';
import 'package:maternity_app/presentation/viewmodels/pregnancy/pregnancy_viewmodel.dart';
import 'package:maternity_app/presentation/viewmodels/user/user_viewmodel.dart';
import 'package:provider/provider.dart';

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthViewModel>()..init()),
        ChangeNotifierProvider(create: (_) => di.sl<UserViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<PregnancyViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<MedicationViewModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maternity App',
        theme: AppTheme.lightTheme,
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.naviBar,
      ),
    );
  }
}
