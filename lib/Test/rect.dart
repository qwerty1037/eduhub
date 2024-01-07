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
