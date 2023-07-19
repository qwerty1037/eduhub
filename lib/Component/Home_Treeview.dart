import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/Cookie.dart';
import 'package:front_end/Component/HttpConfig.dart';
import 'package:front_end/Component/Problem_List.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeTreeView extends StatelessWidget {
  HomeTreeView({super.key});

  final flyoutcontroller = FlyoutController();
  final TextEditingController renameController = TextEditingController();
  TextEditingController textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: flyoutcontroller,
      child: GetBuilder<FolderController>(
        builder: (folderController) {
          return TreeView(
            items: folderController.firstFolders,
            onSecondaryTap: (item, details) {
              flyoutcontroller.showFlyout(
                position: details.globalPosition,
                builder: (context) {
                  return MenuFlyout(
                    items: [
                      _menuFlyoutItemDeleteFolder(context, item, folderController),
                      const MenuFlyoutSeparator(),
                      _menuFlyoutItemRenameFolder(context, item, details, folderController),
                      const MenuFlyoutSeparator(),
                      _menuFlyoutItemNewFolder(context, item, folderController),
                    ],
                  );
                },
              );
            },
            onItemInvoked: (item, reason) async {
              if (reason == TreeViewItemInvokeReason.pressed) {
                //폴더 직속 문제들만 받아오기
                await folderController.makeProblemListInNewTab(item);
              }
            },
          );
        },
      ),
    );
  }

  /// MenuFlyoutItem that delete folder
  ///
  /// when clicked, http request to delete folder
  MenuFlyoutItem _menuFlyoutItemDeleteFolder(context, item, controller) {
    return MenuFlyoutItem(
      text: const Text("폴더 삭제"),
      onPressed: () async {
        final url = Uri.parse('http://$HOST/api/data/delete_database');
        final Map<String, dynamic> requestBody = {"delete_database_id": item.value["id"]};
        final response = await http.post(
          url,
          headers: await defaultHeader(httpContentType.json),
          body: jsonEncode(requestBody),
        );

        if (isHttpRequestSuccess(response)) {
          if (item.value["parent"] != null) {
            TreeViewItem deleteTargetParent = controller.totalfolders.firstWhere((element) => item.value["parent"] == element.value["id"]);
            deleteTargetParent.children.remove(item);
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
        }

        if (isHttpRequestFailure(response)) {
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
    );
  }

  /// MenuFlyoutItem that rename folder
  ///
  /// when clicked, http request to rename folder
  MenuFlyoutItem _menuFlyoutItemRenameFolder(context, item, details, controller) {
    return MenuFlyoutItem(
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
          },
        );

        if (renameController.text != "") {
          final url = Uri.parse('http://$HOST/api/data/update_database_name');
          final Map<String, dynamic> requestBody = {"database_id": item.value["id"], "new_database_folder_name": renameController.text};
          final response = await http.post(
            url,
            headers: await defaultHeader(httpContentType.json),
            body: jsonEncode(requestBody),
          );

          if (isHttpRequestSuccess(response)) {
            TreeViewItem newFolder = controller.makeFolderItem(renameController.text, item.value["id"], item.value["parent"]);
            newFolder.children.addAll(item.children.toList());

            controller.totalfolders.removeWhere((element) => item.value["id"] == element.value["id"]);

            controller.totalfolders.add(newFolder);
            if (item.value["parent"] != null) {
              TreeViewItem parentFolder = controller.totalfolders.firstWhere((element) => item.value["parent"] == element.value["id"]);

              parentFolder.children.remove(item);
              parentFolder.children.add(newFolder);
            }

            controller.update();
          }
        }
      },
    );
  }

  /// MenuFlyoutItem that make new folder
  ///
  /// When clicked, create a window for naming the new folder. Then http request to create a new folder
  MenuFlyoutItem _menuFlyoutItemNewFolder(context, item, controller) {
    return MenuFlyoutItem(
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
                      headers: await sendCookieToBackend(),
                      body: jsonEncode(requestBody),
                    );

                    if (isHttpRequestSuccess(response)) {
                      final jsonResponse = jsonDecode(response.body);

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
                    }

                    if (isHttpRequestFailure(response)) {
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
          },
        );
      },
    );
  }
}
