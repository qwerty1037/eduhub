import 'package:get/get.dart';
import 'package:flutter/services.dart';

class PdfSaveController extends GetxController {
  late Uint8List capturedImageProblem;
  late Uint8List capturedImageAnswer;

  RxBool isImagePreviewButtonTapped = false.obs;

  RxDouble difficultySliderValue = 0.0.obs;

  void getImage(Uint8List image1, Uint8List image2) {
    capturedImageProblem = image1;
    capturedImageAnswer = image2;
  }

  String imagePreviewButtonText() {
    if (isImagePreviewButtonTapped.value == false) {
      return "-보기";
    } else {
      return "-숨기기";
    }
  }

  void imagePreviewButtonTapped() {
    if (isImagePreviewButtonTapped.value == false) {
      isImagePreviewButtonTapped.value = true;
    } else {
      isImagePreviewButtonTapped.value = false;
    }
  }
}
