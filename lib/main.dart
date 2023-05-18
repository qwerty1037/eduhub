import 'package:flutter/material.dart';
import 'package:front_end/Screen/screen_file_drag_and_drop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/Test/getX_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FileDragAndDropScreen(),
    );
  }
}


//temp