import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Component/Default/cookie.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// GetX Controller that controls SearchScreen
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

  int? getDifficulty() {
    return difficulty.value != 999 ? difficulty.value : null;
  }

  String getContent() {
    return content.value;
  }

  void setDifficulty(int value) {
    difficulty.value = value;
  }

  void setContent(String value) {
    content.value = value;
  }

  void backend() async {
    final folderController = Get.find<FolderController>();
    List<int> searchedFolderId = [];
    for (int i = 0; i < folderController.totalFolders.length; i++) {
      if (searchBarController.text == folderController.totalFolders[i].value["name"]) {
        searchedFolderId.add(folderController.totalFolders[i].value["id"]);
      }
    }

    final url = Uri.parse('https://$HOST/api/data/user_database');
    final response = await http.get(
      url,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);
      final databaseFolder = jsonResponse['database_folders'];
      folderController.makeFolderListInfo(databaseFolder);
    } else {
      debugPrint("폴더 리스트 받기 오류 발생");
    }
  }
}
