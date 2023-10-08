///This q implements FileDragAndDropController, which is used in pdfviewer.
///
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:flutter/services.dart';

class PdfFile {
  Uint8List? capturedImage;
}

///GetxController of pdf_test
class PdfViewerScreenController extends GetxController {
  Color defaultColor = Colors.grey[400]!;
  Color uploadingColor = Colors.blue[100]!;
  RxBool isPdfInputed = false.obs;
  File? pickedFile;
  RxString pickedFileName = "".obs;
  Uint8List? capturedImage;
  RxBool isDragged = false.obs;
  RxBool isCaptured = false.obs;
  RxInt pickedFileSize = 0.obs;

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
      debugPrint(result.files.first.path!);
      pickedFileName.value = fileName;
      pickedFileSize.value = await pickedFile!.length();
      isPdfInputed.value = true;
    } else {
      print("Upload Failed");
    }
  }

  ///Function when Drag&Drop is done.
  void onDragDone(
    detail,
    context,
  ) async {
    debugPrint('onDragDone:');
    if (detail != null && detail.files.isNotEmpty) {
      String fileName = detail.files.first.name;
      debugPrint(fileName);
      debugPrint(detail.files.first.path);
      pickedFileName.value = fileName;
      pickedFile = File(detail.files.first.path);
      pickedFileSize.value = await pickedFile!.length();
      isPdfInputed.value = true;
    }
  }

  ///Function when Drag enter the target.
  void onDragEntered(detail) {
    debugPrint('onDragEntered:');
    isDragged.value = true;
  }

  ///Function when Drag exit the target.
  void onDragExited(detail) {
    debugPrint('onDragExited:');
    isDragged.value = false;
  }

  String? getFileName() {
    return pickedFileName.value;
  }

  void exitPdf() {
    isPdfInputed.value = false;
  }

  /// Capture image and save
  ///
  /// Always Delete saved Image and capture
  ///
  /// If capturedData is null,
  void capturePdf() async {
    deleteCapturedImage();

    CapturedData? capturedData = await screenCapturer.capture(
      mode: CaptureMode.region, // screen, window
      imagePath: "null",
      copyToClipboard: true,
    );
    if (capturedData == null) {
      print("Capture Failed");
    } else {
      // TODO: null이 입력되었을 때의 처리구문을 작성해야함
      capturedImage = capturedData.imageBytes;
      isCaptured.value = true;
    }
  }

  /// Delete capturedImage
  ///
  ///
  void deleteCapturedImage() {
    isCaptured.value = false;
    capturedImage = null;
  }

  /// Return capturedImage
  Uint8List? getCapturedImage() {
    return capturedImage;
  }

  /// Target Box Color.
  ///
  /// When Drag Cursor is inside the target, color = uploadingColor.
  ///
  /// When Drag Cursor is outside the target, color = defaultColor.
  Color buttoncolor() {
    return isDragged.value ? uploadingColor : defaultColor;
  }
}
