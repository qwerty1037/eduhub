import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:front_end/Controller/ScreenController/db_edit_screen_controller.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:get/get.dart';
import 'package:front_end/Component/Default/default_text_field.dart';
import 'package:front_end/Component/Default/default_title.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';

/// DBEditScreen
///
/// 인자로 문제 제목, 난이도, 태그 리스트, pdf의 byteFile을 전달하면 됨.
///
///
class DBEditScreen extends StatelessWidget {
  final DefaultTabBodyController _defaultTabBodyController = Get.find<DefaultTabBodyController>(tag: Get.find<FluentTabController>().getTabKey());
  final controller = Get.put(DBEditScreenController(), tag: Get.find<FluentTabController>().getTabKey());
  final UserDataController folderController = Get.find<UserDataController>();

  final Uint8List bytePdf;
  final String problemName;
  final double? difficulty;
  final List<int> tagsList;

  @override
  DBEditScreen({super.key, required this.bytePdf, required this.problemName, this.difficulty, required this.tagsList}) {
    controller.problemNameController.text = problemName;
    controller.difficultySliderValue.value = difficulty ?? 0.0;
    for (var inputTagID in tagsList) {
      for (var element in controller.tagsList) {
        if (element.ID == inputTagID) {
          element.isSelected = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaveCapture'),
      ),
      //backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  problemNameInputField(),
                  const SizedBox(height: 30),
                  tagsInputField(),
                  const SizedBox(height: 30),
                  difficultyInputField(),
                  const SizedBox(height: 40),
                  saveButtonField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget problemNameInputField() {
    return Column(
      children: [
        const DefaultTitle(text: "문제명"),
        DefaultTextField(
          labelText: null,
          hintText: '문제명을 입력하세요',
          controller: controller.problemNameController,
        ),
      ],
    );
  }

  Widget directroyInputField() {
    return Column(
      children: [
        const DefaultTitle(text: "디렉토리"),
        const DefaultTitle(text: "왼쪽 대시보드에서 저장할 폴더를 클릭하세요"),
        Obx(() => DefaultTitle(text: folderController.selectedPath.value)),
      ],
    );
  }

  Widget tagsInputField() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Tags ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "- 눌러서 해제",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          return Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              direction: Axis.horizontal,
              children: controller.selectedChipsList(),
            ),
          );
        }),
        const SizedBox(height: 20),
        DefaultTextField(
          labelText: null,
          hintText: 'Tags을 입력하세요',
          onChanged: (String value) {
            controller.tagTextFieldValue.value = value;
          },
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Obx(
            () => Wrap(
              spacing: 8,
              direction: Axis.horizontal,
              children: controller.filterChipsList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget difficultyInputField() {
    return Column(
      children: [
        Stack(
          children: [
            const DefaultTitle(text: "난이도"),
            Align(
              alignment: Alignment.center,
              child: Obx(
                () => Text(
                  "[${controller.difficultySliderValue.value.round()}]",
                  style: const TextStyle(
                    fontSize: 35,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(() {
          return Slider(
            max: 5,
            min: 0,
            divisions: 5,
            value: controller.difficultySliderValue.value,
            label: controller.difficultySliderValue.value.round().toString(),
            onChanged: (double value) {
              controller.difficultySliderValue.value = value;
            },
          );
        }),
      ],
    );
  }

  Widget saveButtonField() {
    return TextButton(
      onPressed: () {
        controller.sendProblemInfo(folderController.selectedProblemDirectoryId.value);
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
          "이렇게 저장하기",
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
