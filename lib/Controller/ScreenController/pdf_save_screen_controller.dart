import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:front_end/Component/Class/frame.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Controller/tag_controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:front_end/Component/Class/tag_model.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:korea_regexp/korea_regexp.dart';
import 'package:http/http.dart' as http;

/// Pdf 저장 스크린을 컨트롤하는 Controller
class PdfSaveController extends GetxController {
  late List<int> pdfFile;
  late List<Frame> frameList;
  RxList<TagModel> tagsList = <TagModel>[].obs;

  RxString tagTextFieldValue = "".obs;
  TextEditingController problemNameController = TextEditingController();

  @override
  PdfSaveController() {
    final tagController = Get.find<TagController>();
    for (int i = 0; i < tagController.totalTagList.length; i++) {
      tagsList.add(TagModel(tagController.totalTagList[i].name,
          tagController.totalTagList[i].id!, false));
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
  Future<int> sendProblemInfo(int selectedDirectoryID) async {
    List<int> selectedTags = <int>[];
    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i].isSelected == true) {
        selectedTags.add(tagsList[i].ID);
      }
    }
    List<int> pdfBytes = pdfFile;

    // final url = Uri.parse('https://xloeuur.request.dreamhack.games');
    final url = Uri.parse('https://$HOST/api/data/split_pdf');
    var request = http.MultipartRequest('POST', url);
    var multipartFileProblem = http.MultipartFile.fromBytes(
      'source_document',
      pdfBytes,
      filename: 'file',
      contentType: MediaType('application', 'pdf'), // pdf의 MIME타입
    );

    var temp = [];
    for (int i = 0; i < frameList.length; i++) {
      final Map<String, dynamic> tmp = {
        "page": frameList[i].page,
        "minX": double.parse(frameList[i].minX.toStringAsFixed(8)),
        "minY": 1.0 - double.parse(frameList[i].minY.toStringAsFixed(8)),
        "maxX": double.parse(frameList[i].maxX.toStringAsFixed(8)),
        "maxY": 1.0 - double.parse(frameList[i].maxY.toStringAsFixed(8)),
      };
      temp.add(tmp);
    }

    final Map<String, String> requestField = {
      "frame_list": jsonEncode(temp),
      "parent_database_id": jsonEncode(selectedDirectoryID),
      "tag_id_list": jsonEncode(selectedTags),
      "problem_name": problemNameController.text,
    };

    request.files.add(multipartFileProblem);
    request.fields.addAll(requestField);

    debugPrint("http Ready");
    request.headers.addAll(await defaultHeader(httpContentType.multipart));
    final response = await request.send();
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
