import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maternity_app/app/app.dart';
import 'package:maternity_app/core/di/injection_container.dart' as di;
import 'package:maternity_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}


