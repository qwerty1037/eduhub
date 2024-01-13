import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/default_tab_body.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Component/exam_problem_list.dart';
import 'package:front_end/Controller/problem_list_controller.dart';

import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:front_end/Screen/problem_list.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChooseExam extends StatelessWidget {
  ChooseExam({super.key, required this.exams, required this.item});
  List<dynamic> exams;
  final TreeViewItem item;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 7,
        children: exams.map((element) {
          return Button(
            onPressed: () async {
              FluentTabController tabController =
                  Get.find<FluentTabController>();
              tabController.isNewTab = true;
              ProblemListController controller = Get.put(
                  ProblemListController(element["problems"]),
                  tag: Get.find<FluentTabController>().getTabKey());
              DefaultTabBody generatedTab = DefaultTabBody(
                key: GlobalObjectKey(tabController.tagNumber.toString()),
                dashBoardType: DashBoardType.examExplore,
                workingSpace: ExamProblemList(
                  targetFolder: item, //시험지 폴더
                  folderName: item.value["name"], //시험지 이름
                  problems: exams, //문제 id 리스트
                  problemListController: controller,
                ),
              );

              Tab newTab = tabController.addTab(generatedTab,
                  item.value["name"], const Icon(FluentIcons.text_document));
              tabController.tabs.add(newTab);
              tabController.currentTabIndex.value =
                  tabController.tabs.length - 1;
              tabController.isNewTab = false;
            },
            child: SizedBox(
              height: 100,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(element["name"]),
                    Text("난이도: ${element["level"]}"),
                    Text("문제수 : ${element["problemIdList"].length}개")
                  ],
                ),
              ),
            ),
          );
        }).toList());
  }
}
