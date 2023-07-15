import 'package:flutter/material.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final searchBarController = Get.put(SearchController());

  RxBool isFolderEmpty = false.obs;
  FolderController folderController = Get.find<FolderController>();
  HomeScreenController() {
    if (folderController.firstFolders.isEmpty) {
      isFolderEmpty.value = true;
    }
  }
}
