import 'package:fluent_ui/fluent_ui.dart';
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
import 'package:front_end/Screen/Pdf_Viewer_Screen.dart';
import 'package:front_end/Screen/Tag_Management_Screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final FlyoutController _flyoutController = FlyoutController();
  final tabController = Get.find<TabController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    HomeScreenController homeScreenController =
        Get.find<HomeScreenController>();

    FolderController folderController = Get.find<FolderController>();
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          //color: Colors.teal,
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              menuCommandBar(context, homeScreenController),
              const Spacer(),
              questionMarkButton(flyoutController: _flyoutController)
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 78,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.black, width: 0.5),
                    ),
                  ),
                  child: leftDashboard(
                      homeScreenController, context, folderController),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: const Center(child: Text("최근 기록 페이지")),
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
          message: "Save your Pdf files!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.save),
          label: const Text("Save Pdf",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            tabController.isNewTab = true;
            DefaultTabBody generatedTab = DefaultTabBody(
              dashBoardType: DashBoardType.savePdf,
              workingSpace: const PdfViewerScreen(),
            );
            Tab newTab = tabController.addTab(generatedTab, "Save Pdf");

            tabController.tabs.add(newTab);
            tabController.isHomeScreen.value = false;
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
            tabController.isNewTab = false;
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Create Test!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("Create Test",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Manage your students!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("Student Management",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Search your problems!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.search),
          label: const Text("Search",
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
          message: "Make your tags!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.tag),
          label: const Text("Tags",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            tabController.isNewTab = true;
            tabController.isHomeScreen.value = false;
            DefaultTabBody generatedTab = DefaultTabBody(
              dashBoardType: DashBoardType.tagManagement,
              workingSpace: TagManagementScreen(),
            );
            Tab newTab = tabController.addTab(generatedTab, "Generate Tags");
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

Column leftDashboard(HomeScreenController homeScreenController,
    BuildContext context, FolderController folderController) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Center(
        child: FilledButton(
          child: const Text("로그아웃(프로필)"),
          onPressed: () async {
            homeScreenController.logout();
          },
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
                checked: controller.isDark,
                onChanged: (value) {
                  controller.isDark = value;
                  controller.update();
                },
              );
            },
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 40,
        color: const Color.fromARGB(100, 50, 49, 48),
        child: const Row(
          children: [
            Icon(
              FluentIcons.recent,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "최근 기록 페이지",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      GetBuilder<HomeScreenController>(builder: (controller) {
        return homeScreenController.isFolderEmpty
            ? newFolderButton(context, folderController, homeScreenController)
            : FolderTreeViewExplore();
      })
    ],
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
                    text: const Text("언어 변경"),
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
