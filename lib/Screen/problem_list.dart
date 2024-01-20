import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as flutter_material;
import 'package:front_end/Component/problem_viewer.dart';
import 'package:front_end/Controller/problem_list_controller.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:get/get.dart';

///폴더에 속하는 문제 리스트를 보여주며 직속문제/아래모든문제를 볼 수 있다. 클릭시 오른쪽에 이미지가 뜨며 버튼 부분은 수정이 필요하다
class ProblemList extends StatelessWidget {
  ProblemList({super.key, required this.targetFolder, required this.folderName, required this.problems, required this.problemListController});
  String folderName;
  TreeViewItem targetFolder;
  List<dynamic> problems;

  final tag = Get.find<FluentTabController>().getTabKey();
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
                      problemListController.isOneColumn.value
                          ? problemListController.isOneColumn.value = false
                          : problemListController.isOneColumn.value = true;
                    },
                    child: Text(problemListController.isOneColumn.value ? "간략히 보기" : "자세히 보기"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
