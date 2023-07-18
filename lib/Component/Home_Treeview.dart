import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';

import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Problem_List.dart';
import 'package:front_end/Component/Default/Cookie.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

FlyoutTarget HomeTreeView() {
  final flyoutcontroller = FlyoutController();
  final TextEditingController renameController = TextEditingController();
  TextEditingController textcontroller = TextEditingController();
  return FlyoutTarget(
    controller: flyoutcontroller,
    child: GetX<FolderController>(
      builder: (controller) {
        return TreeView(
          items: controller.firstFolders,
          onSecondaryTap: (item, details) {
            flyoutcontroller.showFlyout(
                position: details.globalPosition,
                builder: (context) {
                  return MenuFlyout(
                    items: [
                      MenuFlyoutItem(
                        text: const Text("폴더 삭제"),
                        onPressed: () async {
                          final url = Uri.parse(
                              'http://$HOST/api/data/delete_database');
                          final Map<String, dynamic> requestBody = {
                            "delete_database_id": item.value["id"]
                          };

                          final response = await http.post(
                            url,
                            headers: await sendCookieToBackend(),
                            body: jsonEncode(requestBody),
                          );
                          if (response.statusCode ~/ 100 == 2) {
                            if (item.value["parent"] != null) {
                              TreeViewItem deleteTargetParent = controller
                                  .totalfolders
                                  .firstWhere((element) =>
                                      item.value["parent"] ==
                                      element.value["id"]);
                              deleteTargetParent.children.remove(item);
                            } else {
                              controller.firstFolders
                                  .removeWhere((element) => item == element);
                            }
                            controller.firstFolders.refresh();
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
                        onPressed: () async {
                          Navigator.pop(context);
                          final textbox = TextBox(
                            controller: renameController,
                            highlightColor: Colors.transparent,
                          );
                          renameController.text = (item.value["name"]);

                          await flyoutcontroller.showFlyout(
                              position: details.globalPosition,
                              builder: (context) {
                                return FlyoutContent(
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  child: SizedBox(
                                    width: 150,
                                    height: 30,
                                    child: textbox,
                                  ),
                                );
                              });

                          if (renameController.text != "") {
                            final url = Uri.parse(
                                'http://$HOST/api/data/update_database_name');
                            final Map<String, dynamic> requestBody = {
                              "database_id": item.value["id"],
                              "new_database_folder_name": renameController.text
                            };

                            final response = await http.post(
                              url,
                              headers: await sendCookieToBackend(),
                              body: jsonEncode(requestBody),
                            );
                            if (response.statusCode ~/ 100 == 2) {
                              TreeViewItem newFolder =
                                  controller.makeFolderItem(
                                      renameController.text,
                                      item.value["id"],
                                      item.value["parent"]);
                              newFolder.children.addAll(item.children.toList());

                              controller.totalfolders.removeWhere((element) =>
                                  item.value["id"] == element.value["id"]);

                              controller.totalfolders.add(newFolder);
                              if (item.value["parent"] != null) {
                                TreeViewItem parentFolder = controller
                                    .totalfolders
                                    .firstWhere((element) =>
                                        item.value["parent"] ==
                                        element.value["id"]);

                                parentFolder.children.remove(item);
                                parentFolder.children.add(newFolder);
                              }

                              controller.firstFolders.refresh();
                            }
                          }
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
                                          final url = Uri.parse(
                                              'http://$HOST/api/data/create_database');
                                          final Map<String, dynamic>
                                              requestBody = {
                                            "name": textcontroller.text,
                                            "parent_id": item.value["id"]
                                          };

                                          final response = await http.post(
                                            url,
                                            headers:
                                                await sendCookieToBackend(),
                                            body: jsonEncode(requestBody),
                                          );

                                          if (response.statusCode ~/ 100 == 2) {
                                            final jsonResponse =
                                                jsonDecode(response.body);

                                            final int newFolderId =
                                                jsonResponse[
                                                        'inserted_database'][0]
                                                    ["id"];
                                            final int parentId = jsonResponse[
                                                    'inserted_database'][0]
                                                ["parent_id"];
                                            TreeViewItem newFolder =
                                                controller.makeFolderItem(
                                                    textcontroller.text,
                                                    newFolderId,
                                                    parentId);
                                            controller.totalfolders
                                                .add(newFolder);
                                            TreeViewItem parentFolder =
                                                controller.totalfolders
                                                    .firstWhere((element) =>
                                                        element.value["id"] ==
                                                        parentId);
                                            parentFolder.children
                                                .add(newFolder);

                                            controller.firstFolders.refresh();
                                            textcontroller.text = "";
                                            displayInfoBar(
                                              context,
                                              builder: (context, close) {
                                                return InfoBar(
                                                  severity:
                                                      InfoBarSeverity.success,
                                                  title:
                                                      const Text('폴더 만들기 성공'),
                                                  action: IconButton(
                                                    icon: const Icon(
                                                        FluentIcons.clear),
                                                    onPressed: close,
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            displayInfoBar(
                                              context,
                                              builder: (context, close) {
                                                return InfoBar(
                                                  severity:
                                                      InfoBarSeverity.warning,
                                                  title:
                                                      const Text('폴더 만들기 실패'),
                                                  action: IconButton(
                                                    icon: const Icon(
                                                        FluentIcons.clear),
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
          },
          onItemInvoked: (item, reason) async {
            if (reason == TreeViewItemInvokeReason.pressed) {
              //폴더 직속 문제들만 받아오기
              final problemUrl = Uri.parse(
                  'http://$HOST/api/data/problem/database/${item.value["id"]}');

              final response = await http.get(
                problemUrl,
                headers: await sendCookieToBackend(),
              );
              if (response.statusCode ~/ 100 == 2) {
                final jsonResponse = jsonDecode(response.body);

                final problems = jsonResponse['problem_list'];

                TabController tabController = Get.find<TabController>();
                tabController.isHomeScreen.value = false;
                DefaultTabBody generatedTab = DefaultTabBody(
                  workingSpace: Builder(
                    builder: (context) => ProblemList(
                      targetFolder: item,
                      folderName: item.value["name"],
                      problems: problems,
                    ),
                  ),
                );
                Tab newTab =
                    tabController.addTab(generatedTab, item.value["name"]);
                tabController.tabs.add(newTab);
                tabController.currentTabIndex.value =
                    tabController.tabs.length - 1;
              } else {
                debugPrint(response.statusCode.toString());
                debugPrint("폴더 직속 문제 받기 오류 발생");
              }
            }
          },
        );
      },
    ),
  );
}
