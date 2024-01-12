import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Component/frame.dart';

import 'package:front_end/Controller/Tag_Controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:front_end/Component/Class/tag_model.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:korea_regexp/korea_regexp.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Pdf 저장 스크린을 컨트롤하는 Controller
class PdfSaveController extends GetxController {
  late Uint8List capturedImageProblem;
  late Uint8List capturedImageAnswer;
  var capturedImageProblemPdf;
  var capturedImageAnswerPdf;
  late File pdfFile;
  late List<Frame> frameList;

  RxList<TagModel> tagsList = <TagModel>[].obs;
  RxBool isImagePreviewButtonTapped = false.obs;
  RxDouble difficultySliderValue = 0.0.obs;
  RxString tagTextFieldValue = "".obs;
  TextEditingController problemNameController = TextEditingController();

  @override
  PdfSaveController() {
    final tagController = Get.find<TagController>();
    for (int i = 0; i < tagController.totalTagList.length; i++) {
      tagsList.add(TagModel(tagController.totalTagList[i].name, tagController.totalTagList[i].id!, false));
    }
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
    String capturedFileNameProblem = '${problemNameController.text}_problem.pdf';
    String capturedFileNameAnswer = '${problemNameController.text}_answer.pdf';

    //Create a new PDF document.
    final PdfDocument document = PdfDocument();
    //Load the image using PdfBitmap.
    final PdfBitmap image = PdfBitmap(capturedImageProblem);
    //Draw the image to the PDF page.
    document.pages.add().graphics.drawImage(image, const Rect.fromLTWH(0, 0, 500, 200));

    //Create a new PDF document.
    final PdfDocument document2 = PdfDocument();
    //Load the image using PdfBitmap.
    final PdfBitmap image2 = PdfBitmap(capturedImageAnswer);
    //Draw the image to the PDF page.
    document2.pages.add().graphics.drawImage(image2, const Rect.fromLTWH(0, 0, 500, 200));

    // Save the document.
    capturedImageProblemPdf = await document.save();
    capturedImageAnswerPdf = await document2.save();

    // capturedImageProblem = Uint8List.fromList(await document.save());
    // capturedImageAnswer = Uint8List.fromList(await document2.save());

    debugPrint("${await document.save()}");
    // Dispose the document.
    document.dispose();
    document2.dispose();

    // final url = Uri.parse('https://uwkedrf.request.dreamhack.games');
    final url = Uri.parse('https://$HOST/api/data/create_problem');
    var request = http.MultipartRequest('POST', url);
    var multipartFileProblem = http.MultipartFile.fromBytes(
      'problem_image',
      capturedImageProblemPdf,
      filename: capturedFileNameProblem,
      contentType: MediaType('application', 'pdf'), // pdf의 MIME타입
    );
    var multipartFileAnswer = http.MultipartFile.fromBytes(
      'problem_image',
      capturedImageAnswerPdf,
      filename: capturedFileNameAnswer,
      contentType: MediaType('application', 'pdf'), // pdf의 MIME타입
    );

    final Map<String, dynamic> requestField = {
      "problem_name": problemNameController.text,
      "parent_database": selectedDirectoryID,
      "tag": selectedTags.toString(),
      "level": difficultySliderValue.round(),
      "problem_string": "\${$capturedFileNameProblem}",
      "answer_string": "\${$capturedFileNameAnswer}",
    };
    debugPrint(selectedTags.toString());

    final Map<String, String> temp = {};
    requestField.forEach((key, value) {
      temp.addAll(Map.fromEntries([MapEntry(key, value.toString())]));
    });

    request.files.add(multipartFileProblem);
    request.files.add(multipartFileAnswer);
    request.fields.addAll(temp);

    request.headers.addAll(await defaultHeader(httpContentType.multipart));
    final response = await request.send();
    debugPrint("${response.statusCode}");
    return response.statusCode;
  }

  /// Get Problem, Answer image as Uint8List
  void getImage(Uint8List image1, Uint8List image2) {
    capturedImageProblem = image1;
    capturedImageAnswer = image2;
  }

  void getPdfRectList(File pdfFile, List<Frame> frameList) {
    this.pdfFile = pdfFile;
    this.frameList = frameList;
  }

  Future<int> sendFirstFrameInfo(int selectedDirectoryID) async {
    List<int> selectedTags = <int>[];
    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i].isSelected == true) {
        selectedTags.add(tagsList[i].ID);
      }
    }
    String capturedFileNameProblem = '${problemNameController.text}_problem.pdf';

    List<int> pdfBytes = await pdfFile.readAsBytes();

    // final url = Uri.parse('https://uwkedrf.request.dreamhack.games');
    final url = Uri.parse('https://$HOST/api/data/parse_pdf');
    var request = http.MultipartRequest('POST', url);
    var multipartFileProblem = http.MultipartFile.fromBytes(
      'source_document',
      pdfBytes,
      filename: capturedFileNameProblem,
      contentType: MediaType('application', 'pdf'), // pdf의 MIME타입
    );

    var temp = [];
    for (int i = 0; i < frameList.length; i++) {
      final Map<String, dynamic> tmp = {
        "page": frameList[i].page,
        "minX": double.parse(frameList[i].minX.toStringAsFixed(8)),
        "minY": double.parse(frameList[i].minY.toStringAsFixed(8)),
        "maxX": double.parse(frameList[i].maxX.toStringAsFixed(8)),
        "maxY": double.parse(frameList[i].maxY.toStringAsFixed(8)),
      };
      temp.add(tmp);
    }

    final Map<String, String> requestField = {
      "frame_list": jsonEncode(temp),
    };
    debugPrint(jsonEncode(temp));

    request.files.add(multipartFileProblem);
    request.fields.addAll(requestField);

    request.headers.addAll(await defaultHeader(httpContentType.multipart));
    final response = await request.send();
    debugPrint("${response.statusCode}");

    var responseBody = await response.stream.bytesToString();
    debugPrint(responseBody);

    return response.statusCode;
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
