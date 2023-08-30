import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

///폴더에 속하는 문제 리스트를 보여주며 직속문제/아래모든문제를 볼 수 있다. 클릭시 오른쪽에 이미지가 뜨며 버튼 부분은 수정이 필요하다
class ProblemList extends StatelessWidget {
  ProblemList(
      {super.key,
      required this.targetFolder,
      required this.folderName,
      required this.problems}) {
    _problemListController = Get.put<ProblemListController>(
        ProblemListController(problems),
        tag: tag);
  }
  String folderName;
  TreeViewItem targetFolder;
  List<dynamic> problems;

  final tag = Get.find<TabController>().getTabKey();
  late ProblemListController _problemListController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration.zero),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.none &&
              snapshot.connectionState != ConnectionState.waiting) {
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    //color: Get.find<TotalController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          folderName,
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(
                          width: 200,
                        ),
                        GetX<ProblemListController>(
                            tag: tag,
                            builder: (controller) {
                              return ToggleSwitch(
                                checked: controller.isAllProblems.value,
                                onChanged: (info) async {
                                  await controller.resetVariable(
                                      targetFolder, problems);
                                  controller.isAllProblems.value = info;
                                },
                                content: const Text('하위 폴더 포함'),
                              );
                            })
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: GetX<ProblemListController>(
                      tag: tag,
                      builder: (controller) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: twoColumnProblemList(controller),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: controller.pageButton,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: controller.problemImageViewer.value)
                          ],
                        );
                      }),
                ),
              ],
            );
          } else {
            debugPrint(snapshot.connectionState.toString());
            return const SizedBox();
          }
        });
  }

  GridView twoColumnProblemList(ProblemListController controller) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 7,
        children: controller.currentPageProblems.map((element) {
          return Button(
            onPressed: () async {
              final url = Uri.parse(
                  'http://$HOST/api/data/image/${element["problem_string"].toString().substring(2, element["problem_string"].length - 1)}');
              debugPrint(
                  "debug : ${element["problem_string"].toString().substring(2, element["problem_string"].length - 1)}");
              debugPrint("elements : $element");
              final response = await http.get(
                url,
                headers: await defaultHeader(httpContentType.json),
              );
              if (response.statusCode ~/ 100 == 2) {
                controller.problemImageViewer.value = Container(
                  child: Image.memory(
                    response.bodyBytes,
                    fit: BoxFit.contain,
                  ),
                );
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
                  children: [
                    Text(element["name"]),
                    Text("난이도 : ${element["level"]}")
                  ],
                ),
              ),
            ),
          );
        }).toList());
  }
}
