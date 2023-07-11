import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluent_ui/fluent_ui.dart';

class ProjectTabController extends GetxController {
  List<TreeViewItem> totalfolders = [];
  RxList<TreeViewItem> firstFolders = <TreeViewItem>[].obs;
  Rx<int> droptest = 0.obs;

  @override
  void onInit() {
    makeFolderListInfo(example);
    super.onInit();
  }

  ///백엔드 데이터를 받는 부분 추가후 작동
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
        value: {"parent": parent, "id": id},
        content: Draggable(
          data: {"parent": parent, "id": id},
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
              if (data!["id"] != id) {
                return true;
              } else {
                return false;
              }
            },
            onAccept: (Map<String, dynamic> data) async {
              //삭제할 부분, 뒷 부분에 이미 있으며 성능 테스트를 위해 앞에도 뒀음.
              TreeViewItem targetFolder = totalfolders
                  .firstWhere((element) => element.value["id"] == data["id"]);
              totalfolders
                  .firstWhere((element) => element.value["id"] == id)
                  .children
                  .add(targetFolder);

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
              const storage = FlutterSecureStorage();

              final url =
                  Uri.parse('http://$HOST/api/data/update_database_directory');
              final Map<String, dynamic> requestBody = {
                "uid": await storage.read(key: "uid"),
                "access_token": await storage.read(key: "access_token"),
                "refresh_token": await storage.read(key: "refresh_token"),
                "target_database_id": data["id"],
                "destination_database_id": parent
              };
              final headers = {"Content-type": "application/json"};

              final response = await http.post(
                url,
                headers: headers,
                body: jsonEncode(requestBody),
              );
              if (response.statusCode == 200) {
                TreeViewItem targetFolder = totalfolders
                    .firstWhere((element) => element.value["id"] == data["id"]);
                totalfolders
                    .firstWhere((element) => element.value["id"] == id)
                    .children
                    .add(targetFolder);

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
              } else {}
            },
          ),
        ));
  }
}

//정보를 {아이디, name, 부모 아이디} 형태로 받은 list가 존재한다고 가정. 다음은 예시 데이터. 로그인 즉시 or 프로젝트 선택시 백엔드로부터 폴더 데이터 받기
List<dynamic> example = [
  {
    "id": 1,
    "name": "하이탑",
    "parent_id": null,
  },
  {
    "id": 2,
    "name": "고1",
    "parent_id": 1,
  },
  {
    "id": 3,
    "name": "고2",
    "parent_id": 1,
  },
  {
    "id": 4,
    "name": "중간대비",
    "parent_id": 3,
  },
  {
    "id": 5,
    "name": "기말대비",
    "parent_id": 3,
  },
  {
    "id": 6,
    "name": "고3",
    "parent_id": 1,
  },
];
