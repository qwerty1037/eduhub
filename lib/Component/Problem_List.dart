import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter_material;
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///폴더에 속하는 문제 리스트를 보여주며 직속문제/아래모든문제를 볼 수 있다. 클릭시 오른쪽에 이미지가 뜨며 버튼 부분은 수정이 필요하다
class ProblemList extends StatelessWidget {
  ProblemList({super.key, required this.targetFolder, required this.folderName, required this.problems, required this.problemListController});
  String folderName;
  TreeViewItem targetFolder;
  List<dynamic> problems;

  final tag = Get.find<TabController>().getTabKey();
  ProblemListController problemListController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration.zero),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.none && snapshot.connectionState != ConnectionState.waiting) {
            return Column(
              children: [
                Expanded(
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
                            GetX<ProblemListController>(
                              tag: tag,
                              builder: (controller) {
                                return ToggleSwitch(
                                  checked: controller.isAllProblems.value,
                                  onChanged: (info) async {
                                    await controller.resetVariable(targetFolder, problems);
                                    controller.isAllProblems.value = info;
                                  },
                                  content: const Text('하위 폴더 포함'),
                                );
                              },
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Obx(
                              () => Button(
                                onPressed: () {
                                  problemListController.detail.value ? problemListController.detail.value = false : problemListController.detail.value = true;
                                },
                                child: Text(problemListController.detail.value ? "간략히 보기" : "자세히 보기"),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Button(
                              onPressed: () {
                                //TODO : Redirect to DBEditScreen
                              },
                              child: Text("수정하기"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                                flex: controller.detail.value ? 3 : 6,
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: twoColumnProblemList(controller),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: controller.pageButton,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: controller.detail.value ? 5 : 2,
                                child: Column(
                                  children: [
                                    Expanded(child: SfPdfViewer.memory(Uint8List.fromList(controller.bytes))),
                                    /*
                                    Button(
                                      onPressed: () {
                                        controller.detail.value ? controller.detail.value = false : controller.detail.value = true;
                                      },
                                      child: Text(controller.detail.value ? "간략히 보기" : "자세히 보기"),
                                    ),
                                    */
                                  ],
                                ),
                              ),
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

  Widget twoColumnProblemList(ProblemListController controller) {
    return Obx(
      () => GridView.count(
          crossAxisCount: controller.detail.value ? 1 : 2,
          childAspectRatio: 7,
          children: controller.currentPageProblems.map((element) {
            return Button(
              onPressed: () async {
                // final url = Uri.parse('https://mlpwpbr.request.dreamhack.games?reqparam=${element["problem_string"].toString().substring(2, element["problem_string"].length - 1)}');
                final url =
                    Uri.parse('https://$HOST/api/data/problem-pdf/${element["problem_string"].toString().substring(2, element["problem_string"].length - 1)}');

                final response = await http.get(
                  url,
                  headers: await defaultHeader(httpContentType.json),
                );
                if (response.statusCode ~/ 100 == 2) {
                  debugPrint(response.statusCode.toString());
                  controller.bytes.value = response.bodyBytes;
                  controller.bytes.refresh();
                  debugPrint("${response.bodyBytes}");
                  // debugPrint("${controller.bytes}");
                } else {
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
