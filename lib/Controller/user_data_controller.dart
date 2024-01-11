import 'dart:convert';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/exam_problem_list.dart';
import 'package:front_end/Screen/problem_list.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/desktop_controller.dart';
import 'package:front_end/Component/Default/default_tab_body.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluent_ui/fluent_ui.dart';

///서버에 저장된 유저 데이터 관련 컨트롤러
class UserDataController extends GetxController {
  DesktopController desktopController = Get.find<DesktopController>();
  RxInt selectedProblemDirectoryId = 99999999999.obs; // TO DO 아이디 숫자 절대 불가능한 숫자인지 확인
  RxInt selectedExamDirectoryID = 99999999999.obs; // TO DO 아이디 숫자 절대 불가능한 숫자인지 확인
  RxString selectedPath = "".obs; // TO DO 일단 보류. 정확한 용도 파악 후 이름 수정 및 주석 수정
  List<TreeViewItem> allProblemFolders = [];
  RxList<TreeViewItem> rootProblemFolders = <TreeViewItem>[].obs;
  List<TreeViewItem> allExamFolders = [];
  RxList<TreeViewItem> rootExamFolders = <TreeViewItem>[].obs;
  RxString nickName = "김선생".obs; //임시적으로 넣은 이름.  TODO 연동후 삭제 예정

  ///로그인하면 처음에 서버로부터 문제, 시험지, 닉네임 등 받아오는 함수
  Future<void> receiveData() async {
    //문제 폴더 받아오기
    final problemUrl = Uri.parse('https://$HOST/api/data/user_database');
    final response = await http.get(
      problemUrl,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);
      final databaseFolder = jsonResponse['database_folders'];
      makeFolderListInfo(databaseFolder, false);
    } else {
      debugPrint("폴더 리스트 받기 오류 발생");
    }

    //시험지 폴더 받아오기
    final examUrl = Uri.parse('https://$HOST/api/data/user_exam_database');
    final examResponse = await http.get(
      examUrl,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(examResponse)) {
      final jsonResponse = jsonDecode(examResponse.body);
      final examDatabaseFolder = jsonResponse['database_folders'];
      makeFolderListInfo(examDatabaseFolder, true);
    } else {
      debugPrint("시험지 폴더 리스트 받기 오류 발생");
    }

