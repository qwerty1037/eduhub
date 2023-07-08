import 'dart:convert';

import 'package:front_end/Component/TagModel.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../Test/TempTag.dart';
import 'package:http/http.dart' as http;

class PdfSaveController extends GetxController {
  late Uint8List capturedImageProblem;
  late Uint8List capturedImageAnswer;
  RxList<TagModel> tagsList = <TagModel>[].obs;
  RxBool isImagePreviewButtonTapped = false.obs;
  RxString tagsTextValue = "".obs;
  RxDouble difficultySliderValue = 0.0.obs;

  TextEditingController problemNameController = TextEditingController();
  TextEditingController directoryController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  @override
  PdfSaveController() {
    for (int i = 0; i < tags.length; i++) {
      tagsList.add(TagModel(tags[i], false));
    }
  }

  Future<int> sendRegisterInfo() async {
    List<String> selectedTags = <String>[];
    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i].isSelected == true) {
        selectedTags.add(tagsList[i].label);
      }
    }

    String HOST = "192.168.1.1";
    final url = Uri.parse('http://$HOST/api/auth/register');
    final Map<String, dynamic> requestBody = {
      "user_id": problemNameController.text,
      "directory": directoryController.text,
      "tags": selectedTags,
      "difficulty": difficultySliderValue,
      "problem_image": capturedImageProblem,
      "answer_image": capturedImageAnswer,
    };
    final headers = {"Content-type": "application/json"};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    return response.statusCode;
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
