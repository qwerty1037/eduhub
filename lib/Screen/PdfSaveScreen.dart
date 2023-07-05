import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:front_end/Controller/PdfSaveController.dart';
import 'package:get/get.dart';
import 'package:front_end/Component/DefaultTextFIeld.dart';

class PdfSaveScreen extends StatelessWidget {
  PdfSaveController controller = Get.put(PdfSaveController());
  TextEditingController problemNameController = TextEditingController();
  TextEditingController directoryController = TextEditingController();

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
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.center,
                        child: const Text(
                          "문제명: ",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: DefaultTextField(
                          labelText: null,
                          hintText: '문제명을 입력하세요',
                          controller: problemNameController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.center,
                        child: const Text(
                          "디렉토리: ",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: DefaultTextField(
                          labelText: null,
                          hintText: '디렉토리를 입력하세요',
                          controller: directoryController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.center,
                        child: const Text(
                          "Tags: ",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: DefaultTextField(
                          labelText: null,
                          hintText: 'tags를 입력하세요',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.center,
                        child: const Text(
                          "난이도: ",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      MouseRegion(
                        onHover: (event) {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) {
                              return Container(
                                width: 100,
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: Image.memory(
                                      controller.capturedImageProblem,
                                    ).image,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 3,
                          height: 30,
                          child: const Text("Problem"),
                        ),
                      ),
                    ],
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
