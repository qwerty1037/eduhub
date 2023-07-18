import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/ScreenController/Pdf_Save_Screen_Controller.dart';
import 'package:get/get.dart';
import 'package:front_end/Component/Default/Default_Text_FIeld.dart';
import 'package:front_end/Component/Default/Default_Key_Text.dart';
import 'package:front_end/Controller/Tab_Controller.dart' as t;

class PdfSaveScreen extends StatelessWidget {
  final DefaultTabBodyController _defaultTabBodyController =
      Get.find<DefaultTabBodyController>(
          tag: Get.find<t.TabController>().getTabKey());
  final controller = Get.put(PdfSaveController(),
      tag: Get.find<t.TabController>().getTabKey());

  @override
  PdfSaveScreen(Uint8List image1, Uint8List image2, {super.key}) {
    controller.getImage(image1, image2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaveCapture'),
      ),
      backgroundColor: Colors.white,
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
                  const SizedBox(height: 30),
                  difficultyInputField(),
                  const SizedBox(height: 30),
                  imagePreviewField(),
                  const SizedBox(height: 40),
                  saveButtonField(),
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
        const DefaultKeyText(text: "문제명"),
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
        const DefaultKeyText(text: "디렉토리"),
        DefaultTextField(
          labelText: null,
          hintText: '디렉토리를 입력하세요',
          controller: controller.directoryController,
        ),
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
          onChanged: (text) {
            controller.tagsTextValue.value = text.toString();
          },
          controller: controller.tagsController,
        ),
        const SizedBox(height: 20),
        Obx(() {
          return Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              direction: Axis.horizontal,
              children: controller.filterChipsList(),
            ),
          );
        }),
      ],
    );
  }

  Widget difficultyInputField() {
    return Column(
      children: [
        Stack(
          children: [
            const DefaultKeyText(text: "난이도"),
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

  Widget imagePreviewField() {
    return Obx(() {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: '캡처된 이미지 ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: controller.imagePreviewButtonText(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                controller.whenImagePreviewButtonTapped();
              },
            ),
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: controller.isImagePreviewButtonTapped.value,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: constraints.maxWidth / 2.2,
                      height: constraints.maxWidth / 1.6,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                      ),
                      child: Image.memory(controller.capturedImageProblem),
                    ),
                    const Expanded(child: SizedBox()),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: constraints.maxWidth / 2.2,
                      height: constraints.maxWidth / 1.6,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                      ),
                      child: Image.memory(controller.capturedImageAnswer),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget saveButtonField() {
    return TextButton(
      onPressed: () {
        controller.sendRegisterInfo();
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
          _defaultTabBodyController
              .changeWorkingSpace(_defaultTabBodyController.savedWorkingSpace!);
        },
      ),
    );
  }
}
