import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller of FeedBack Screen
class FeedbackController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  /// Delete all text of TextField
  void delete() {
    titleController.text = "";
    contentController.text = "";
  }
}
