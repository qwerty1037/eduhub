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
  bool pdfInputedProblem = false;
  bool pdfInputedAnswer = false;
  File? pickedFileProblem;
  File? pickedFileAnswer;
  Uint8List? capturedFileProblem;
  Uint8List? capturedFileAnswer;
  // post, 내가 뭘 보낼거다. 어떻게 해 줬으면 좋겠다. 간략하게 요청하면 됩니다.

  RxString pickedFileNameProblem = "".obs;
  RxString pickedFileNameAnswer = "".obs;
  RxBool dragging = false.obs;
  RxBool isCapturedProblem = false.obs;
  RxBool isCapturedAnswer = false.obs;

  ///Upload file into Application using FIlePicker.
  ///
  ///insert uploaded file's name into member variable showFileName.
  void fileUpload(PdfFileType pdfFileType, context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      if (pdfFileType == PdfFileType.problem) {
        pickedFileProblem = File(result.files.first.path!);
        String fileName = result.files.first.name;
        debugPrint(fileName);
        pickedFileNameProblem.value = fileName;

        pdfInputedProblem = true;

        // openPDF(context, pickedFileProblem!);
      }
      if (pdfFileType == PdfFileType.answer) {
        pickedFileAnswer = File(result.files.first.path!);
        String fileName = result.files.first.name;
        debugPrint(fileName);
        pickedFileNameAnswer.value = fileName;

        pdfInputedAnswer = true;
        // openPDF(context, pickedFileAnswer!);
      }
    }
  }

  ///Open PDFViewerPage.
  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );

  ///Function when Drag&Drop is done.
  ///
  ///See Also:
  ///
  /// * [openPDF]
  void onDragDone(detail, context, PdfFileType pdfFileType) {
    debugPrint('onDragDone:');
    if (detail != null && detail.files.isNotEmpty) {
      String fileName = detail.files.first.name;
      debugPrint(fileName);
      debugPrint(detail.files.first.path);
      if (pdfFileType == PdfFileType.problem) {
        pickedFileNameProblem.value = fileName;
        pickedFileProblem = File(detail.files.first.path);
        pdfInputedProblem = true;
      }
      if (pdfFileType == PdfFileType.answer) {
        pickedFileNameAnswer.value = fileName;
        pickedFileAnswer = File(detail.files.first.path);
        pdfInputedAnswer = true;
      }
      // openPDF(context, File(detail.files.first.path));
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

  String? getFileName(PdfFileType pdfFileType) {
    if (pdfFileType == PdfFileType.problem) {
      return pickedFileNameProblem.value;
    }
    if (pdfFileType == PdfFileType.answer) {
      return pickedFileNameAnswer.value;
    }
    return "";
  }

  void exitPdf(PdfFileType pdfFileType) {
    if (pdfFileType == PdfFileType.problem) {
      pdfInputedProblem = false;
    }
    if (pdfFileType == PdfFileType.answer) {
      pdfInputedAnswer = false;
    }
  }

  void capturePdf(PdfFileType pdfFileType) async {
    if (pdfFileType == PdfFileType.problem) {
      capturedFileProblem = null;
      isCapturedProblem.value = false;
    }
    if (pdfFileType == PdfFileType.problem) {
      capturedFileAnswer = null;
      isCapturedAnswer.value = false;
    }
    CapturedData? capturedData = await screenCapturer.capture(
      mode: CaptureMode.region, // screen, window
      imagePath: '<path>',
      copyToClipboard: true,
    );
    if (pdfFileType == PdfFileType.problem) {
      isCapturedProblem.value = false;
      capturedFileProblem = capturedData!.imageBytes;
      isCapturedProblem.value = true;
    }
    if (pdfFileType == PdfFileType.answer) {
      isCapturedAnswer.value = false;
      capturedFileAnswer = capturedData!.imageBytes;
      isCapturedAnswer.value = true;
    }
    update();
  }

  void deleteCapturedImage(PdfFileType pdfFileType) {
    if (pdfFileType == PdfFileType.problem) {
      isCapturedProblem.value = false;
      capturedFileProblem = null;
    }
    if (pdfFileType == PdfFileType.answer) {
      isCapturedAnswer.value = false;
      capturedFileAnswer = null;
    }
  }

  bool isCaptured(PdfFileType pdfFileType) {
    if (pdfFileType == PdfFileType.problem) {
      return isCapturedProblem.value;
    } else if (pdfFileType == PdfFileType.answer) {
      return isCapturedAnswer.value;
    } else {
      return false;
    }
  }

  Uint8List? getCapturedImage(pdfFileType) {
    if (pdfFileType == PdfFileType.problem) {
      return capturedFileProblem;
    } else if (pdfFileType == PdfFileType.answer) {
      return capturedFileAnswer;
    } else {
      return null;
    }
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
