import 'dart:typed_data';
import 'package:front_end/Component/Default/Config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:front_end/Component/Tag_Model.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:korea_regexp/korea_regexp.dart';
import 'package:front_end/Test/Temp_Tag.dart';
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
    final url = Uri.parse('http://$HOST/api/data/create_problem');

    List<String> selectedTags = <String>[];
    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i].isSelected == true) {
        selectedTags.add(tagsList[i].label);
      }
    }
    String capturedFileNameProblem =
        '${problemNameController.text}_problem.jpeg';
    String capturedFileNameAnswer = '${problemNameController.text}_answer.jpeg';

    var request = http.MultipartRequest('POST', url);

    var multipartFileProblem = http.MultipartFile.fromBytes(
      'problem_image',
      capturedImageProblem,
      filename: capturedFileNameProblem,
      contentType:
          MediaType('image', 'jpeg'), // 이미지의 적절한 Content-Type을 설정해야 합니다.
    );

    var multipartFileAnswer = http.MultipartFile.fromBytes(
      'problem_image',
      capturedImageAnswer,
      filename: capturedFileNameAnswer,
      contentType:
          MediaType('image', 'jpeg'), // 이미지의 적절한 Content-Type을 설정해야 합니다.
    );

    final Map<String, dynamic> requestBody = {
      "problem_name": problemNameController.text,
      "parent_database": 1,
      //"directory": "\"{directorytext}\"",
      "tags": selectedTags
          .join(), //애초에 TAG class가 있고 거기에서 id만 List<LongLongInt>로 보내기
      "level": difficultySliderValue.round(),
      //"problem_image": [multipartFileProblem, multipartFileAnswer],
      "problem_string": capturedFileNameProblem,
      "answer_string": capturedFileNameAnswer,
    };
    final Map<String, String> temp = {};
    requestBody.forEach((key, value) {
      temp.addAll(Map.fromEntries([MapEntry(key, value.toString())]));
    });

    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(multipartFileProblem);
    request.files.add(multipartFileAnswer);

    request.fields.addAll(temp);

    final response = await request.send();
    print(response.statusCode);
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

  List<Widget> selectedChipsList() {
    List<Widget> chips = [];
    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i].isSelected == true) {
        Widget item = FilterChip(
          label: Text(tagsList[i].label),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
          backgroundColor: Colors.grey,
          selected: tagsList[i].isSelected,
          onSelected: (bool value) {
            tagsList[i].isSelected = false;
            tagsList.refresh();
          },
        );
        chips.add(item);
      }
    }
    return chips;
  }

  List<Widget> filterChipsList() {
    List<Widget> chips = [];
    if (tagsTextValue.value == "") {
      return [];
    } else {
      RegExp regExp = getRegExp(
        tagsTextValue.value,
        RegExpOptions(
          initialSearch: true,
          startsWith: false,
          endsWith: false,
          fuzzy: true,
          ignoreSpace: true,
          ignoreCase: true,
        ),
      );
      for (int i = 0; i < tagsList.length; i++) {
        if (regExp.hasMatch(tagsList[i].label)) {
          Widget item = FilterChip(
            label: Text(tagsList[i].label),
            labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
            backgroundColor: Colors.grey,
            selected: tagsList[i].isSelected,
            onSelected: (bool value) {
              tagsList[i].isSelected = value;
              tagsList.refresh();
            },
          );
          if (tagsList[i].isSelected == false) {
            chips.add(item);
          }
        }
      }
      return chips;
    }
  }
}
