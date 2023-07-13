import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Component/Folder.dart';
import 'package:front_end/Component/cookie.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/HomeScreen_Controller.dart';
import 'package:front_end/Controller/total.controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final FlyoutController _flyoutController = FlyoutController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    HomeScreenController homeScreenController =
        Get.find<HomeScreenController>();

    TotalController theme = Get.find<TotalController>();
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
              ToggleSwitch(
                checked: theme.isdark.value,
                onChanged: (value) {
                  theme.isdark.value = !theme.isdark.value;
                },
                content: theme.isdark.isTrue
                    ? const Text(
                        "어둡게",
                        style: TextStyle(color: DEFAULT_LIGHT_COLOR),
                      )
                    : const Text(
                        "밝은색",
                        style: TextStyle(color: DEFAULT_DARK_COLOR),
                      ),
              ),
              const SizedBox(
                width: 20,
              ),
              DropDownButton(
                  title: const Row(children: [
                    Icon(
                      FluentIcons.settings,
                      size: 15,
                    ),
                    Text(
                      " 설정",
                      style: TextStyle(fontSize: 12),
                    )
                  ]),
                  items: [
                    MenuFlyoutItem(text: const Text('내정보'), onPressed: () {}),
                    const MenuFlyoutSeparator(),
                    MenuFlyoutItem(text: const Text('결제'), onPressed: () {}),
                    const MenuFlyoutSeparator(),
                    MenuFlyoutItem(text: const Text('로그아웃'), onPressed: () {}),
                  ]),
              const SizedBox(
                width: 20,
              ),
              menuCommandBar(),
              const Spacer(),
              FlyoutTarget(
                controller: _flyoutController,
                child: Icon(
                  FluentIcons.status_circle_question_mark,
                  size: 40,
                  color: theme.isdark.isTrue
                      ? DEFAULT_LIGHT_COLOR
                      : DEFAULT_DARK_COLOR,
                ),
              )
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
                  color: const Color.fromARGB(30, 50, 49, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          color: Colors.yellow,
                          height: 30,
                          child: const Center(child: Text("프로필 들어갈자리"))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 30,
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
                      GetX<FolderController>(builder: (controller) {
                        return homeScreenController.isFolderEmpty.isTrue
                            ? NewFolderButton(
                                context, controller, homeScreenController)
                            : FolderTreeView(controller);
                      })
                    ],
                  ),
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

  Button NewFolderButton(BuildContext context,
      FolderController folderController, HomeScreenController controller) {
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
                          headers: await sendCookieToBackend(),
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

                          folderController.firstFolders.refresh();
                          controller.isFolderEmpty.value = false;
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

  Widget menuCommandBar() {
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
          onPressed: () {},
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
          onPressed: () {},
        ),
      ),
    ];

    return CommandBar(
      primaryItems: menuCommandBarItems,
      overflowBehavior: CommandBarOverflowBehavior.noWrap,
    );
  }
}
