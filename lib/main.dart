import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      home: HomeScreen(),
    );
  }
}


//temp