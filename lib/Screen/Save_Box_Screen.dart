import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';

class Rectangle {
  Rectangle({required this.lowerLeftX, required this.lowerLeftY, required this.upperRightX, required this.upperRightY}) {
    width = upperRightX - lowerLeftX;
    height = upperRightY - lowerLeftY;
    if (width <= 0 && height <= 0) {
      valid = false;
    } else {
      valid = true;
    }
  }
  double lowerLeftX;
  double lowerLeftY;
  double upperRightX;
  double upperRightY;

  late double width;
  late double height;
  late bool valid;

  double getLowerLeftX() => lowerLeftX;
  double getLowerLeftY() => lowerLeftY;
  double getUpperRightX() => upperRightX;
  double getUpperRightY() => upperRightY;
}

class SaveBoxScreen extends StatelessWidget {
  TransformationController ctrl = TransformationController();

  SaveBoxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(8.0),
      transformationController: ctrl,
      minScale: 0.5,
      maxScale: 3.0,
      child: Image.file(
        File("assets/gpt api 자료 조사.pdf"),
      ),
    );
  }
}
