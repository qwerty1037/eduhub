import 'dart:convert';

import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Problem_List.dart';
import 'package:front_end/Controller/Desktop_Controller.dart';
import 'package:front_end/Controller/Group_Controller.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Desktop_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Screen/Group_Management.dart';
import 'package:front_end/Test/Folder_Example_Data.dart';
import 'package:front_end/Test/Temporary_GroupDatabase.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluent_ui/fluent_ui.dart';

///폴더 관련 데이터를 처리하는 컨트롤러
class GroupTreeViewController extends GetxController {
  DesktopController desktopController = Get.find<DesktopController>();
  RxInt selectedGroupID = 99999999999.obs;
  RxString selectedPath = "".obs;
  RxList<TreeViewItem> totalGroups = <TreeViewItem>[].obs;
  RxList<TreeViewItem> firstGroups = <TreeViewItem>[].obs;

  RxBool temp_variable = false.obs;

  ///처음에 유저의 백엔드로부터 폴더 리스트를 받아와 보여줄 리스트를 구성
  Future<void> receiveData() async {
    makeGroupListInfo(temporaryGroupDB());

    ///TODO: Group 백엔드 연동 요구
    /*
    final url = Uri.parse('https://$HOST/api/data/user_database');
    final response = await http.get(
      url,
      headers: await defaultHeader(httpContentType.json),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);
      final databaseFolder = jsonResponse['database_groups'];
      makeGroupListInfo(databaseFolder);
    } else if (isHttpRequestFailure(response)) {
      debugPrint("그룹 리스트 받기 오류 발생");
    }
    */
  }

  ///json 형태로 데이터가 들어올 때 보여줄 그룹들을 만드는 핵심 함수
  void makeGroupListInfo(List<dynamic> data) {
    final List<TreeViewItem> groups = [];
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final int id = item['id'];
      final String name = item['name'];
      final List<int>? studentsId = item['studentsId'];

      final group = makeGroupItem(name, id, studentsId);
      groups.add(group);
    }
    totalGroups.addAll(groups);
  }

  TreeViewItem findGroupItem(int id) {
    return totalGroups.firstWhere((element) => element.value["id"] == id);
  }

  ///폴더의 이름, id, parent를 받아 새로운 TreeViewItem을 반환한다.
  TreeViewItem makeGroupItem(String name, int id, List<int>? studentsId) {
    return TreeViewItem(
      backgroundColor: ButtonState.resolveWith((states) {
        const res = ResourceDictionary.light();
        if (selectedGroupID.value == id) {
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
      value: {"id": id, "name": name, "studentsId": studentsId},
      content: Text(name),
    );
  }

  ///특정 폴더를 클릭했을 때 현재 탭에서 폴더에 속하는 문제 리스트들을 보여주는 함수
  Future<void> makeGroupListInCurrentTab(
      TreeViewItem item, String tagName) async {
    DefaultTabBodyController workingSpaceController =
        Get.find<DefaultTabBodyController>(tag: tagName);

    await workingSpaceController.deleteWorkingSpaceController();
    GroupController groupController = Get.put(GroupController(), tag: tagName);
    workingSpaceController.changeWorkingSpace(GroupManagementScreen(
      item: item,
      controller: groupController,
    ));
    workingSpaceController.dashBoard.value =
        workingSpaceController.makeDashBoard(DashBoardType.group);
  }

  Future<void> getPath() async {
    final url = Uri.parse(
        'https://$HOST/api/data/get_database/${selectedGroupID.value}');
    final response = await http.get(
      url,
      headers: await defaultHeader(httpContentType.json),
    );
    final jsonResponse = jsonDecode(response.body);
    selectedPath.value = jsonResponse["database"]["path"];
  }
}
