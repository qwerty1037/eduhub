import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/Group_TreeView_Controller.dart';
import 'package:http/http.dart' as http;

///폴더 삭제, 새폴더 만들기, 폴더 이름 바꾸기의 기능을 지원하는 위젯이다. FlyoutTarget내부의 하위 컴포넌트로 사용되어야 한다.
class GroupTreeView_MenuFlyout extends StatelessWidget {
  const GroupTreeView_MenuFlyout({
    super.key,
    required this.groupController,
    required this.item,
    required this.details,
    required this.reNameController,
    required this.newNameController,
    required this.flyoutController,
  });
  final GroupTreeViewController groupController;
  final TreeViewItem item;
  final TapDownDetails details;
  final TextEditingController reNameController;
  final TextEditingController newNameController;
  final FlyoutController flyoutController;

  @override
  Widget build(BuildContext context) {
    return MenuFlyout(
      items: [
        _menuFlyoutItemDeleteGroup(context, item, groupController),
        const MenuFlyoutSeparator(),
        _menuFlyoutItemRenameGroup(context, item, details, groupController),
        const MenuFlyoutSeparator(),
        _menuFlyoutItemNewGroup(context, item, groupController),
      ],
    );
  }

  /// MenuFlyoutItem that delete folder
  ///
  /// when clicked, http request to delete folder
  MenuFlyoutItem _menuFlyoutItemDeleteGroup(BuildContext context, TreeViewItem item, GroupTreeViewController groupController) {
    return MenuFlyoutItem(
      text: const Text("그룹 삭제"),
      onPressed: () async {
        final url = Uri.parse('https://$HOST/api/data/delete_group');
        final Map<String, dynamic> requestBody = {"delete_group_id": item.value["id"]};
        final response = await http.post(
          url,
          headers: await defaultHeader(httpContentType.json),
          body: jsonEncode(requestBody),
        );

        if (isHttpRequestSuccess(response)) {
          groupController.totalGroups.removeWhere((element) => item == element);
          groupController.totalGroups.refresh();
          displayInfoBar(
            context,
            builder: (context, close) {
              return InfoBar(
                severity: InfoBarSeverity.success,
                title: const Text('그룹 삭제 성공'),
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
                title: const Text('그룹 삭제 실패'),
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
  MenuFlyoutItem _menuFlyoutItemRenameGroup(context, item, details, controller) {
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
          final url = Uri.parse('https://$HOST/api/data/update_group_name');
          final Map<String, dynamic> requestBody = {"database_id": item.value["id"], "new_database_group_name": reNameController.text};
          final response = await http.post(
            url,
            headers: await defaultHeader(httpContentType.json),
            body: jsonEncode(requestBody),
          );

          if (isHttpRequestSuccess(response)) {
            TreeViewItem newFolder = controller.makeFolderItem(reNameController.text, item.value["id"], item.value["studentsId"]);
            //newFolder.children.addAll(item.children.toList());

            controller.totalFolders.removeWhere((element) => item.value["id"] == element.value["id"]);

            controller.totalFolders.add(newFolder);

            groupController.totalGroups.refresh();
          }
        }
      },
    );
  }

  /// MenuFlyoutItem that make new folder
  ///
  /// When clicked, create a window for naming the new folder. Then http request to create a new folder
  MenuFlyoutItem _menuFlyoutItemNewGroup(context, item, GroupTreeViewController controller) {
    return MenuFlyoutItem(
      text: const Text("새 그룹"),
      onPressed: () async {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) {
            return ContentDialog(
              title: const Text("새 그룹 이름을 정해주세요"),
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
                    final url = Uri.parse('https://$HOST/api/data/create_group');
                    final Map<String, dynamic> requestBody = {
                      "name": newNameController.text,
                    };

                    final response = await http.post(
                      url,
                      headers: await defaultHeader(httpContentType.json),
                      body: jsonEncode(requestBody),
                    );
                    print(response.statusCode);
                    if (isHttpRequestSuccess(response)) {
                      final jsonResponse = jsonDecode(response.body);

                      final int newFolderId = jsonResponse['inserted_database'][0]["id"];
                      TreeViewItem newGroup = controller.makeGroupItem(newNameController.text, newFolderId, null);
                      controller.totalGroups.add(newGroup);

                      groupController.totalGroups.refresh();
                      newNameController.text = "";
                      displayInfoBar(
                        context,
                        builder: (context, close) {
                          return InfoBar(
                            severity: InfoBarSeverity.success,
                            title: const Text('그룹 만들기 성공'),
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
                            title: const Text('그룹 만들기 실패'),
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
