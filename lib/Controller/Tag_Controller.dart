import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Test/Temp_Tag.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// Controller of tag input Screen
class TagController extends GetxController {
  TextEditingController tagsInputController = TextEditingController();
  int numberOfTags = 0;
  RxList<Tag> inputedTagsList = <Tag>[].obs;
  RxList<Tag> totalTagList = <Tag>[].obs;

  TagController() {
    receiveTags();
  }

  /// 입력된 칩 리스트 반환
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

  /// Tags를 Backend로 http request
  void sendTags() async {
    final url = Uri.parse('https://$HOST/api/data/create_tag_list');

    List<String> selectedTags = <String>[];
    for (int i = 0; i < inputedTagsList.length; i++) {
      selectedTags.add(inputedTagsList[i].name);
    }
    /*
    for (int i = 0; i < selectedTags.length; i++) {
      print(selectedTags[i]);
    }
*/
    final Map<String, dynamic> requestBody = {
      "tag_name_list": selectedTags,
    };

    final response = await http.post(
      url,
      headers: await defaultHeader(httpContentType.json),
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
    if (isHttpRequestSuccess(response)) {
      debugPrint("태그 전송 성공");
    } else if (isHttpRequestFailure(response)) {
      debugPrint("태그 전송 실패");
    }
    receiveTags();
  }

  void receiveTags() async {
    totalTagList = <Tag>[].obs;
    final url = Uri.parse('https://$HOST/api/data/mytags');
    final response = await http.get(
      url,
      headers: await defaultHeader(httpContentType.json),
    );
    final tempTagList = jsonDecode(response.body)["tags"];
    for (int i = 0; i < tempTagList.length; i++) {
      Tag tempTag = Tag(
        id: tempTagList[i]["id"],
        name: tempTagList[i]["name"],
        ownerId: tempTagList[i]["owner_id"],
        problemCount: tempTagList[i]["problem_count"],
      );
      totalTagList.add(tempTag);
    }
    totalTagList.refresh();
  }
}