    //TODO 닉네임 받아오기 함수 백엔드 업데이트 후 살리기
    // final nickNameUrl = Uri.parse('https://$HOST/api/data/nickname');
    // final nickResponse = await http.get(
    //   nickNameUrl,
    //   headers: await defaultHeader(httpContentType.json),
    // );
    // if (isHttpRequestSuccess(nickResponse)) {
    //   final jsonResponse = jsonDecode(nickResponse.body);
    //   nickName.value = jsonResponse['nickName'];
    // } else if (isHttpRequestFailure(response)) {
    //   debugPrint("닉네임 받기 오류 발생");
    // }
  }

  ///json 형태로 데이터가 들어올 때 문제 폴더나 시험지 폴더 만드는 함수
  void makeFolderListInfo(List<dynamic> data, bool isExam) {
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
      final TreeViewItem folder;
      if (isExam) {
        folder = makeExamFolderItem(name, id, parentId);
      } else {
        folder = makeFolderItem(name, id, parentId);
      }

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
    if (isExam) {
      allExamFolders.addAll(folders);
      rootExamFolders.addAll(rootFolders);
    } else {
      allProblemFolders.addAll(folders);
      rootProblemFolders.addAll(rootFolders);
    }
  }

  /// id로부터 개별 문제 폴더 객체를 가져오는 함수
  TreeViewItem getElementProblemFolder(int id) {
    return allProblemFolders.firstWhere((element) => element.value["id"] == id);
  }

  /// 폴더의 이름, id, parent를 받아 새로운 TreeViewItem를 만드는 함수
  TreeViewItem makeFolderItem(String name, int id, int? parent) {
    return TreeViewItem(
      //폴더 클릭했을 때 색깔 변동 관련 부분
      backgroundColor: ButtonState.resolveWith((states) {
        const res = ResourceDictionary.light();
        if (Get.find<UserDataController>().selectedProblemDirectoryId.value == id) {
          return Colors.grey[80];
        } else {
          if (states.isPressing) return res.subtleFillColorTertiary;
          if (states.isHovering) return res.subtleFillColorSecondary;
          if (states.isDisabled) return res.controlAltFillColorDisabled;
        }
        return res.controlAltFillColorSecondary;
      }),
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
        //유저가 드래그시 폴더끼리 위치 변경이 가능하도록 하는 부분
        child: DragTarget(
          builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
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
            final url = Uri.parse('https://$HOST/api/data/update_database_directory');
            final Map<String, dynamic> requestBody = {"target_database_id": data["id"], "destination_database_id": parent};

            final response = await http.post(
              url,
              headers: await defaultHeader(httpContentType.json),
              body: jsonEncode(requestBody),
            );
            if (isHttpRequestSuccess(response)) {
              TreeViewItem targetFolder = allProblemFolders.firstWhere((element) => element.value["id"] == data["id"]);
              TreeViewItem thisFolder = allProblemFolders.firstWhere((element) => element.value["id"] == id);
              thisFolder.children.add(targetFolder);
              thisFolder.expanded = true;

              if (data["parent"] != null) {
                TreeViewItem parentItem = allProblemFolders.firstWhere((element) => element.value["id"] == data["parent"]);
                parentItem.children.removeWhere((element) => element.value["id"] == data["id"]);
              } else {
                rootProblemFolders.removeWhere((element) => element.value["id"] == data["id"]);
              }
              data["parent"] = id;
              rootProblemFolders.refresh();
              debugPrint("성공");
            } else {
              debugPrint("실패");
            }
          },
        ),
      ),
    );
  }

  /// 시험지 의 이름, id, parent를 받아 새로운 TreeViewItem를 만드는 함수
  TreeViewItem makeExamFolderItem(String name, int id, int? parent) {
    return TreeViewItem(
      backgroundColor: ButtonState.resolveWith((states) {
        const res = ResourceDictionary.light();
        if (selectedExamDirectoryID.value == id) {
          return Colors.grey[80];
        } else {
          if (states.isPressing) return res.subtleFillColorTertiary;
          if (states.isHovering) return res.subtleFillColorSecondary;
          if (states.isDisabled) return res.controlAltFillColorDisabled;
        }
        return res.controlAltFillColorSecondary;
      }), //selectedProblemDirectoryId?.value == id ? ButtonState<Color>(Colors.white) : Colors.grey,
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
          builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
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
            final url = Uri.parse('https://$HOST/api/data/update_exam_database_directory');
            final Map<String, dynamic> requestBody = {"target_database_id": data["id"], "destination_database_id": parent};

            final response = await http.post(
              url,
              headers: await defaultHeader(httpContentType.json),
              body: jsonEncode(requestBody),
            );
            if (isHttpRequestSuccess(response)) {
              TreeViewItem targetFolder = allExamFolders.firstWhere((element) => element.value["id"] == data["id"]);
              TreeViewItem thisFolder = allExamFolders.firstWhere((element) => element.value["id"] == id);
              thisFolder.children.add(targetFolder);
              thisFolder.expanded = true;

              if (data["parent"] != null) {
                TreeViewItem parentItem = allExamFolders.firstWhere((element) => element.value["id"] == data["parent"]);
                parentItem.children.removeWhere((element) => element.value["id"] == data["id"]);
              } else {
                rootExamFolders.removeWhere((element) => element.value["id"] == data["id"]);
              }
              data["parent"] = id;
              rootExamFolders.refresh();
            } else {
              debugPrint("시험지 폴더 업데이트 실패(UserDataController)");
            }
          },
        ),
      ),
    );
  }

  /// 문제 폴더를 클릭했을 때 구체적인 내용을 서버로부터 받고 새 탭에서 보여주는 함수
  Future<void> makeProblemListInNewTab(TreeViewItem item) async {
    final problemUrl = Uri.parse('https://$HOST/api/data/problem/database/${item.value["id"]}');

    final response = await http.get(
      problemUrl,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);

      final problems = jsonResponse['problem_list'];

      TabController tabController = Get.find<TabController>();
      tabController.isNewTab = true;

      ProblemListController problemListController = Get.put(ProblemListController(problems), tag: Get.find<TabController>().getTabKey());
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

      Tab newTab = tabController.addTab(generatedTab, item.value["name"], const Icon(FluentIcons.fabric_folder));
      tabController.tabs.add(newTab);
      tabController.currentTabIndex.value = tabController.tabs.length - 1;
      tabController.isNewTab = false;
    } else {
      debugPrint(response.statusCode.toString());
      debugPrint("폴더 직속 문제 받기 오류 발생");
    }
  }

  Future<void> examViewerInNewTab(TreeViewItem item) async {
    final problemUrl = Uri.parse('https://$HOST/api/data/get_exam_database/${item.value["id"]}');

    final response = await http.get(
      problemUrl,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);

      final problems = jsonResponse['problem_list'];

      TabController tabController = Get.find<TabController>();
      tabController.isNewTab = true;

      ProblemListController problemListController = Get.put(ProblemListController(problems), tag: Get.find<TabController>().getTabKey());
      DefaultTabBody generatedTab = DefaultTabBody(
        key: GlobalObjectKey(tabController.tagNumber.toString()),
        dashBoardType: DashBoardType.examExplore,
        workingSpace: ExamProblemList(
          targetFolder: item,
          folderName: item.value["name"],
          problems: problems,
          problemListController: problemListController,
        ),
      );

      Tab newTab = tabController.addTab(generatedTab, item.value["name"], const Icon(FluentIcons.text_document));
      tabController.tabs.add(newTab);
      tabController.currentTabIndex.value = tabController.tabs.length - 1;
      tabController.isNewTab = false;
    } else {
      debugPrint(response.statusCode.toString());
      debugPrint("폴더 직속 문제 받기 오류 발생");
    }
  }

  ///특정 폴더를 클릭했을 때 현재 탭에서 폴더에 속하는 문제 리스트들을 보여주는 함수
  Future<void> makeProblemListInCurrentTab(TreeViewItem item, String tagName) async {
    DefaultTabBodyController workingSpaceController = Get.find<DefaultTabBodyController>(tag: tagName);

    final problemUrl = Uri.parse('https://$HOST/api/data/get_exam_database/${item.value["id"]}');

    final response = await http.get(
      problemUrl,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      await workingSpaceController.deleteWorkingSpaceController();
      final jsonResponse = jsonDecode(response.body);
      final problems = jsonResponse['problem_list'];
      ProblemListController problemListController = Get.put(ProblemListController(problems), tag: tagName);
      workingSpaceController.changeWorkingSpace(ProblemList(
        targetFolder: item,
        folderName: item.value["name"],
        problems: problems,
        problemListController: problemListController,
      ));
      workingSpaceController.dashBoard.value = workingSpaceController.makeDashBoard(DashBoardType.explore);
    } else {
      debugPrint(response.statusCode.toString());
      debugPrint("폴더 직속 문제 받기 오류 발생");
    }
  }

  Future<void> makeExamViewerInCurrentTab(TreeViewItem item, String tagName) async {
    DefaultTabBodyController workingSpaceController = Get.find<DefaultTabBodyController>(tag: tagName);

    final problemUrl = Uri.parse('https://$HOST/api/data/problem/database/${item.value["id"]}');

    final response = await http.get(
      problemUrl,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      await workingSpaceController.deleteWorkingSpaceController();
      final jsonResponse = jsonDecode(response.body);
      final problems = jsonResponse['problem_list'];
      ProblemListController problemListController = Get.put(ProblemListController(problems), tag: tagName);
      workingSpaceController.changeWorkingSpace(ExamProblemList(
        targetFolder: item,
        folderName: item.value["name"],
        problems: problems,
        problemListController: problemListController,
      ));
      workingSpaceController.dashBoard.value = workingSpaceController.makeDashBoard(DashBoardType.examExplore);
    } else {
      debugPrint(response.statusCode.toString());
      debugPrint("폴더 직속 문제 받기 오류 발생");
    }
  }

  Future<void> getPath() async {
    final url = Uri.parse('https://$HOST/api/data/get_database/${selectedProblemDirectoryId.value}');
    final response = await http.get(
      url,
      headers: await defaultHeader(httpContentType.json),
    );
    final jsonResponse = jsonDecode(response.body);
    selectedPath.value = jsonResponse["database"]["path"];
  }
}
