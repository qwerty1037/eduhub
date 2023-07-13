import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Component/cookie.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:http/http.dart' as http;

TreeView FolderTreeView(FolderController controller) {
  final flyoutcontroller = FlyoutController();
  final TextEditingController textcontroller = TextEditingController();
  return TreeView(
    onSecondaryTap: (item, details) {
      flyoutcontroller.showFlyout(builder: (context) {
        return MenuFlyout(
          items: [
            MenuFlyoutItem(
              text: const Text("폴더 삭제"),
              onPressed: () async {
                Navigator.pop(context);
                final url = Uri.parse('http://$HOST/api/data/delete_database');
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
                    TreeViewItem deleteTargetParent = controller.totalfolders
                        .firstWhere((element) =>
                            item.value["parent"] == element.value["id"]);
                    deleteTargetParent.children.remove(item);
                    TreeViewItem deleteTarget = controller.totalfolders
                        .firstWhere((element) => item == element);
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
                                //추후 백엔드에서 받은뒤, 중앙 인자값 변경 및 뒤 순서로 미루기
                                Navigator.pop(context);

                                TreeViewItem newFolder =
                                    controller.makeFolderItem(
                                        textcontroller.text,
                                        555,
                                        item.value["id"]);
                                item.children.add(newFolder);
                                controller.totalfolders.add(newFolder);
                                item.expanded = true;

                                controller.firstFolders.refresh();

                                final url = Uri.parse(
                                    'http://$HOST/api/data/create_database');
                                final Map<String, dynamic> requestBody = {
                                  "name": textcontroller.text,
                                  "parent_id": item.value["id"]
                                };
                                textcontroller.text = "";
                                final response = await http.post(
                                  url,
                                  headers: await sendCookieToBackend(),
                                  body: jsonEncode(requestBody),
                                );

                                if (response.statusCode == 204) {
                                  //수정해야함. 백엔드로부터 새로만든 폴더 id 받아야함.
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
                }),
          ],
        );
      });
    },
    onItemInvoked: (item, reason) async {
      //클릭했을 때 넣을 함수 추가

      controller.droptest.value = item.value["id"];
    },
    items: controller.firstFolders,
  );
}
