import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/default_title.dart';
import 'package:front_end/Component/Default/default_text_box.dart';
import 'package:front_end/Controller/tag_controller.dart';
import 'package:front_end/Test/temp_tag.dart';
import 'package:get/get.dart';

class TagManagementScreen extends StatelessWidget {
  TagManagementScreen({super.key});
  final tagController = Get.find<TagController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
      child: Column(
        children: [
          const DefaultTitle(text: "추가하실 태그를 입력하세요"),
          DefaultTextBox(
            placeholder: "Insert Tags",
            onEditingComplete: () {
              if (tagController.tagsInputController.text != " ") {
                //TODO: 나중에 엄밀한 문자열 알고리즘 필요
                tagController.inputedTagsList.add(
                  Tag(
                    id: null,
                    name: tagController.tagsInputController.text,
                    problemCount: 0,
                    ownerId: null,
                  ),
                );
                tagController.numberOfTags++;
                tagController.tagsInputController.text = "";
              }
            },
            controller: tagController.tagsInputController,
          ),
          const SizedBox(height: 20),
          Obx(() {
            return Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                direction: Axis.horizontal,
                children: tagController.inputedChipsList().map((element) {
                  return Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: element,
                  );
                }).toList(),
              ),
            );
          }),
          const SizedBox(height: 20),
          TagSaveButton(),
        ],
      ),
    );
  }

  /// Button that saves inputed Tags
  ///
  /// When button clicked, http requests to backend
  Widget TagSaveButton() {
    return TextButton(
      onPressed: () {
        tagController.sendTags();
      },
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xfff7630c),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: const Text(
          "태그 저장하기",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
