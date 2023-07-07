import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:front_end/Controller/PdfSaveController.dart';
import 'package:get/get.dart';
import 'package:front_end/Component/DefaultTextFIeld.dart';
import 'package:front_end/Component/KeyTextSpan.dart';
import 'package:front_end/Test/TempTag.dart';
import 'package:korea_regexp/korea_regexp.dart';

class PdfSaveScreen extends StatelessWidget {
  final controller = Get.put(PdfSaveController());
  TextEditingController problemNameController = TextEditingController();
  TextEditingController directoryController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  @override
  PdfSaveScreen(Uint8List image1, Uint8List image2) {
    controller.getImage(image1, image2);
  }

  List<Widget> selectedChipsList() {
    List<Widget> chips = [];
    for (int i = 0; i < controller.tagsList.length; i++) {
      if (controller.tagsList[i].isSelected == true) {
        Widget item = FilterChip(
          label: Text(controller.tagsList[i].label),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
          backgroundColor: Colors.grey,
          selected: controller.tagsList[i].isSelected,
          onSelected: (bool value) {
            controller.tagsList[i].isSelected = false;
            controller.tagsList.refresh();
          },
        );
        chips.add(item);
      }
    }
    return chips;
  }

  List<Widget> filterChipsList() {
    List<Widget> chips = [];
    if (controller.tagsTextValue.value == "") {
      return [];
    } else {
      RegExp regExp = getRegExp(
        controller.tagsTextValue.value,
        RegExpOptions(
          initialSearch: true,
          startsWith: false,
          endsWith: false,
          fuzzy: true,
          ignoreSpace: true,
          ignoreCase: true,
        ),
      );
      for (int i = 0; i < controller.tagsList.length; i++) {
        if (regExp.hasMatch(controller.tagsList[i].label)) {
          Widget item = FilterChip(
            label: Text(controller.tagsList[i].label),
            labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
            backgroundColor: Colors.grey,
            selected: controller.tagsList[i].isSelected,
            onSelected: (bool value) {
              controller.tagsList[i].isSelected = value;
              controller.tagsList.refresh();
            },
          );
          if (controller.tagsList[i].isSelected == false) {
            chips.add(item);
          }
        }
      }
      return chips;
    }
  }

  Widget problemNameInputField() {
    return Column(
      children: [
        const KeyText(text: "문제명"),
        DefaultTextField(
          labelText: null,
          hintText: '문제명을 입력하세요',
          controller: problemNameController,
        ),
      ],
    );
  }

  Widget directroyInputField() {
    return Column(
      children: [
        const KeyText(text: "디렉토리"),
        DefaultTextField(
          labelText: null,
          hintText: '디렉토리를 입력하세요',
          controller: problemNameController,
        ),
      ],
    );
  }

  Widget tagsInputField() {
    return Column(
      children: [
        const KeyText(text: "Tags"),
        const SizedBox(height: 20),
        Obx(() {
          return Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              direction: Axis.horizontal,
              children: selectedChipsList(),
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
          controller: tagsController,
        ),
        const SizedBox(height: 20),
        Obx(() {
          return Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              direction: Axis.horizontal,
              children: filterChipsList(),
            ),
          );
        }),
      ],
    );
  }

  Widget difficultyInputField() {
    return Column(
      children: [
        const KeyText(text: "난이도"),
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
    return Container(
      height: 50,
      alignment: Alignment.center,
      color: Colors.blueAccent,
      child: const Text(
        "이렇게 저장하기",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
