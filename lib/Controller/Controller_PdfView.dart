///This q implements FileDragAndDropController, which is used in pdfviewer.
///
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:flutter/services.dart';

enum PdfFileType {
  problem,
  answer,
}

class PdfFile {
  Uint8List? capturedFile;
}

//
// context : string ? 아니 미친놈아 image 어디감?
// -> 사실은 이렇습니다 : string 안에 uri가 있어요!
// 대충 이런식으로 : ${href} ㅇㅇ 이러면 본문 안에 어디든 img 간단하게 삽입 가능.
// -> 아니 그러면 ㅅㅂ 보낼때 어떻게 보냄. 백엔드 니네야 서버가 있으니까 href로 퉁칠수있는데
//    클라이언트는 어케보냄?
// 보낼때 ${1}으로 보내고, file로 알아서 보내주세요.
//
// https://my.snu.ac.kr?professor=killed
//
// {
//     "badWords": {
//        "kor": ["sibal", "yabal"],
//        "count": 2
//    }
//}
///GetxController of pdf_test
class PdfScreenController extends GetxController {
  Color defaultColor = Colors.grey[400]!;
  Color uploadingColor = Colors.blue[100]!;
  bool pdfInputed = false;
  File? pickedFile;
  Uint8List? capturedFile;
  RxString pickedFileName = "".obs;
  RxBool dragging = false.obs;
  RxBool isCaptured = false.obs;

  ///Upload file into Application using FIlePicker.
  ///
  ///insert uploaded file's name into member variable showFileName.
  void fileUpload(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      pickedFile = File(result.files.first.path!);
      String fileName = result.files.first.name;
      debugPrint(fileName);
      pickedFileName.value = fileName;
      pdfInputed = true;
    }
  }

  ///Function when Drag&Drop is done.
  ///
  ///See Also:
  ///
  /// * [openPDF]
  void onDragDone(
    detail,
    context,
  ) {
    debugPrint('onDragDone:');
    if (detail != null && detail.files.isNotEmpty) {
      String fileName = detail.files.first.name;
      debugPrint(fileName);
      debugPrint(detail.files.first.path);
      pickedFileName.value = fileName;
      pickedFile = File(detail.files.first.path);
      pdfInputed = true;
    }
  }

  ///Function when Drag enter the target.
  void onDragEntered(detail) {
    debugPrint('onDragEntered:');
    dragging.value = true;
  }

  ///Function when Drag exit the target.
  void onDragExited(detail) {
    debugPrint('onDragExited:');
    dragging.value = false;
  }

  String? getFileName() {
    return pickedFileName.value;
  }

  void exitPdf() {
    pdfInputed = false;
  }

  void capturePdf() async {
    capturedFile = null;
    isCaptured.value = false;

    CapturedData? capturedData = await screenCapturer.capture(
      mode: CaptureMode.region, // screen, window
      imagePath: '<path>',
      copyToClipboard: true,
    );

    isCaptured.value = false;
    capturedFile = capturedData!.imageBytes;
    isCaptured.value = true;
  }

  void deleteCapturedImage() {
    isCaptured.value = false;
    capturedFile = null;
  }

  Uint8List? getCapturedImage() {
    return capturedFile;
  }

  ///Target Box Color.
  ///
  ///When Drag Cursor is inside the target, color = uploadingColor.
  ///
  ///When Drag Cursor is outside the target, color = defaultColor.
  Color buttoncolor() {
    return dragging.value ? uploadingColor : defaultColor;
  }
}
