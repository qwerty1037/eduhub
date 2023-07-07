import 'package:front_end/Component/TagModel.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../Test/TempTag.dart';

class PdfSaveController extends GetxController {
  late Uint8List capturedImageProblem;
  late Uint8List capturedImageAnswer;
  RxList<TagModel> tagsList = <TagModel>[].obs;
  RxBool isImagePreviewButtonTapped = false.obs;
  RxString tagsTextValue = "".obs;
  RxDouble difficultySliderValue = 0.0.obs;

  @override
  PdfSaveController() {
    for (int i = 0; i < tags.length; i++) {
      tagsList.add(TagModel(tags[i], false));
    }
  }

  /// Get Problem, Answer image as Uint8List
  void getImage(Uint8List image1, Uint8List image2) {
    capturedImageProblem = image1;
    capturedImageAnswer = image2;
  }

  /// When ImagePreviewButton is Tapped, It will switch "-보기", "-숨기기"
  String imagePreviewButtonText() {
    if (isImagePreviewButtonTapped.value == false) {
      return "-보기";
    } else {
      return "-숨기기";
    }
  }

  /// executed when ImagePreviewButton is Tapped
  ///
  /// change its tapped value
  void whenImagePreviewButtonTapped() {
    if (isImagePreviewButtonTapped.value == false) {
      isImagePreviewButtonTapped.value = true;
    } else {
      isImagePreviewButtonTapped.value = false;
    }
  }
}
