import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/ScreenController/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

///시험지 폴더 삭제, 새폴더 만들기, 폴더 이름 바꾸기의 기능을 지원하는 위젯이다. FlyoutTarget내부의 하위 컴포넌트로 사용되어야 한다.
class ExamFolderMenuFlyout extends StatelessWidget {
  const ExamFolderMenuFlyout({
    super.key,
    required this.userDataController,
    required this.item,
    required this.details,
    required this.reNameController,
    required this.newNameController,
    required this.flyoutController,
  });
  final UserDataController userDataController;
  final TreeViewItem item;
  final TapDownDetails details;
  final TextEditingController reNameController;
  final TextEditingController newNameController;
  final FlyoutController flyoutController;

  @override
  Widget build(BuildContext context) {
    return MenuFlyout(
      items: [
        _menuFlyoutItemDeleteFolder(context, item, userDataController),
        const MenuFlyoutSeparator(),
        _menuFlyoutItemRenameFolder(context, item, details, userDataController),
        const MenuFlyoutSeparator(),
        _menuFlyoutItemNewFolder(context, item, userDataController),
      ],
    );
  }

  /// MenuFlyoutItem that delete folder
  ///
  /// when clicked, http request to delete folder
  MenuFlyoutItem _menuFlyoutItemDeleteFolder(BuildContext context, TreeViewItem item, UserDataController userDataController) {
    return MenuFlyoutItem(
      text: const Text("폴더 삭제"),
      onPressed: () async {
        final url = Uri.parse('https://$HOST/api/data/delete_exam_Database');
        final Map<String, dynamic> requestBody = {"delete_database_id": item.value["id"]};
        final response = await http.post(
          url,
          headers: await defaultHeader(httpContentType.json),
          body: jsonEncode(requestBody),
        );

        if (isHttpRequestSuccess(response)) {
          if (item.value["parent"] != null) {
            TreeViewItem deleteTargetParent = userDataController.allExamFolders.firstWhere((element) => item.value["parent"] == element.value["id"]);
            deleteTargetParent.children.remove(item);
          } else {
            userDataController.rootExamFolders.removeWhere((element) => item == element);
          }
          userDataController.rootExamFolders.refresh();
          if (userDataController.rootExamFolders.isEmpty) {
            Get.find<HomeScreenController>().isExamFolderEmpty = true;
          }
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
          controller: reNameController,
          highlightColor: Colors.transparent,
        );
        reNameController.text = (item.value["name"]);

        await flyoutController.showFlyout(
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

        if (reNameController.text != "") {
          final url = Uri.parse('https://$HOST/api/data/update_exam_database_name');
          final Map<String, dynamic> requestBody = {"database_id": item.value["id"], "new_database_folder_name": reNameController.text};
          final response = await http.post(
            url,
            headers: await defaultHeader(httpContentType.json),
            body: jsonEncode(requestBody),
          );

          if (isHttpRequestSuccess(response)) {
            TreeViewItem newFolder = controller.makeExamFolderItem(reNameController.text, item.value["id"], item.value["parent"]);
            newFolder.children.addAll(item.children.toList());

            controller.allExamFolders.removeWhere((element) => item.value["id"] == element.value["id"]);

            controller.allExamFolders.add(newFolder);
            if (item.value["parent"] != null) {
              TreeViewItem parentFolder = controller.allExamFolders.firstWhere((element) => item.value["parent"] == element.value["id"]);

              parentFolder.children.remove(item);
              parentFolder.children.add(newFolder);
            }

            userDataController.rootExamFolders.refresh();
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
                controller: newNameController,
              ),
              actions: [
                Button(
                  child: const Text("취소"),
                  onPressed: () {
                    Navigator.pop(context);
                    newNameController.text = "";
                  },
                ),
                FilledButton(
                  child: const Text('확인'),
                  onPressed: () async {
                    final url = Uri.parse('https://$HOST/api/data/create_exam_database');
                    final Map<String, dynamic> requestBody = {"name": newNameController.text, "parent_id": item.value["id"]};

                    final response = await http.post(
                      url,
                      headers: await defaultHeader(httpContentType.json),
                      body: jsonEncode(requestBody),
                    );
                    print(response.statusCode);
                    if (isHttpRequestSuccess(response)) {
                      final jsonResponse = jsonDecode(response.body);

                      final int newFolderId = jsonResponse['inserted_database'][0]["id"];
                      final int parentId = jsonResponse['inserted_database'][0]["parent_id"];
                      TreeViewItem newFolder = controller.makeExamFolderItem(newNameController.text, newFolderId, parentId);
                      controller.allExamFolders.add(newFolder);
                      TreeViewItem parentFolder = controller.allExamFolders.firstWhere((element) => element.value["id"] == parentId);
                      parentFolder.children.add(newFolder);

                      userDataController.rootExamFolders.refresh();
                      newNameController.text = "";
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
