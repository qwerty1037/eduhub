import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class FileDragAndDropController extends GetxController {
  Color defaultColor = Colors.grey[400]!;
  Color uploadingColor = Colors.blue[100]!;
  RxString showFileName = "".obs;
  RxBool dragging = false.obs;
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

  void onDragZone(detail) {
    debugPrint('onDragDone:');
    if (detail != null && detail.files.isNotEmpty) {
      String fileName = detail.files.first.name;
      debugPrint(fileName);
      showFileName.value = "Now File Name: $fileName";
    }
  }

  void onDragEntered(detail) {
    debugPrint('onDragEntered:');
    dragging.value = true;
  }

  void onDragExited(detail) {
    debugPrint('onDragExited:');
    dragging.value = false;
  }

  Color buttoncolor() {
    return dragging.value ? uploadingColor : defaultColor;
  }
}
