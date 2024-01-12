import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter_material;
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Component/problem_viewer.dart';
import 'package:front_end/Controller/problem_list_controller.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:front_end/Screen/problem_list.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///시험지에 속하는 문제 리스트를 보여준다. 클릭시 오른쪽에 이미지가 뜬다.
class ExamProblemList extends StatelessWidget {
  ExamProblemList({super.key, required this.targetFolder, required this.folderName, required this.problems, required this.problemListController});
  String folderName;
  TreeViewItem targetFolder;
  List<dynamic> problems;
  String tag = Get.find<FluentTabController>().getTabKey();
  ProblemListController problemListController;

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
