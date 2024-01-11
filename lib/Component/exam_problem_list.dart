import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter_material;
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Controller/problem_list_controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///시험지에 속하는 문제 리스트를 보여준다. 클릭시 오른쪽에 이미지가 뜬다.
class ExamProblemList extends StatelessWidget {
  ExamProblemList({super.key, required this.targetFolder, required this.folderName, required this.problems, required this.problemListController});
  String folderName;
  TreeViewItem targetFolder;
  List<dynamic> problems;

  final tag = Get.find<TabController>().getTabKey();
  ProblemListController problemListController;
  final List<int> pdfHeader = [37, 80, 68, 70]; // PDF 파일 헤더
  final List<int> jpegHeader = [255, 216]; // JPEG 파일 헤더
  final List<int> pngHeader = [137, 80, 78, 71, 13, 10, 26, 10]; // PNG 파일 헤더

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration.zero),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.none && snapshot.connectionState != ConnectionState.waiting) {
            return Column(
              children: [
                TopBar(folderName: folderName, tag: tag, targetFolder: targetFolder, problems: problems, problemListController: problemListController),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: GetX<ProblemListController>(
                        tag: tag,
                        builder: (controller) {
                          return Row(
                            children: [
                              Expanded(
                                flex: controller.isOneColumn.value ? 3 : 6,
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: columnProblemList(controller),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: controller.pageButton,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ProblemViewer(controller: controller),
                            ],
                          );
                        }),
                  ),
                ),
              ],
            );
          } else {
            return const flutter_material.CircularProgressIndicator();
          }
        });
  }

  Widget columnProblemList(ProblemListController controller) {
    return Obx(
      () => GridView.count(
          crossAxisCount: controller.isOneColumn.value ? 1 : 2,
          childAspectRatio: 7,
          children: controller.currentPageProblems.map((element) {
            return Button(
              onPressed: () async {
                final url = Uri.parse('https://$HOST/api/data/problem-pdf/${element["problem_string"].toString().substring(2, element["problem_string"].length - 1)}');

                final response = await http.get(
                  url,
                  headers: await defaultHeader(httpContentType.json),
                );
                if (response.statusCode ~/ 100 == 2) {
                  debugPrint(response.statusCode.toString());
                  debugPrint(response.bodyBytes.toString());
                  controller.bytes.value = response.bodyBytes;

                  if (controller.bytes.length >= 4 && List<int>.from(controller.bytes.take(4)) == pdfHeader) {
                    controller.problemFileType.value = fileType.pdf;
                  } else if (controller.bytes.length >= 2 && List<int>.from(controller.bytes.take(2)) == jpegHeader) {
                    controller.problemFileType.value = fileType.jpg;
                  } else if (controller.bytes.length >= 8 && List<int>.from(controller.bytes.take(8)) == pngHeader) {
                    controller.problemFileType.value = fileType.png;
                  } else {
                    debugPrint("pdf, jpg, png 형태의 파일이 아닙니다 (problem list)");
                  }
                  controller.bytes.refresh();
                } else {
                  controller.problemFileType.value = fileType.empty;
                  debugPrint(response.statusCode.toString());
                  debugPrint("문제 이미지 불러오기 오류 발생");
                }
              },
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(element["name"]), Text("난이도 : ${element["level"]}")],
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}

class ProblemViewer extends StatelessWidget {
  ProblemViewer({super.key, required this.controller});

  ProblemListController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: controller.isOneColumn.value ? 5 : 2,
      child: Column(
        children: [
          controller.problemFileType.value == fileType.empty
              ? const Expanded(
                  child: Center(
                  child: Text("왼쪽에서 문제를 클릭해주세요"),
                ))
              : controller.problemFileType.value == fileType.pdf
                  ? Expanded(child: SfPdfViewer.memory(Uint8List.fromList(controller.bytes)))
                  : Expanded(child: Image.memory(Uint8List.fromList(controller.bytes)))
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.folderName,
    required this.tag,
    required this.targetFolder,
    required this.problems,
    required this.problemListController,
  });

  final String folderName;
  final String tag;
  final TreeViewItem targetFolder;
  final List problems;
  final ProblemListController problemListController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                folderName,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                Obx(
                  () => Button(
                    onPressed: () {
                      problemListController.isOneColumn.value ? problemListController.isOneColumn.value = false : problemListController.isOneColumn.value = true;
                    },
                    child: Text(problemListController.isOneColumn.value ? "간략히 보기" : "자세히 보기"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Button(
                  onPressed: () {
                    displayInfoBar(
                      context,
                      builder: (context, close) {
                        return const InfoBar(
                          title: Text('수정하기:'),
                          content: Text(
                            '현재 준비 중인 기능입니다',
                          ),
                          severity: InfoBarSeverity.info,
                        );
                      },
                    );
                    //TODO : Redirect to DBEditScreen
                  },
                  child: const Text("수정하기"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
