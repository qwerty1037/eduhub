import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Folder_Treeview_Explore.dart';
import 'package:front_end/Component/New_Folder_Button.dart';
import 'package:front_end/Component/Search_Bar_Overlay.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Screen/Pdf_Viewer_Screen.dart';
import 'package:front_end/Screen/Tag_Management_Screen.dart';
import 'package:get/get.dart';

///새로운 탭이 만들어질때 제작되는 틀. workingSpace 부분에 위젯을 넣음으로써 작업창 부분 초기화가 가능하다.
class DefaultTabBody extends StatelessWidget {
  DefaultTabBody({
    super.key,
    required this.dashBoardType,
    this.workingSpace,
  }) {
    tagName = tabController.getNewTabKey();
  }
  final DashBoardType dashBoardType;
  final Widget? workingSpace;
  final TabController tabController = Get.find<TabController>();

  late final String tagName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Get.putAsync<DefaultTabBodyController>(() async {
          return DefaultTabBodyController(tagName, dashBoardType, workingSpace);
        }, tag: tagName),
        builder: ((context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return GetX<DefaultTabBodyController>(
              tag: tagName,
              builder: (controller) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      //color: FluentTheme.of(context).acrylicBackgroundColor,
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
                            decoration: const BoxDecoration(border: Border(left: BorderSide(color: Colors.black, width: 0.5))),
                            width: MediaQuery.of(context).size.width / 6 * 5,
                            child: controller.workingSpaceWidget.value,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  //color: Colors.teal,
                  child: fakeScreen(),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                          child: Get.find<HomeScreenController>().isFolderEmpty
                              ? newFolderButton(context, Get.find<FolderController>(), Get.find<HomeScreenController>())
                              : FolderTreeViewExplore(
                                  tagName: tagName,
                                ),
                        ),
                      ),
                      Container(
                          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Colors.black, width: 0.5))),
                          width: MediaQuery.of(context).size.width / 6 * 5,
                          child: const SizedBox())
                    ],
                  ),
                ),
              ],
            );
          }
        }));
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
          icon: const Icon(FluentIcons.page),
          label: const Text("시험지",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
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
          onPressed: () {},
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

  Center fakeScreen() {
    final fakeItems = <CommandBarItem>[
      CommandBarBuilderItem(
        builder: (context, mode, widget) => widget,
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.save),
          label: const Text("문제 저장",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) {
          return widget;
        },
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("시험지",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) {
          return widget;
        },
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("학생",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => widget,
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.search),
          label: const Text("검색",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) {
          return widget;
        },
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.tag),
          label: const Text("태그",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
    ];
    return Center(
      child: CommandBar(
        primaryItems: fakeItems,
        overflowBehavior: CommandBarOverflowBehavior.noWrap,
      ),
    );
  }
}
