import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:message_board/app_services/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Message Board',
      home: LoginPage(),
    );
  }
}