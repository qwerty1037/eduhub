import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/search_bar_overlay.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:front_end/Controller/search_controller.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:front_end/Controller/user_desktop_controller.dart';
import 'package:front_end/Screen/exam.dart';
import 'package:front_end/Screen/group_waiting_screen.dart';
import 'package:front_end/Screen/pdf_viewer_screen.dart';
import 'package:front_end/Screen/tag_management_screen.dart';
import 'package:get/get.dart';

///새로운 탭이 만들어질때 제작되는 틀. workingSpace 부분에 위젯을 넣음으로써 작업창 부분 초기화가 가능하다.
class DefaultTabBody extends StatelessWidget {
  DefaultTabBody({
    super.key,
    required this.dashBoardType,
    this.workingSpace,
  }) {
    tagName = tabController.getNewTabKey();
    Get.put(DefaultTabBodyController(tagName, dashBoardType, workingSpace), tag: tagName);
  }
  final DashBoardType dashBoardType;
  final Widget? workingSpace;
  final FluentTabController tabController = Get.find<FluentTabController>();

  late final String tagName;

  @override
  Widget build(BuildContext context) {
    return GetX<DefaultTabBodyController>(
      tag: tagName,
      builder: (controller) {
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: topCommandBar(controller, context),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                      child: controller.dashBoard.value,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Get.find<UserDesktopController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
                      border: Border(
                        left: BorderSide(
                          color: Get.find<UserDesktopController>().isDark.value == true ? Colors.grey[130] : Colors.grey[50],
                          width: 1,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width / 6 * 5,
                    child: controller.workingSpaceWidget.value,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Center topCommandBar(DefaultTabBodyController controller, BuildContext context) {
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
          onPressed: () async {
            await controller.deleteWorkingSpaceController();
            controller.changeWorkingSpace(
              const PdfViewerScreen(),
            );
            controller.dashBoard.value = controller.makeDashBoard(DashBoardType.savePdf);
            Tab currentTab = tabController.tabs[tabController.currentTabIndex.value];
            tabController.renameTab(currentTab, "문제 저장", const Icon(FluentIcons.save));
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
          onPressed: () async {
            await controller.deleteWorkingSpaceController();
            controller.changeWorkingSpace(
              ExamScreen(),
            );
            controller.dashBoard.value = controller.makeDashBoard(DashBoardType.exam);
            Tab currentTab = tabController.tabs[tabController.currentTabIndex.value];
            tabController.renameTab(currentTab, "시험지 만들기", const Icon(FluentIcons.questionnaire));
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
          onPressed: () async {
            await controller.deleteWorkingSpaceController();
            controller.changeWorkingSpace(
              const GroupWaitingScreen(),
            );
            controller.dashBoard.value = controller.makeDashBoard(DashBoardType.group);
            Tab currentTab = tabController.tabs[tabController.currentTabIndex.value];
            tabController.renameTab(currentTab, "학생 관리", const Icon(FluentIcons.questionnaire));
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
          onPressed: () async {
            createHighlightOverlay(context: context, controller: Get.put(SearchScreenController(), tag: controller.tagName), tabController: tabController);

            controller.dashBoard.value = controller.makeDashBoard(DashBoardType.search);
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
          onPressed: () async {
            await controller.deleteWorkingSpaceController();
            controller.changeWorkingSpace(TagManagementScreen());
            controller.dashBoard.value = controller.makeDashBoard(DashBoardType.tagManagement);
            Tab currentTab = tabController.tabs[tabController.currentTabIndex.value];
            tabController.renameTab(currentTab, "태그", const Icon(FluentIcons.tag));
          },
        ),
      ),
    ];

    return Center(
      child: CommandBar(
        primaryItems: menuCommandBarItems,
        overflowBehavior: CommandBarOverflowBehavior.noWrap,
      ),
    );
  }
}
