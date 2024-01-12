import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Test/temp_tag.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// 태그 관련 컨트롤러
/// REVIEW 태그 불러오는 부분 userdata 컨트롤러에 넣는 것과 태그를 구분하는 것 중 어느 것이 나은가?
class TagController extends GetxController {
  TextEditingController tagsInputController = TextEditingController();
  int numberOfTags = 0;
  RxList<Tag> inputedTagsList = <Tag>[].obs;
  RxList<Tag> totalTagList = <Tag>[].obs;
  TagController() {
    receiveTags();
  }

  ///내 태그들을 서버로부터 받아오는 함수
  void receiveTags() async {
    totalTagList = <Tag>[].obs;
    final url = Uri.parse('https://$HOST/api/data/mytags');
    final response = await http.get(
      url,
      headers: await defaultHeader(httpContentType.json),
    );

    if (isHttpRequestSuccess(response)) {
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
    } else {
      debugPrint(" 태그 받아오기 실패(tag_controller)");
    }
  }

  /// 새 태그를 서버에 보내는 함수
  void sendTags() async {
    final url = Uri.parse('https://$HOST/api/data/create_tag_list');

    List<String> selectedTags = <String>[];
    for (int i = 0; i < inputedTagsList.length; i++) {
      selectedTags.add(inputedTagsList[i].name);
    }
    final Map<String, dynamic> requestBody = {
      "tag_name_list": selectedTags,
    };

    final response = await http.post(
      url,
      headers: await defaultHeader(httpContentType.json),
      body: jsonEncode(requestBody),
    );

//TODO 아래에 태그 생성, 실패 여부 유저에게 알려주는 부분 만들어야함
    if (isHttpRequestSuccess(response)) {
    } else {
      debugPrint("태그 생성 실패(tag_controller)");
    }
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
}
