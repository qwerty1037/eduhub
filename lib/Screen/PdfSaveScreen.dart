import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:front_end/Controller/PdfSaveController.dart';
import 'package:get/get.dart';
import 'package:front_end/Component/DefaultTextFIeld.dart';
import 'package:front_end/Component/KeyTextSpan.dart';
import 'package:front_end/Test/TempTag.dart';

class PdfSaveScreen extends StatelessWidget {
  final controller = Get.put(PdfSaveController());
  TextEditingController problemNameController = TextEditingController();
  TextEditingController directoryController = TextEditingController();

  @override
  PdfSaveScreen(Uint8List image1, Uint8List image2) {
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
                  const KeyText(text: "문제명"),
                  DefaultTextField(
                    labelText: null,
                    hintText: '문제명을 입력하세요',
                    controller: problemNameController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const KeyText(text: "디렉토리"),
                  DefaultTextField(
                    labelText: null,
                    hintText: '디렉토리를 입력하세요',
                    controller: problemNameController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const KeyText(text: "Tags"),
                  DefaultTextField(
                    labelText: null,
                    hintText: 'Tags을 입력하세요',
                    controller: problemNameController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const KeyText(text: "난이도"),
                  Obx(() {
                    return Slider(
                      max: 5,
                      min: 0,
                      divisions: 5,
                      value: controller.difficultySliderValue.value,
                      label: controller.difficultySliderValue.value
                          .round()
                          .toString(),
                      onChanged: (double value) {
                        controller.difficultySliderValue.value = value;
                      },
                    );
                  }),
                  const SizedBox(height: 30),
                  Obx(() {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
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
                              controller.imagePreviewButtonTapped();
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
                                    child: Image.memory(
                                        controller.capturedImageProblem),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    width: constraints.maxWidth / 2.2,
                                    height: constraints.maxWidth / 1.6,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                    ),
                                    child: Image.memory(
                                        controller.capturedImageAnswer),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
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
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
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
