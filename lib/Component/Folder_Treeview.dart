import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/Cookie.dart';

import 'package:front_end/Component/HttpConfig.dart';
import 'package:front_end/Component/Problem_List.dart';

import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:http/http.dart' as http;

class FolderTreeView extends StatelessWidget {
  FolderTreeView(this.controller, this.tagName, {super.key});

  FolderController controller;
  String tagName;
  final flyoutcontroller = FlyoutController();
  final TextEditingController textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: flyoutcontroller,
      child: TreeView(
        onSecondaryTap: (item, details) {
          showMenuFlyout(item);
        },
        onItemInvoked: (item, reason) async {
          if (reason == TreeViewItemInvokeReason.pressed) {
            await controller.makeProblemListInCurrentTab(item, tagName);
          }
        },
        items: controller.firstFolders,
      ),
    );
  }

  Future<dynamic> showMenuFlyout(TreeViewItem item) {
    return flyoutcontroller.showFlyout(builder: (context) {
      return MenuFlyout(
        items: [
          MenuFlyoutItem(
            text: const Text("폴더 삭제"),
            onPressed: () async {
              final url = Uri.parse('http://$HOST/api/data/delete_database');
              final Map<String, dynamic> requestBody = {"delete_database_id": item.value["id"]};
              final response = await http.post(
                url,
                headers: await defaultHeader(httpContentType.json),
                body: jsonEncode(requestBody),
              );
              if (response.statusCode ~/ 100 == 2) {
                if (item.value["parent"] != null) {
                  TreeViewItem deleteTargetParent = controller.totalfolders.firstWhere((element) => item.value["parent"] == element.value["id"]);
                  deleteTargetParent.children.remove(item);
                  TreeViewItem deleteTarget = controller.totalfolders.firstWhere((element) => item == element);
                } else {
                  controller.firstFolders.removeWhere((element) => item == element);
                }
                controller.update();
                displayInfoBar(
                  context,
                  builder: (context, close) {
                    return InfoBar(
                      severity: InfoBarSeverity.success,
                      title: const Text('폴더 삭제 성공'),
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
                      title: const Text('폴더 삭제 실패'),
                      action: IconButton(
                        icon: const Icon(FluentIcons.clear),
                        onPressed: close,
                      ),
                    );
                  },
                );
              }
              Navigator.pop(context);
            },
          ),
          const MenuFlyoutSeparator(),
          MenuFlyoutItem(
            text: const Text("이름 바꾸기"),
            onPressed: () {
              //추가할 부분, 폴더 renaming관련 백엔드와 협업 후 기능 구현
            },
          ),
          const MenuFlyoutSeparator(),
          MenuFlyoutItem(
              text: const Text("새폴더"),
              onPressed: () async {
                Navigator.pop(context);
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
                              final url = Uri.parse('http://$HOST/api/data/create_database');
                              final Map<String, dynamic> requestBody = {"name": textcontroller.text, "parent_id": item.value["id"]};

                              final response = await http.post(
                                url,
                                headers: await defaultHeader(httpContentType.json),
                                body: jsonEncode(requestBody),
                              );

                              if (response.statusCode ~/ 100 == 2) {
                                final jsonResponse = jsonDecode(response.body);
                                debugPrint(jsonResponse.toString());
                                final int newFolderId = jsonResponse['inserted_database'][0]["id"];
                                final int parentId = jsonResponse['inserted_database'][0]["parent_id"];
                                TreeViewItem newFolder = controller.makeFolderItem(textcontroller.text, newFolderId, parentId);
                                controller.totalfolders.add(newFolder);
                                TreeViewItem parentFolder = controller.totalfolders.firstWhere((element) => element.value["id"] == parentId);
                                parentFolder.children.add(newFolder);

                                controller.update();
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
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              }),
        ],
      );
    });
  }
}
