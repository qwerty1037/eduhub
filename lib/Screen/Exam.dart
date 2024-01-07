import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:http/http.dart' as http;
import 'package:front_end/Controller/ExamController.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';
import 'package:front_end/Component/FolderData.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ExamScreen extends StatelessWidget {
  ExamScreen({super.key});
  final examController = Get.put(
      ExamController(Get.find<TabController>().getTabKey()),
      tag: Get.find<TabController>().getTabKey());
  String tagName = Get.find<TabController>().getTabKey();
  @override
  Widget build(BuildContext context) {
    return GetX<ExamController>(
      tag: tagName,
      builder: (controller) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              examFilter(controller: controller),
              Container(
                width: 0.5,
                height: MediaQuery.of(context).size.height,
                color: Get.find<TotalController>().isDark.value == true
                    ? Colors.grey[130]
                    : Colors.grey[50],
              ),
              Expanded(
                  flex: 4,
                  child: Center(
                    child: controller.isFilterFinished.value
                        ? (controller.isRandom.value
                            ? const Text("랜덤 선택 예정입니다")
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        padding: const EdgeInsets.all(30),
                                        child: Center(
                                            child: FilteredProblemList(
                                                controller))),
                                  ),
                                  Container(
                                    width: 0.5,
                                    height: MediaQuery.of(context).size.height,
                                    color: Get.find<TotalController>()
                                                .isDark
                                                .value ==
                                            true
                                        ? Colors.grey[130]
                                        : Colors.grey[50],
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                                "선택된 문제 개수: ${controller.selectedCount.value}개"),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Expanded(
                                                child: Container(
                                                    child: controller
                                                        .problemImageViewer
                                                        .value))
                                          ],
                                        ),
                                      ))
                                ],
                              ))
                        : const Text("왼쪽 설정을 완료해주세요"),
                  )),
            ],
          ),
        );
      },
    );
  }

  ListView FilteredProblemList(ExamController controller) {
    return ListView.builder(
      itemCount: controller.uniqueProblems.length,
      itemBuilder: (context, index) {
        var problemElement = controller.uniqueProblemsDetail[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Obx(() {
                  return Checkbox(
                    checked: controller.isProblemSelected[index],
                    onChanged: (value) {
                      if (value != null) {
                        controller.isProblemSelected[index] = value;
                        if (value) {
                          controller.problemToMakeExam
                              .add(controller.uniqueProblemsToList[index]);
                          controller.selectedCount.value++;
                        } else {
                          controller.problemToMakeExam
                              .remove(controller.uniqueProblemsToList[index]);
                          controller.selectedCount.value--;
                        }
                      }
                    },
                  );
                }),
                const SizedBox(
                  width: 10,
                ),
                Button(
                  onPressed: () async {
                    final url = Uri.parse(
                        'https://$HOST/api/data/problem-pdf/${problemElement["problem_string"].toString().substring(2, problemElement["problem_string"].length - 1)}');
                    final response = await http.get(
                      url,
                      headers: await defaultHeader(httpContentType.json),
                    );
                    if (response.statusCode ~/ 100 == 2) {
                      controller.problemImageViewer.value = Container(
                        child: SfPdfViewer.memory(
                          response.bodyBytes,
                        ),
                      );
                    } else {
                      debugPrint(response.statusCode.toString());
                      debugPrint("문제 이미지 불러오기 오류 발생");
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          problemElement["name"],
                        ),
                        Text(
                          "난이도 : ${problemElement["level"]}",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // 타일 사이의 간격을 조절할 수 있는 높이 추가
          ],
        );
      },
    );
  }
}

class examFilter extends StatelessWidget {
  examFilter({super.key, required this.controller});
  ExamController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            const Text("문제 범위"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "왼쪽에서 폴더 드래그",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "(드래그 안할시 전체 폴더)",
              style: TextStyle(fontSize: 12),
            ),
            DragTarget(
              onWillAccept: (Map<dynamic, dynamic>? data) {
                if (data != null) {
                  return true;
                } else {
                  return false;
                }
              },
              onAccept: ((Map<dynamic, dynamic>? data) {
                FolderData addedFolder = FolderData(
                    parent: data!["parent"],
                    id: data["id"],
                    name: data["name"]);
                controller.folders.add(addedFolder);
              }),
              builder: (BuildContext context,
                  List<Map<dynamic, dynamic>?> candidateData,
                  List<dynamic> rejectedData) {
                return Container(
                    color: Colors.grey[100],
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.2 - 0.5,
                    child: controller.folders.isEmpty
                        ? const Center(child: Text("폴더 드래그"))
                        : Obx(
                            () {
                              return ListView.builder(
                                shrinkWrap: false,
                                itemCount: controller.folders.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Obx(() {
                                  List<FolderData> dataList =
                                      controller.folders.toList();
                                  FolderData item = dataList[index];

                                  if (index != controller.folders.length - 1) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[40],
                                        border: const Border(
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(item.name),
                                        trailing: IconButton(
                                          icon: const Icon(
                                              FluentIcons.chrome_close),
                                          onPressed: () {
                                            controller.folders.remove(item);
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[40],
                                          ),
                                          child: ListTile(
                                            title: Text(item.name),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                  FluentIcons.chrome_close),
                                              onPressed: () {
                                                controller.folders.remove(item);
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                }),
                              );
                            },
                          ));
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                direction: Axis.horizontal,
                children: controller.selectedChipsList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("포함할 태그"),
            ),
            TextBox(
              controller: controller.tagController,
              onChanged: (String value) {
                controller.tagValue.value = value;
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                direction: Axis.horizontal,
                children: controller.filterChipsList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("난이도(1~5)"),
            ),
            controller.chooseLevel.value
                ? Column(
                    children: [
                      TextBox(
                        keyboardType: TextInputType.number,
                        controller: controller.minlevelController,
                      ),
                      const RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            "  ~  ",
                            style: TextStyle(fontSize: 15),
                          )),
                      TextBox(
                        keyboardType: TextInputType.number,
                        controller: controller.maxlevelController,
                      ),
                    ],
                  )
                : Button(
                    child: const Text("난이도 상관없음"),
                    onPressed: () {
                      controller.chooseLevel.value = true;
                    },
                  ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2 - 0.5,
                height: 50,
                child: Button(
                    child: Center(
                        child: controller.isFilterFinished.value
                            ? const Text("필터 재설정")
                            : const Text("필터 설정 완료")),
                    onPressed: () {
                      //난이도 관련처리
                      if (controller.minlevelController.text != "" &&
                          controller.maxlevelController.text != "") {
                        int minlevel =
                            int.parse(controller.minlevelController.text);
                        int maxlevel =
                            int.parse(controller.maxlevelController.text);
                        if (minlevel > maxlevel ||
                            minlevel < 1 ||
                            maxlevel > 5) {
                          displayInfoBar(context, builder: (context, close) {
                            return InfoBar(
                              title: const Text('오류 : '),
                              content: const Text('난이도 설정이 잘못되었습니다. '),
                              action: IconButton(
                                icon: const Icon(FluentIcons.clear),
                                onPressed: close,
                              ),
                              severity: InfoBarSeverity.error,
                            );
                          });
                        } else {
                          controller.getfilteredProblem();
                        }
                      } else {
                        controller.getfilteredProblem();
                      }
                    })),
            controller.isFilterFinished.value
                ? Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text("가능한 문제 개수 : ${controller.totalCount.value}개"),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("원하는 문제 개수"),
                      TextBox(
                        keyboardType: TextInputType.number,
                        controller: controller.countController,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("문제 추출 방식"),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RadioButton(
                              content: const Text("랜덤"),
                              checked: controller.isRandom.value,
                              onChanged: (checked) {
                                controller.problemToMakeExam.clear();
                                controller.isRandom.value = true;
                              }),
                          RadioButton(
                              content: const Text("직접 고르기"),
                              checked: !controller.isRandom.value,
                              onChanged: (checked) {
                                controller.problemToMakeExam.clear();
                                controller.isRandom.value = false;
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2 - 0.5,
                          height: 50,
                          child: Button(
                              child: const Center(child: Text("시험지 설정 완료")),
                              onPressed: () {
                                //난이도 관련처리
                                if (controller.countController.text != "") {
                                  int targetCount = int.parse(
                                      controller.countController.text);
                                  if (controller.totalCount.value <
                                      targetCount) {
                                    displayInfoBar(context,
                                        builder: (context, close) {
                                      return InfoBar(
                                        title: const Text('오류 : '),
                                        content: const Text(
                                            '원하는 문제 개수가 가능한 문제보다 많습니다'),
                                        action: IconButton(
                                          icon: const Icon(FluentIcons.clear),
                                          onPressed: close,
                                        ),
                                        severity: InfoBarSeverity.error,
                                      );
                                    });
                                  } else if (!controller.isRandom.value &&
                                      int.parse(controller
                                              .countController.text) !=
                                          controller.selectedCount.value) {
                                    displayInfoBar(context,
                                        builder: (context, close) {
                                      return InfoBar(
                                        title: const Text('오류 : '),
                                        content: const Text(
                                            '선택된 개수와 원하는 문제 개수가 다릅니다'),
                                        action: IconButton(
                                          icon: const Icon(FluentIcons.clear),
                                          onPressed: close,
                                        ),
                                        severity: InfoBarSeverity.error,
                                      );
                                    });
                                  } else if (Get.find<HomeScreenController>()
                                      .isExamFolderEmpty) {
                                    displayInfoBar(context,
                                        builder: (context, close) {
                                      return InfoBar(
                                        title: const Text('시험지 폴더가 없습니다 : '),
                                        content: const Text(
                                            '홈페이지에서 시험지 폴더를 먼저 만들어주세요'),
                                        action: IconButton(
                                          icon: const Icon(FluentIcons.clear),
                                          onPressed: close,
                                        ),
                                        severity: InfoBarSeverity.error,
                                      );
                                    });
                                  } else if (controller.isRandom.value) {
                                    var copyProblemInfo = controller
                                        .uniqueProblemsToList
                                        .toList();
                                    final random = Random();

                                    for (int i = 0;
                                        i <
                                            int.parse(controller
                                                .countController.text);
                                        i++) {
                                      int randomIndex = random
                                          .nextInt(copyProblemInfo.length);
                                      controller.problemToMakeExam
                                          .add(copyProblemInfo[randomIndex]);

                                      copyProblemInfo.removeAt(
                                          randomIndex); // 중복을 피하기 위해 해당 항목을 원본 리스트에서 제거
                                    }
                                    controller.makeExam(context);
                                  } else {
                                    controller.makeExam(context);
                                  }
                                } else {
                                  displayInfoBar(context,
                                      builder: (context, close) {
                                    return InfoBar(
                                      title: const Text('오류 : '),
                                      content: const Text('원하는 문제 개수를 입력해주세요'),
                                      action: IconButton(
                                        icon: const Icon(FluentIcons.clear),
                                        onPressed: close,
                                      ),
                                      severity: InfoBarSeverity.error,
                                    );
                                  });
                                }
                              }))
                    ],
                  )
                : Container(),
          ]),
        ));
  }
}
