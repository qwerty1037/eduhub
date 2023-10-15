import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:front_end/Component/Calendar.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Feedback_Overlay.dart';
import 'package:front_end/Component/Folder_Treeview_Explore.dart';
import 'package:front_end/Component/New_Folder_Button.dart';
import 'package:front_end/Component/Search_Bar_Overlay.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Screen/Exam.dart';
import 'package:front_end/Screen/Group_Management.dart';
import 'package:front_end/Screen/Group_Waiting_Screen.dart';
import 'package:front_end/Screen/Pdf_Viewer_Screen.dart';
import 'package:front_end/Screen/Tag_Management_Screen.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatelessWidget {
  final FlyoutController _flyoutController = FlyoutController();
  final TabController tabController;
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  FolderController folderController = Get.find<FolderController>();

  HomeScreen({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          //color: Colors.teal,
          child: Row(
            children: [
              menuCommandBar(context, homeScreenController),
              const Spacer(),
              questionMarkButton(flyoutController: _flyoutController)
            ],
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
                        color: Get.find<TotalController>().isDark.value == true
                            ? Colors.grey[130]
                            : Colors.grey[50],
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
                  color: Get.find<TotalController>().isDark.value == true
                      ? Colors.grey[150]
                      : Colors.grey[30],
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
                                    color: Get.find<TotalController>()
                                                .isDark
                                                .value ==
                                            true
                                        ? Colors.grey[130]
                                        : Colors.grey[50],
                                    width: 1,
                                  ),
                                )),
                                child: const HomeCalendar())),
                        const Expanded(
                            flex: 1,
                            child: Center(child: Text("연동 후 알림창 들어갈 부분")))
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
          message: "hwp, pdf 파일에서 문제 추출",
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
            Tab newTab = tabController.addTab(
                generatedTab, "문제 저장", const Icon(FluentIcons.save));

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
            Tab newTab = tabController.addTab(
                generatedTab, "시험지 만들기", const Icon(FluentIcons.questionnaire));
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
              workingSpace: GroupWaitingScreen(),
            );
            Tab newTab = tabController.addTab(
                generatedTab, "학생 관리", const Icon(FluentIcons.questionnaire));
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
            createHighlightOverlay(
                context: context,
                controller: Get.put(SearchScreenController(),
                    tag: tabController.getNewTabKey()),
                tabController: tabController);
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
            Tab newTab = tabController.addTab(
                generatedTab, "태그", const Icon(FluentIcons.tag));
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

SingleChildScrollView leftDashboard(HomeScreenController homeScreenController,
    BuildContext context, FolderController folderController) {
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
                  const Text("OOO님"),
                  GestureDetector(
                      child: const Icon(FluentIcons.settings),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ContentDialog(
                                title: const Center(child: Text("프로필 설정")),
                                content: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Text("닉네임 변경")),
                                    Text("OOO님 들어갈 자리")
                                  ],
                                ),
                                actions: [
                                  Button(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FilledButton(
                                      child: const Text('저장'),
                                      onPressed: () {
                                        Navigator.pop(context);
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
            GetBuilder<TotalController>(
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
          return homeScreenController.isFolderEmpty
              ? newFolderButton(context, folderController, homeScreenController)
              : FolderTreeViewExplore();
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
