import 'package:get/get.dart';
import 'package:flutter/services.dart';

class PdfSaveController extends GetxController {
  late Uint8List capturedImageProblem;
  late Uint8List capturedImageAnswer;

  RxDouble difficultySliderValue = 0.0.obs;

  void getImage(Uint8List image1, Uint8List image2) {
    capturedImageProblem = image1;
    capturedImageAnswer = image2;
  }
}
