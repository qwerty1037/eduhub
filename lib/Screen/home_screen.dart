import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:front_end/Component/calendar.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Component/exam_folder_treeview.dart';
import 'package:front_end/Component/feedback_overlay.dart';
import 'package:front_end/Component/folder_treeview_explore.dart';
import 'package:front_end/Component/Search_Bar_Overlay.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Component/Default/default_tab_body.dart';
import 'package:front_end/Controller/user_desktop_controller.dart';
import 'package:front_end/Screen/Exam.dart';
import 'package:front_end/Screen/group_waiting_screen.dart';
import 'package:front_end/Screen/Pdf_Viewer_Screen.dart';
import 'package:front_end/Screen/Tag_Management_Screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  final FlyoutController _flyoutController = FlyoutController();
  final TabController tabController;
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  UserDataController folderController = Get.find<UserDataController>();

  HomeScreen({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Row(
            children: [menuCommandBar(context, homeScreenController), const Spacer(), questionMarkButton(flyoutController: _flyoutController)],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Get.find<UserDesktopController>().isDark.value == true ? Colors.grey[130] : Colors.grey[50],
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: leftDashboard(
                      homeScreenController,
                      context,
                      folderController,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  color: Get.find<UserDesktopController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
                  child: m.Scaffold(
                    appBar: null,
                    body: SingleChildScrollView(
                      child: Row(children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  right: BorderSide(
                                    color: Get.find<UserDesktopController>().isDark.value == true ? Colors.grey[130] : Colors.grey[50],
                                    width: 1,
                                  ),
                                )),
                                child: const HomeCalendar())),
                        const Expanded(flex: 1, child: Center(child: Text("연동 후 알림창 들어갈 부분")))
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget menuCommandBar(context, controller) {
    final menuCommandBarItems = <CommandBarItem>[
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "pdf 파일에서 문제 추출",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.save),
          label: const Text("문제 저장",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            tabController.isNewTab = true;
            DefaultTabBody generatedTab = DefaultTabBody(
              dashBoardType: DashBoardType.savePdf,
              workingSpace: const PdfViewerScreen(),
            );
            Tab newTab = tabController.addTab(generatedTab, "문제 저장", const Icon(FluentIcons.save));

            tabController.tabs.add(newTab);
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
            tabController.isNewTab = false;
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "시험지 만들기",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.questionnaire),
          label: const Text("시험지",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            tabController.isNewTab = true;
            DefaultTabBody generatedTab = DefaultTabBody(
              dashBoardType: DashBoardType.exam,
              workingSpace: ExamScreen(),
            );
            Tab newTab = tabController.addTab(generatedTab, "시험지 만들기", const Icon(FluentIcons.questionnaire));
            tabController.tabs.add(newTab);
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
            tabController.isNewTab = false;
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "학생 관리",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("학생",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            tabController.isNewTab = true;
            DefaultTabBody generatedTab = DefaultTabBody(
              dashBoardType: DashBoardType.group,
              workingSpace: const GroupWaitingScreen(),
            );
            Tab newTab = tabController.addTab(generatedTab, "학생 관리", const Icon(FluentIcons.questionnaire));
            tabController.tabs.add(newTab);
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
            tabController.isNewTab = false;
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "문제 검색",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.search),
          label: const Text("검색",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            createHighlightOverlay(context: context, controller: Get.put(SearchScreenController(), tag: tabController.getNewTabKey()), tabController: tabController);
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "태그 만들기",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.tag),
          label: const Text("태그",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            tabController.isNewTab = true;

            DefaultTabBody generatedTab = DefaultTabBody(
              dashBoardType: DashBoardType.tagManagement,
              workingSpace: TagManagementScreen(),
            );
            Tab newTab = tabController.addTab(generatedTab, "태그", const Icon(FluentIcons.tag));
            tabController.tabs.add(newTab);
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
            tabController.isNewTab = false;
          },
        ),
      ),
    ];

    return CommandBar(
      primaryItems: menuCommandBarItems,
      overflowBehavior: CommandBarOverflowBehavior.noWrap,
    );
  }
}

SingleChildScrollView leftDashboard(HomeScreenController homeScreenController, BuildContext context, UserDataController folderController) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(folderController.nickName.value),
                  GestureDetector(
                      child: const Icon(FluentIcons.settings),
                      onTap: () {
                        final nickNameController = TextEditingController();
                        nickNameController.text = folderController.nickName.value;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ContentDialog(
                                title: const Center(child: Text("닉네임 변경")),
                                content: Container(
                                    child: TextBox(
                                  controller: nickNameController,
                                )),
                                actions: [
                                  Button(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FilledButton(
                                      child: const Text('변경하기'),
                                      onPressed: () async {
                                        //TODO 닉네임 변경
                                        final url = Uri.parse('https://$HOST/api/data/update_nickname');
                                        final Map<String, dynamic> requestBody = {
                                          "user_nickname": nickNameController.text,
                                        };
                                        final headers = {"Content-type": "application/json"};

                                        final response = await http.post(
                                          url,
                                          headers: headers,
                                          body: jsonEncode(requestBody),
                                        );
                                        if (isHttpRequestSuccess(response)) {
                                          folderController.nickName.value = nickNameController.text;
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          displayInfoBar(context, builder: (context, close) {
                                            return InfoBar(
                                              title: const Text("닉네임 변경 실패:"),
                                              content: const Text("닉네임 변경에 실패했습니다"),
                                              action: IconButton(
                                                icon: const Icon(FluentIcons.clear),
                                                onPressed: close,
                                              ),
                                              severity: InfoBarSeverity.error,
                                            );
                                          });
                                        }
                                      }),
                                ],
                              );
                            });
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                child: const Text("로그아웃"),
                onPressed: () async {
                  homeScreenController.logout();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("다크 모드"),
            GetBuilder<UserDesktopController>(
              builder: (controller) {
                return ToggleSwitch(
                  checked: controller.isDark.value,
                  onChanged: (value) {
                    controller.isDark.value = value;
                    controller.update();
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        GetBuilder<HomeScreenController>(builder: (controller) {
          return FolderTreeViewExplore();
        }),
        const SizedBox(height: 20),
        GetBuilder<HomeScreenController>(builder: (controller) {
          return ExamFolderTreeView();
        })
      ],
    ),
  );
}

class questionMarkButton extends StatelessWidget {
  const questionMarkButton({
    super.key,
    required FlyoutController flyoutController,
  }) : _flyoutController = flyoutController;

  final FlyoutController _flyoutController;

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: _flyoutController,
      child: IconButton(
        icon: const Icon(
          FluentIcons.status_circle_question_mark,
          size: 30,
        ),
        onPressed: () {
          _flyoutController.showFlyout(
            builder: ((context) {
              return MenuFlyout(
                items: [
                  MenuFlyoutItem(
                    text: const Text("유튜브로 사용법 보기"),
                    onPressed: () {},
                  ),
                  const MenuFlyoutSeparator(),
                  MenuFlyoutItem(
                    text: const Text("평가 및 건의"),
                    onPressed: () {
                      createFeedbackOverlay(context: context);
                    },
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
