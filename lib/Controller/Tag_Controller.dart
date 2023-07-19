import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/Cookie.dart';
import 'package:front_end/Component/HttpConfig.dart';
import 'package:front_end/Test/Temp_Tag.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TagController extends GetxController {
  TextEditingController tagsInputController = TextEditingController();
  int numberOfTags = 0;
  RxList<Tag> inputedTagsList = <Tag>[].obs;
  late int tagId;

  TagController() {
    tagId = 10000 * 1 + numberOfTags;
  }

  RxString tagsInputValue = "".obs;

  List<Widget> inputedChipsList() {
    List<Widget> chips = [];

    for (int i = 0; i < inputedTagsList.length; i++) {
      Widget item = Chip(
        label: Text(inputedTagsList[i].name),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
        backgroundColor: Colors.grey,
        deleteIcon: const Icon(Icons.cancel),
        onDeleted: () {
          inputedTagsList.removeAt(i);
        },
      );
      chips.add(item);
    }
    return chips;
  }

  void sendTags() async {
    String HOST = "61.82.182.149:3000";
    final url = Uri.parse('http://$HOST/api/data/create_tag_list');

    List<String> selectedTags = <String>[];
    for (int i = 0; i < inputedTagsList.length; i++) {
      selectedTags.add(inputedTagsList[i].name);
    }
    for (int i = 0; i < selectedTags.length; i++) {
      print(selectedTags[i]);
    }
    final Map<String, dynamic> requestBody = {
      "tag_name_list": selectedTags,
    };

    final headers = {"Content-type": "application/json"};

    final response = await http.post(
      url,
      headers: await defaultHeader(httpContentType.json),
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
  }
}
