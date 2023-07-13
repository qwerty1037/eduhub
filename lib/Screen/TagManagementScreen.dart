import 'package:flutter/material.dart';
import 'package:front_end/Component/DefaultKeyText.dart';
import 'package:front_end/Component/DefaultTextFIeld.dart';
import 'package:front_end/Controller/TagController.dart';
import 'package:front_end/Test/TempTag.dart';
import 'package:get/get.dart';

class TagManagementScreen extends StatelessWidget {
  TagManagementScreen({super.key});
  final tagController = Get.put(TagController());

  Widget saveButtonField() {
    return TextButton(
      onPressed: () {
        tagController.sendTags();
      },
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
        child: Column(
          children: [
            const DefaultKeyText(text: "추가하실 태그를 입력하세요"),
            DefaultTextField(
              hintText: "Insert Tags",
              onChanged: (value) {
                tagController.tagsInputValue.value = value.toString();
              },
              onEditingComplete: () {
                if (tagController.tagsInputController.text != " ") {
                  //TODO: 나중에 엄밀한 문자열 알고리즘 필요
                  tagController.inputedTagsList.add(
                    Tag(
                      id: tagController.tagId,
                      name: tagController.tagsInputController.text,
                      problemCount: 0,
                      ownerId: 1,
                    ),
                  );
                  tagController.numberOfTags++;
                  tagController.tagsInputController.text = "";
                }
              },
              controller: tagController.tagsInputController,
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  direction: Axis.horizontal,
                  children: tagController.inputedChipsList(),
                ),
              );
            }),
            const SizedBox(
              height: 20,
            ),
            saveButtonField(),
          ],
        ),
      ),
    );
  }
}
