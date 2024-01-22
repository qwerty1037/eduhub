import 'dart:convert';
import 'package:front_end/Component/Class/frame.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Controller/tag_controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:front_end/Component/Class/tag_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:korea_regexp/korea_regexp.dart';
import 'package:http/http.dart' as http;

/// Pdf 저장 스크린을 컨트롤하는 Controller
class DBEditScreenController extends GetxController {
  late List<int> pdfFile;
  late List<Frame> frameList;
  RxList<TagModel> tagsList = <TagModel>[].obs;
  RxBool isImagePreviewButtonTapped = false.obs;
  RxDouble difficultySliderValue = 0.0.obs;
  RxString tagTextFieldValue = "".obs;
  TextEditingController problemNameController = TextEditingController();

  RxBool isEdit = false.obs;

  @override
  DBEditScreenController() {
    final tagController = Get.find<TagController>();
    for (int i = 0; i < tagController.totalTagList.length; i++) {
      tagsList.add(TagModel(tagController.totalTagList[i].name, tagController.totalTagList[i].id!, false));
    }
  }

  bool validCheck(int selectedDirectoryID) {
    bool valid = true;
    if (problemNameController.text.trim().isEmpty) {
      valid = false;
    }
    if (selectedDirectoryID == 99999999999) {
      valid = false;
    }
    return valid;
  }

  /// Send information of problem to backend
  ///
  /// 백엔드에 문제 정보를 보내는 메서드
  Future<int> sendProblemInfo(int problemId, String problemName) async {
    List<int> pdfBytes = pdfFile;

    // final url = Uri.parse('https://xloeuur.request.dreamhack.games');
    final url = Uri.parse('https://$HOST/api/data/problem/edit_problem');
    final Map<String, dynamic> requestBody = {
      "id": problemId,
      "name": problemName,
      "level": difficultySliderValue.value.round(),
    };

    final response = await http.post(
      url,
      headers: await defaultHeader(httpContentType.json),
      body: jsonEncode(requestBody),
    );
    debugPrint("${response.statusCode}");
    return response.statusCode;
  }

  void getPdfRectList(List<int> pdfFile, List<Frame> frameList) {
    this.pdfFile = pdfFile;
    this.frameList = frameList;
  }

  /// 선택된 칩 리스트 반환
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

  /// 검색한 텍스트에 맞춘 칩 리스트 반환
  List<Widget> filterChipsList() {
    List<Widget> chips = [];
    if (tagTextFieldValue.value == "") return chips;
    RegExp regExp = getRegExp(
      tagTextFieldValue.value, // != "" ? tagTextFieldValue.value : " ",
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
      if (tagTextFieldValue.value == "") {
        break;
      }
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
