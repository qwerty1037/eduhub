import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front_end/Component/Class/frame.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:front_end/Controller/ScreenController/pdf_save_screen_controller.dart';
import 'package:get/get.dart';
import 'package:front_end/Component/Default/default_text_field.dart';
import 'package:front_end/Component/Default/default_title.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';

class PdfSaveScreen extends StatelessWidget {
  final DefaultTabBodyController _defaultTabBodyController = Get.find<DefaultTabBodyController>(tag: Get.find<FluentTabController>().getTabKey());
  final controller = Get.put(PdfSaveController(), tag: Get.find<FluentTabController>().getTabKey());
  final UserDataController userDataController = Get.find<UserDataController>();

  late List<int> pdfFile;
  late List<Frame> frameList;

  @override
  PdfSaveScreen(this.pdfFile, this.frameList, {super.key}) {
    controller.getPdfRectList(pdfFile, frameList);
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
                  directroyInputField(),
                  const SizedBox(height: 30),
                  tagsInputField(),
                  const SizedBox(height: 40),
                  saveButtonField(context),
                ],
              ),
            ),
          ),
          backButton(),
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
        Obx(() => DefaultTitle(text: userDataController.selectedPath.value)),
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

  Widget saveButtonField(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (controller.validCheck(userDataController.selectedProblemDirectoryId.value)) {
          controller.sendProblemInfo(userDataController.selectedProblemDirectoryId.value);
        } else {
          showValidCheckDialog(context);
        }
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

  Widget backButton() {
    return Align(
      alignment: Alignment.topRight,
      child: ElevatedButton(
        child: const Text('Back'),
        onPressed: () {
          _defaultTabBodyController.changeWorkingSpace(_defaultTabBodyController.savedWorkingSpace!);
        },
      ),
    );
  }
}

void showValidCheckDialog(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    barrierColor: Color(0x00ffffff), //this works

    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('입력하지 않은 칸이 존재하거나 저장할 경로를 지정하지 않았습니다.'),
      content: const Text(
        '입력을 확인해 주세요.',
      ),
      actions: [
        FilledButton(
          child: const Text('확인'),
          onPressed: () => Navigator.pop(context, 'User canceled dialog'),
        ),
      ],
    ),
  );
}
