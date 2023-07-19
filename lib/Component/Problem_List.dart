import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/Cookie.dart';
import 'package:front_end/Component/HttpConfig.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProblemList extends StatelessWidget {
  ProblemList(
      {super.key,
      required this.targetFolder,
      required this.folderName,
      required this.problems});
  String folderName;
  TreeViewItem targetFolder;
  List<dynamic> problems;

  final tag = Get.find<TabController>().getTabKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Get.putAsync<ProblemListController>(() async {
          return ProblemListController(problems);
        }, tag: tag),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.none &&
              snapshot.connectionState != ConnectionState.waiting) {
            return GetX<ProblemListController>(
              tag: uniqueTag,
              builder: (controller) {
                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
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
                            Button(
                              child: controller.isAllProblems.isTrue
                                  ? const Text("폴더 바로 아래 문제보기")
                                  : const Text("폴더 아래 모든 문제보기"),
                              onPressed: () async {
                                controller.resetVariable(
                                    targetFolder, problems);
                                controller.isAllProblems.value =
                                    !controller.isAllProblems.value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Row(
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
                                    child: GridView.count(
                                        crossAxisCount: 2,
                                        childAspectRatio: 7,
                                        children: controller.currentPageProblems
                                            .map((element) {
                                          return Button(
                                            onPressed: () async {
                                              final url = Uri.parse(
                                                  'http://$HOST/api/data/image/${element["problem_string"].toString().substring(2, element["problem_string"].length - 1)}');

                                              final response = await http.get(
                                                url,
                                                headers:
                                                    await sendCookieToBackend(),
                                              );
                                              if (response.statusCode ~/ 100 ==
                                                  2) {
                                                controller.problemImageViewer
                                                    .value = Container(
                                                  child: Image.memory(
                                                    response.bodyBytes,
                                                    fit: BoxFit.contain,
                                                  ),
                                                );
                                              } else {
                                                debugPrint(response.statusCode
                                                    .toString());
                                                debugPrint("문제 이미지 불러오기 오류 발생");
                                              }
                                            },
                                            child: SizedBox(
                                              height: 100,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(element["name"]),
                                                    Text(
                                                        "난이도 : ${element["level"]}")
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList()),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                      ),
                    )
                  ],
                );
              },
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

              final response = await http.get(
                url,
                headers: await sendCookieToBackend(),
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
