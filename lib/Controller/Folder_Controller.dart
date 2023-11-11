import 'dart:convert';

import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Problem_List.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Test/Folder_Example_Data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluent_ui/fluent_ui.dart';

///폴더 관련 데이터를 처리하는 컨트롤러
class FolderController extends GetxController {
  TotalController totalController = Get.find<TotalController>();
  RxInt selectedDirectoryID = 99999999999.obs;
  RxString selectedPath = "".obs;
  List<TreeViewItem> totalFolders = [];
  RxList<TreeViewItem> firstFolders = <TreeViewItem>[].obs;

  RxBool temp_variable = false.obs;

  ///처음에 유저의 백엔드로부터 폴더 리스트를 받아와 보여줄 리스트를 구성
  Future<void> receiveData() async {
    final url = Uri.parse('https://$HOST/api/data/user_database');
    final response = await http.get(
      url,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);
      final databaseFolder = jsonResponse['database_folders'];
      makeFolderListInfo(databaseFolder);
    } else if (isHttpRequestFailure(response)) {
      debugPrint("폴더 리스트 받기 오류 발생");
    }
  }

  ///json 형태로 데이터가 들어올 때 보여줄 폴더들을 만드는 핵심 함수
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
    totalFolders.addAll(folders);
    firstFolders.addAll(rootFolders);
  }

  TreeViewItem findTreeViewItem(int id) {
    return totalFolders.firstWhere((element) => element.value["id"] == id);
  }

  ///폴더의 이름, id, parent를 받아 새로운 TreeViewItem을 반환한다.
  TreeViewItem makeFolderItem(String name, int id, int? parent) {
    return TreeViewItem(
      backgroundColor: ButtonState.resolveWith((states) {
        const res = ResourceDictionary.light();
        if (selectedDirectoryID.value == id) {
          return Colors.grey[80];
        } else {
          if (states.isPressing) return res.subtleFillColorTertiary;
          if (states.isHovering) return res.subtleFillColorSecondary;
          if (states.isDisabled) return res.controlAltFillColorDisabled;
        }
        return res.controlAltFillColorSecondary;
      }), //selectedDirectoryID?.value == id ? ButtonState<Color>(Colors.white) : Colors.grey,
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
                Uri.parse('https://$HOST/api/data/update_database_directory');
            final Map<String, dynamic> requestBody = {
              "target_database_id": data["id"],
              "destination_database_id": parent
            };

            final response = await http.post(
              url,
              headers: await defaultHeader(httpContentType.json),
              body: jsonEncode(requestBody),
            );
            if (isHttpRequestSuccess(response)) {
              TreeViewItem targetFolder = totalFolders
                  .firstWhere((element) => element.value["id"] == data["id"]);
              TreeViewItem thisFolder = totalFolders
                  .firstWhere((element) => element.value["id"] == id);
              thisFolder.children.add(targetFolder);
              thisFolder.expanded = true;

              if (data["parent"] != null) {
                TreeViewItem parentItem = totalFolders.firstWhere(
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
            } else if (isHttpRequestFailure(response)) {
              debugPrint("실패");
            }
          },
        ),
      ),
    );
  }

  /// 특정 폴더를 클릭했을 때 해당하는 문제 내용을 백엔드로부터 받고 새로운탭을 열면서 보여주는 함수
  Future<void> makeProblemListInNewTab(TreeViewItem item) async {
    final problemUrl = Uri.parse(
        'https://$HOST/api/data/problem/database/${item.value["id"]}');

    final response = await http.get(
      problemUrl,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);

      final problems = jsonResponse['problem_list'];

      TabController tabController = Get.find<TabController>();
      tabController.isNewTab = true;

      ProblemListController problemListController = Get.put(
          ProblemListController(problems),
          tag: Get.find<TabController>().getTabKey());
      DefaultTabBody generatedTab = DefaultTabBody(
        key: GlobalObjectKey(tabController.tagNumber.toString()),
        dashBoardType: DashBoardType.explore,
        workingSpace: ProblemList(
          targetFolder: item,
          folderName: item.value["name"],
          problems: problems,
          problemListController: problemListController,
        ),
      );

      Tab newTab = tabController.addTab(generatedTab, item.value["name"],
          const Icon(FluentIcons.fabric_folder));
      tabController.tabs.add(newTab);
      tabController.currentTabIndex.value = tabController.tabs.length - 1;
      tabController.isNewTab = false;
    } else if (isHttpRequestFailure(response)) {
      debugPrint(response.statusCode.toString());
      debugPrint("폴더 직속 문제 받기 오류 발생");
    }
  }

  ///특정 폴더를 클릭했을 때 현재 탭에서 폴더에 속하는 문제 리스트들을 보여주는 함수
  Future<void> makeProblemListInCurrentTab(
      TreeViewItem item, String tagName) async {
    DefaultTabBodyController workingSpaceController =
        Get.find<DefaultTabBodyController>(tag: tagName);

    final problemUrl = Uri.parse(
        'https://$HOST/api/data/problem/database/${item.value["id"]}');

    final response = await http.get(
      problemUrl,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      await workingSpaceController.deleteWorkingSpaceController();
      final jsonResponse = jsonDecode(response.body);
      final problems = jsonResponse['problem_list'];
      ProblemListController problemListController =
          Get.put(ProblemListController(problems), tag: tagName);
      workingSpaceController.changeWorkingSpace(ProblemList(
        targetFolder: item,
        folderName: item.value["name"],
        problems: problems,
        problemListController: problemListController,
      ));
      workingSpaceController.dashBoard.value =
          workingSpaceController.makeDashBoard(DashBoardType.explore);
    } else if (isHttpRequestFailure(response)) {
      debugPrint(response.statusCode.toString());
      debugPrint("폴더 직속 문제 받기 오류 발생");
    }
  }

  Future<void> getPath() async {
    final url = Uri.parse(
        'https://$HOST/api/data/get_database/${selectedDirectoryID.value}');
    final response = await http.get(
      url,
      headers: await defaultHeader(httpContentType.json),
    );
    final jsonResponse = jsonDecode(response.body);
    selectedPath.value = jsonResponse["database"]["path"];
  }
}
