import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Button newFolderButton(BuildContext context) {
  final folderController = Get.find<FolderController>();
  final homeScreenController = Get.find<HomeScreenController>();
  return Button(
      child: const Text("새 문제 폴더 만들기"),
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

                      final url = Uri.parse('https://$HOST/api/data/create_database');
                      final Map<String, dynamic> requestBody = {"name": textcontroller.text, "parent_id": null};

                      final response = await http.post(
                        url,
                        headers: await defaultHeader(httpContentType.json),
                        body: jsonEncode(requestBody),
                      );

                      if (response.statusCode ~/ 100 == 2) {
                        final jsonResponse = jsonDecode(response.body);
                        debugPrint(jsonResponse.toString());
                        final int newFolderId = jsonResponse['inserted_database'][0]["id"];

                        TreeViewItem newFolder = folderController.makeExamFolderItem(textcontroller.text, newFolderId, null);
                        folderController.totalFolders.add(newFolder);
                        folderController.firstFolders.add(newFolder);
                        folderController.update();
                        homeScreenController.isFolderEmpty = false;
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

Button newExamFolderButton(BuildContext context) {
  final folderController = Get.find<FolderController>();
  final homeScreenController = Get.find<HomeScreenController>();
  return Button(
      child: const Text("새 시험지 폴더 만들기"),
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

                      final url = Uri.parse('https://$HOST/api/data/create_exam_database');
                      final Map<String, dynamic> requestBody = {"name": textcontroller.text, "parent_id": null};

                      final response = await http.post(
                        url,
                        headers: await defaultHeader(httpContentType.json),
                        body: jsonEncode(requestBody),
                      );

                      if (response.statusCode ~/ 100 == 2) {
                        final jsonResponse = jsonDecode(response.body);
                        debugPrint(jsonResponse.toString());
                        final int newFolderId = jsonResponse['inserted_database'][0]["id"];

                        TreeViewItem newFolder = folderController.makeExamFolderItem(textcontroller.text, newFolderId, null);
                        folderController.totalExamFolders.add(newFolder);
                        folderController.firstExamFolders.add(newFolder);
                        folderController.update();
                        homeScreenController.isExamFolderEmpty = false;
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
