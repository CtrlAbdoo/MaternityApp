import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maternity_app/app/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


