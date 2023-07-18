import 'dart:convert';

import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Cookie.dart';
import 'package:front_end/Test/Folder_Example_Data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluent_ui/fluent_ui.dart';

///어디든 폴더 필요한 곳에 find로 이 컨트롤러 찾고 TreeView(item)
class FolderController extends GetxController {
  List<TreeViewItem> totalfolders = [];
  RxList<TreeViewItem> firstFolders = <TreeViewItem>[].obs;

  Future<void> receiveData() async {
    final url = Uri.parse('http://$HOST/api/data/user_database');

    final response = await http.get(
      url,
      headers: await sendCookieToBackend(),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final databaseFolder = jsonResponse['database_folders'];
      makeFolderListInfo(databaseFolder);
    } else {
      debugPrint("폴더 리스트 받기 오류 발생");
    }
  }

//서버 없을때 연결 시킬 것
  void makeExampleData() {
    makeFolderListInfo(example);
  }

  void makeFolderListInfo(List<dynamic> data) {
    final List<int> stack = [];
    final List<TreeViewItem> folders = [];
    List<TreeViewItem> rootFolders = [];
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final int id = item['id'];
      final String name = item['name'];
      final int? parentId = item['parent_id'];

      while (stack.isNotEmpty && stack.last != parentId) {
        stack.removeLast();
      }

      final folder = makeFolderItem(name, id, parentId);

      if (stack.isNotEmpty) {
        TreeViewItem parentFolder = folders.firstWhere((element) {
          return element.value["id"] == parentId;
        });
        parentFolder.children.add(folder);
      } else {
        rootFolders.add(folder);
      }
      stack.add(id);
      folders.add(folder);
    }
    totalfolders.addAll(folders);
    firstFolders.addAll(rootFolders);
  }

  TreeViewItem makeFolderItem(String name, int id, int? parent) {
    return TreeViewItem(
        leading: const Icon(FluentIcons.fabric_folder),
        expanded: false,
        children: [],
        value: {"parent": parent, "id": id, "name": name},
        content: Draggable(
          data: {"parent": parent, "id": id, "name": name},
          feedback: Container(
            color: Colors.grey.withOpacity(0.3),
            width: 140,
            height: 30,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ),
          child: DragTarget(
            builder: (BuildContext context, List<dynamic> candidateData,
                List<dynamic> rejectedData) {
              return Text(name);
            },
            onWillAccept: (Map<dynamic, dynamic>? data) {
              if (data!["id"] != id && data["parent"] != id) {
                return true;
              } else {
                return false;
              }
            },
            onAccept: (Map<String, dynamic> data) async {
              final url =
                  Uri.parse('http://$HOST/api/data/update_database_directory');
              final Map<String, dynamic> requestBody = {
                "target_database_id": data["id"],
                "destination_database_id": parent
              };

              final response = await http.post(
                url,
                headers: await sendCookieToBackend(),
                body: jsonEncode(requestBody),
              );
              if (response.statusCode ~/ 100 == 2) {
                TreeViewItem targetFolder = totalfolders
                    .firstWhere((element) => element.value["id"] == data["id"]);
                TreeViewItem thisFolder = totalfolders
                    .firstWhere((element) => element.value["id"] == id);
                thisFolder.children.add(targetFolder);
                thisFolder.expanded = true;

                if (data["parent"] != null) {
                  TreeViewItem parentItem = totalfolders.firstWhere(
                      (element) => element.value["id"] == data["parent"]);
                  parentItem.children.removeWhere(
                      (element) => element.value["id"] == data["id"]);
                } else {
                  firstFolders.removeWhere(
                      (element) => element.value["id"] == data["id"]);
                }
                data["parent"] = id;
                firstFolders.refresh();
                debugPrint("성공");
              } else {
                debugPrint("실패");
              }
            },
          ),
        ));
  }
}
