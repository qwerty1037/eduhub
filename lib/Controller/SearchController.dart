import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/Cookie.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchScreenController extends GetxController {
  TextEditingController searchBarController = TextEditingController();

  static RxInt difficulty = 999.obs;
  static RxString content = "".obs;

  List<MenuFlyoutItemBase> difficultyList = [
    MenuFlyoutItem(
      text: const Text("0"),
      onPressed: () {
        difficulty.value = 0;
      },
    ),
    MenuFlyoutItem(
      text: const Text("1"),
      onPressed: () {
        difficulty.value = 1;
      },
    ),
    MenuFlyoutItem(
      text: const Text("2"),
      onPressed: () {
        difficulty.value = 2;
      },
    ),
    MenuFlyoutItem(
      text: const Text("3"),
      onPressed: () {
        difficulty.value = 3;
      },
    ),
    MenuFlyoutItem(
      text: const Text("4"),
      onPressed: () {
        difficulty.value = 4;
      },
    ),
    MenuFlyoutItem(
      text: const Text("5"),
      onPressed: () {
        difficulty.value = 5;
      },
    ),
  ];
  List<MenuFlyoutItemBase> contentList = [
    MenuFlyoutItem(
      text: const Text("yes"),
      onPressed: () {
        content.value = "yes";
      },
    ),
  ];

  int getDifficulty() {
    return difficulty.value;
  }

  String getContent() {
    return content.value;
  }

  void backend() async {
    final folderController = Get.put(FolderController());
    List<int> searchedFolderId = [];
    for (int i = 0; i < folderController.totalfolders.length; i++) {
      if (searchBarController.text == folderController.totalfolders[i].value["name"]) {
        searchedFolderId.add(folderController.totalfolders[i].value["id"]);
      }
    }

    final url = Uri.parse('http://$HOST/api/data/problem/database_all/${searchedFolderId[0]}');
    final response = await http.get(
      url,
      headers: await sendCookieToBackend(),
    );
    if (response.statusCode ~/ 100 == 2) {
    } else {
      debugPrint("폴더 리스트 받기 오류 발생");
    }
  }
}
