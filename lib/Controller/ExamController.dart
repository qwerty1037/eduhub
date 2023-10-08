import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:front_end/Component/Tag_Model.dart';
import 'package:front_end/Controller/Tag_Controller.dart';
import 'package:get/get.dart';
import 'package:korea_regexp/korea_regexp.dart';

class FolderData {
  FolderData({required this.parent, required this.id, required this.name});
  int? parent;
  int id;
  String name;
}

class ExamController extends GetxController {
  RxBool isSettingFinished = false.obs;
  RxInt totalCount = 0.obs;
  RxBool isFirestRequest = false.obs;
  TextEditingController countController = TextEditingController();
  TextEditingController examNameController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController minlevelController = TextEditingController();
  TextEditingController maxlevelController = TextEditingController();
  RxString tagValue = "".obs;
  RxBool chooseLevel = false.obs;
  RxSet<FolderData> folders = <FolderData>{}.obs;
  RxList<TagModel> tagsList = <TagModel>[].obs;
  RxBool isRandom = true.obs;
  ExamController() {
    final tagController = Get.find<TagController>();
    for (int i = 0; i < tagController.totalTagList.length; i++) {
      tagsList.add(TagModel(tagController.totalTagList[i].name, tagController.totalTagList[i].id!, false));
    }
  }

  /// 선택된 칩 리스트 반환
  List<Widget> selectedChipsList() {
    List<Widget> chips = [];
    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i].isSelected == true) {
        Widget item = m.Card(
          elevation: 0,
          color: Colors.grey[30],
          child: m.FilterChip(
            label: Text(tagsList[i].label),
            labelStyle: const TextStyle(fontSize: 16),
            backgroundColor: Colors.grey[50],
            selected: tagsList[i].isSelected,
            onSelected: (bool value) {
              tagsList[i].isSelected = false;
              tagsList.refresh();
            },
          ),
        );
        chips.add(item);
      }
    }
    return chips;
  }

  List<Widget> filterChipsList() {
    List<Widget> chips = [];
    if (tagValue.value == "") return chips;
    RegExp regExp = getRegExp(
      tagValue.value, // != "" ? tagValue.value : " ",
      RegExpOptions(
        initialSearch: true,
        startsWith: false,
        endsWith: false,
        fuzzy: true,
        ignoreSpace: true,
        ignoreCase: true,
      ),
    );

    for (int i = 0; i < tagsList.length; i++) {
      if (tagValue.value == "") {
        break;
      }
      if (regExp.hasMatch(tagsList[i].label)) {
        Widget item = m.Card(
          elevation: 0,
          color: Colors.grey[30],
          child: m.FilterChip(
            elevation: 0.0,
            label: Text(tagsList[i].label),
            labelStyle: const TextStyle(fontSize: 16),
            backgroundColor: Colors.grey[50],
            selected: tagsList[i].isSelected,
            onSelected: (bool value) {
              tagsList[i].isSelected = value;
              tagsList.refresh();
            },
          ),
        );
        if (tagsList[i].isSelected == false) {
          chips.add(item);
        }
      }
    }
    return chips;
  }
}
