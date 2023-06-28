///This q implements FileDragAndDropController, which is used in pdfviewer.
///
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:front_end/Screen/screen_pdf_viewer.dart';
import 'dart:io';

import '../Screen/screen_pdf_web_view.dart';

///GetxController of pdf_test
class FileDragAndDropController extends GetxController {
  Color defaultColor = Colors.grey[400]!;
  Color uploadingColor = Colors.blue[100]!;
  File? pickedFile;
  RxString showFileName = "".obs;
  RxBool dragging = false.obs;

  ///Upload file into Application using FIlePicker.
  ///
  ///insert uploaded file's name into member variable showFileName.
  void fileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      String fileName = result.files.first.name;
      debugPrint(fileName);
      showFileName.value = 'Now File Name: $fileName';
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
  void onDragDone(detail, context) {
    debugPrint('onDragDone:');
    if (detail != null && detail.files.isNotEmpty) {
      String fileName = detail.files.first.name;
      debugPrint(fileName);
      showFileName.value = "Now File Name: $fileName";
      debugPrint(detail.files.first.path);
      openPDF(context, File(detail.files.first.path));
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

  ///Target Box Color.
  ///
  ///When Drag Cursor is inside the target, color = uploadingColor.
  ///
  ///When Drag Cursor is outside the target, color = defaultColor.
  Color buttoncolor() {
    return dragging.value ? uploadingColor : defaultColor;
  }
}
