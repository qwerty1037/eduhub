import 'package:fluent_ui/fluent_ui.dart';

import 'package:front_end/Controller/ExamController.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';

class ExamScreen extends StatelessWidget {
  ExamScreen({super.key});
  final examController = Get.put(ExamController(), tag: Get.find<TabController>().getTabKey());
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
              Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      // 시험지 저장소 관련 구현 후 복구. 일단은 시험지 만드는 것만
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // const Text("시험지 이름"),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // TextBox(
                      //   placeholder: "Empty",
                      //   controller: examController.examNameController,
                      // ),
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
                          FolderData addedFolder = FolderData(parent: data!["parent"], id: data["id"], name: data["name"]);
                          controller.folders.add(addedFolder);
                        }),
                        builder: (BuildContext context, List<Map<dynamic, dynamic>?> candidateData, List<dynamic> rejectedData) {
                          return Container(
                            color: Colors.grey[100],
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.2 - 0.5,
                            child: controller.folders.isEmpty
                                ? const Center(child: Text("폴더 드래그"))
                                : ListView.builder(
                                    shrinkWrap: false,
                                    itemCount: controller.folders.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final List<FolderData> dataList = controller.folders.toList();
                                      final FolderData item = dataList[index];
                                      if (index != controller.folders.length - 1) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[40],
                                              border: const Border(
                                                bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.3,
                                                ),
                                              )),
                                          child: ListTile(
                                            title: Text(item.name),
                                            trailing: IconButton(
                                              icon: const Icon(FluentIcons.chrome_close),
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
                                                  icon: const Icon(FluentIcons.chrome_close),
                                                  onPressed: () {
                                                    controller.folders.remove(item);
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                    },
                                  ),
                          );
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
                              child: Center(child: controller.isFirestRequest.value ? const Text("필터 재설정") : const Text("필터 설정 완료")),
                              onPressed: () {
                                //난이도 관련처리
                                if (controller.minlevelController.text != "" && controller.maxlevelController.text != "") {
                                  int minlevel = int.parse(controller.minlevelController.text);
                                  int maxlevel = int.parse(controller.maxlevelController.text);
                                  if (minlevel > maxlevel || minlevel < 1 || maxlevel > 5) {
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
                                    //서버에 조건 보내기, 서버에서 문제 개수와 문제 정보들 가져오기
                                    controller.isFirestRequest.value = true;
                                    controller.countController.text = controller.totalCount.value.toString();
                                  }
                                } else {
                                  //서버에 조건 보내기, 서버에서 문제 개수와 문제 정보들 가져오기
                                  controller.isFirestRequest.value = true;
                                  controller.countController.text = controller.totalCount.value.toString();
                                }
                              })),
                      controller.isFirestRequest.value
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
                                          controller.isRandom.value = true;
                                        }),
                                    RadioButton(
                                        content: const Text("직접 고르기"),
                                        checked: !controller.isRandom.value,
                                        onChanged: (checked) {
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
                                            int targetCount = int.parse(controller.countController.text);
                                            if (controller.totalCount.value < targetCount) {
                                              displayInfoBar(context, builder: (context, close) {
                                                return InfoBar(
                                                  title: const Text('오류 : '),
                                                  content: const Text('가능한 문제보다 많이 선택하였습니다'),
                                                  action: IconButton(
                                                    icon: const Icon(FluentIcons.clear),
                                                    onPressed: close,
                                                  ),
                                                  severity: InfoBarSeverity.error,
                                                );
                                              });
                                            } else {
                                              //랜덤시 서버 시험지 만들기 시험지 미리보기 ->, 직접 선택시 받은 문제 오른쪽에 띄워주기
                                              //오른쪽에서 문제 다 선택후 완료 -> 시험지 미리보기
                                              controller.isSettingFinished.value = true;
                                            }
                                          } else {
                                            //랜덤시 시험지 만들기, 직접 선택시 받은 문제 오른쪽에 띄워주기?
                                            controller.isSettingFinished.value = true;
                                          }
                                        }))
                              ],
                            )
                          : Container(),
                    ]),
                  )),
              Container(
                width: 0.5,
                height: MediaQuery.of(context).size.height,
                color: Get.find<TotalController>().isDark.value == true ? Colors.grey[130] : Colors.grey[50],
              ),
              Expanded(
                  flex: 4,
                  child: Container(
                    child: Center(
                      child: controller.isSettingFinished.value ? const Text("TODO: 문제 뽑기 만들기") : const Text("왼쪽 설정을 완료해주세요"),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
