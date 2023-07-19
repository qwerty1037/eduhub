import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Feedback_Overlay.dart';
import 'package:front_end/Component/Home_Treeview.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Component/Search_Bar_OverLay.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Screen/Pdf_Viewer_Screen.dart';
import 'package:front_end/Screen/Tag_Management_Screen.dart';
import 'package:http/http.dart' as http;
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
        Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          color: Colors.teal,
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
                  color: Colors.white,
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
            DefaultTabBody generatedTab =
                DefaultTabBody(workingSpace: const PdfViewerScreen());
            Tab newTab = tabController.addTab(generatedTab, "Save Pdf");

            tabController.tabs.add(newTab);
            tabController.isHomeScreen.value = false;
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
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
                    tag: tabController.getTabKey()),
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
            tabController.isHomeScreen.value = false;
            DefaultTabBody generatedTab =
                DefaultTabBody(workingSpace: TagManagementScreen());
            Tab newTab = tabController.addTab(generatedTab, "Generate Tags");
            tabController.tabs.add(newTab);
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
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
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        color: Colors.yellow,
        height: 70,
        child: Center(
          child: Button(
            child: const Text("로그아웃(프로필)"),
            onPressed: () async {
              homeScreenController.logout();
            },
          ),
        ),
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
            : HomeTreeView();
      })
    ],
  );
}

Button newFolderButton(BuildContext context, FolderController folderController,
    HomeScreenController controller) {
  return Button(
      child: const Text("새폴더 만들기"),
      onPressed: () async {
        TextEditingController textcontroller = TextEditingController();
        await showDialog(
            context: context,
            builder: (context) {
              return ContentDialog(
                title: const Text("새폴더 이름을 정해주세요"),
                content: TextBox(
                  highlightColor: Colors.transparent,
                  controller: textcontroller,
                ),
                actions: [
                  Button(
                    child: const Text("취소"),
                    onPressed: () {
                      Navigator.pop(context);
                      textcontroller.text = "";
                    },
                  ),
                  FilledButton(
                    child: const Text('확인'),
                    onPressed: () async {
                      Navigator.pop(context);

                      final url =
                          Uri.parse('http://$HOST/api/data/create_database');
                      final Map<String, dynamic> requestBody = {
                        "name": textcontroller.text,
                        "parent_id": null
                      };

                      final response = await http.post(
                        url,
                        headers: await defaultHeader(httpContentType.json),
                        body: jsonEncode(requestBody),
                      );

                      if (response.statusCode ~/ 100 == 2) {
                        final jsonResponse = jsonDecode(response.body);
                        debugPrint(jsonResponse.toString());
                        final int newFolderId =
                            jsonResponse['inserted_database'][0]["id"];

                        TreeViewItem newFolder =
                            folderController.makeFolderItem(
                                textcontroller.text, newFolderId, null);
                        folderController.totalfolders.add(newFolder);
                        folderController.firstFolders.add(newFolder);
                        folderController.update();
                        controller.isFolderEmpty = false;
                        textcontroller.text = "";
                        displayInfoBar(
                          context,
                          builder: (context, close) {
                            return InfoBar(
                              severity: InfoBarSeverity.success,
                              title: const Text('폴더 만들기 성공'),
                              action: IconButton(
                                icon: const Icon(FluentIcons.clear),
                                onPressed: close,
                              ),
                            );
                          },
                        );
                      } else {
                        debugPrint(response.statusCode.toString());
                        displayInfoBar(
                          context,
                          builder: (context, close) {
                            return InfoBar(
                              severity: InfoBarSeverity.warning,
                              title: const Text('폴더 만들기 실패'),
                              action: IconButton(
                                icon: const Icon(FluentIcons.clear),
                                onPressed: close,
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              );
            });
      });
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
          color: DEFAULT_DARK_COLOR,
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
                    text: const Text("피드백 보내기"),
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
