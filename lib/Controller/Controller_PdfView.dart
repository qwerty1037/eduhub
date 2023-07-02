///This q implements FileDragAndDropController, which is used in pdfviewer.
///
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:front_end/Test/screen_pdf_viewer.dart';
import 'dart:io';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:flutter/services.dart';
import '../Test/screen_pdf_web_view.dart';

enum PdfFileType {
  problem,
  answer,
}

class PdfFile {}

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
