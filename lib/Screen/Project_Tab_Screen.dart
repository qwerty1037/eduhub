import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Controller/Project_Tab_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProjectTabScreen extends StatelessWidget {
  ProjectTabScreen({super.key});
  final _flyoutcontroller = FlyoutController();
  final TextEditingController _textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Get.put(ProjectTabController());

    return GetX<ProjectTabController>(
      builder: (controller) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: FlyoutTarget(
                controller: _flyoutcontroller,
                child: TreeView(
                  onSecondaryTap: (item, details) {
                    const storage = FlutterSecureStorage();
                    _flyoutcontroller.showFlyout(builder: (context) {
                      return MenuFlyout(
                        items: [
                          MenuFlyoutItem(
                            text: const Text("폴더 삭제"),
                            onPressed: () async {
                              //삭제할 부분, 뒷부분에 있으며 성능 확인을 위해 놔둠.
                              if (item.value["parent"] != null) {
                                Navigator.pop(context);
                                TreeViewItem deleteTargetParent = controller
                                    .totalfolders
                                    .firstWhere((element) =>
                                        item.value["parent"] ==
                                        element.value["id"]);
                                deleteTargetParent.children.remove(item);
                                TreeViewItem deleteTarget = controller
                                    .totalfolders
                                    .firstWhere((element) => item == element);
                              } else {
                                controller.firstFolders
                                    .removeWhere((element) => item == element);
                              }
                              controller.firstFolders.refresh();
                              final url =
                                  Uri.parse('http://$HOST/delete_database');
                              final Map<String, dynamic> requestBody = {
                                "uid": await storage.read(key: "uid"),
                                "access_token":
                                    await storage.read(key: "access_token"),
                                "refresh_token":
                                    await storage.read(key: "refresh_token"),
                                "delete_database_id": item.value["id"]
                              };
                              final headers = {
                                "Content-type": "application/json"
                              };

                              final response = await http.post(
                                url,
                                headers: headers,
                                body: jsonEncode(requestBody),
                              );
                              if (response.statusCode == 200) {
                                if (item.value["parent"] != null) {
                                  TreeViewItem deleteTargetParent = controller
                                      .totalfolders
                                      .firstWhere((element) =>
                                          item.value["parent"] ==
                                          element.value["id"]);
                                  deleteTargetParent.children.remove(item);
                                  TreeViewItem deleteTarget = controller
                                      .totalfolders
                                      .firstWhere((element) => item == element);
                                } else {
                                  controller.firstFolders.removeWhere(
                                      (element) => item == element);
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
                                          controller: _textcontroller,
                                        ),
                                        actions: [
                                          Button(
                                            child: const Text("취소"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FilledButton(
                                            child: const Text('확인'),
                                            onPressed: () async {
                                              //추후 백엔드에서 받은뒤, 중앙 인자값 변경 및 뒤 순서로 미루기
                                              Navigator.pop(context);
                                              TreeViewItem newFolder =
                                                  controller.makeFolderItem(
                                                      _textcontroller.text,
                                                      555,
                                                      item.value["id"]);
                                              item.children.add(newFolder);
                                              controller.firstFolders.refresh();

                                              final url = Uri.parse(
                                                  'http://$HOST/api/auth/create_database');
                                              final Map<String, dynamic>
                                                  requestBody = {
                                                "uid": await storage.read(
                                                    key: "uid"),
                                                "access_token": await storage
                                                    .read(key: "access_token"),
                                                "refresh_token": await storage
                                                    .read(key: "refresh_token"),
                                                "name": _textcontroller.text,
                                                "parent_id":
                                                    item.value["parent"]
                                              };
                                              final headers = {
                                                "Content-type":
                                                    "application/json"
                                              };

                                              final response = await http.post(
                                                url,
                                                headers: headers,
                                                body: jsonEncode(requestBody),
                                              );

                                              if (response.statusCode == 200) {
                                                //수정해야함. 백엔드로부터 새로만든 폴더 id 받아야함.
                                                displayInfoBar(
                                                  context,
                                                  builder: (context, close) {
                                                    return InfoBar(
                                                      severity: InfoBarSeverity
                                                          .success,
                                                      title: const Text(
                                                          '폴더 만들기 성공'),
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
                                                      severity: InfoBarSeverity
                                                          .warning,
                                                      title: const Text(
                                                          '폴더 만들기 실패'),
                                                      action: IconButton(
                                                        icon: const Icon(
                                                            FluentIcons.clear),
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
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Container(
                  color: Colors.yellow,
                  width: 300,
                  height: 300,
                  child: Text(controller.droptest.value.toString()),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
