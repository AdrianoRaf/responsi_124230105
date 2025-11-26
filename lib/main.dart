import 'package:flutter/material.dart';
import 'package:news/pages/LoginPage.dart';
import 'package:news/pages/RegisterPage.dart';
import 'pages/LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spaceflight News',
      home: RegisterPage(),
    );
  }
}
