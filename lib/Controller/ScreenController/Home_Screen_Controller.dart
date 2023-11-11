import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/CalendarEvent.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Problem_List.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Group_TreeView_Controller.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Test/Default_Tab_Body_stful.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:win32/win32.dart';

///홈스크린 관련 로직 처리하는 컨트롤러
class HomeScreenController extends GetxController {
  bool isFolderEmpty = false;
  bool isExamFolderEmpty = false;
  var storage = const FlutterSecureStorage();
  late LocalStorage localStorage;
  RxMap<DateTime, List<CalendarEvent>> events =
      <DateTime, List<CalendarEvent>>{}.obs;

  RxBool temp_variable = true.obs;

  HomeScreenController() {
    if (Get.find<FolderController>().firstFolders.isEmpty) {
      isFolderEmpty = true;
    }
    if (Get.find<FolderController>().firstExamFolders.isEmpty) {
      isExamFolderEmpty = true;
    }
  }

  @override
  void onInit() async {
    String? id = await storage.read(key: "id");
    if (id != null) {
      localStorage = LocalStorage(id);
      bool ready = await localStorage.ready;

      if (ready && localStorage.getItem('calendarEvents') != null) {
        Map<String, dynamic> savedEvents =
            localStorage.getItem('calendarEvents');
        var savedkeys = savedEvents.keys.toList();
        var savedCalendarEvents = savedEvents.values.toList();
        for (int i = 0; i < savedkeys.length; i++) {
          DateTime targetDate = DateTime.parse(savedkeys.elementAt(i));
          List<dynamic> targetEvents = savedCalendarEvents.elementAt(i);
          List<CalendarEvent> jsonToEvents =
              targetEvents.map((e) => CalendarEvent.fromJson(e)).toList();
          events.addAll({targetDate: jsonToEvents});
        }
      }
    }

    ever(events, (e) async {
      Map<String, List<Map<String, dynamic>>> data = {};
      var keys = events.keys.toList();
      var calendarEvents = events.values.toList();
      for (int i = 0; i < keys.length; i++) {
        DateTime targetDate = keys.elementAt(i);
        List<CalendarEvent> targetEvents = calendarEvents.elementAt(i);
        List<Map<String, dynamic>> eventsToJson =
            targetEvents.map((e) => e.toJson()).toList();
        data.addAll({targetDate.toString(): eventsToJson});
      }

      await localStorage.setItem("calendarEvents", data);
    });

    super.onInit();
  }

  ///로그아웃 함수로 현재는 쿠키를 없애고 total컨트롤러를 제외한 모든 컨트롤러 인스턴스를 제거
  void logout() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();

    storage.write(key: 'saved_uid', value: await storage.read(key: 'uid'));
    await storage.delete(key: 'saved_tabs');
    List<String> tabToSave = [];
    List<DefaultTabBody> bodyList = Get.find<TabController>().tabInfo;
    for (int i = 0; i < bodyList.length; i++) {
      DefaultTabBodyController tabBodyController =
          Get.find<DefaultTabBodyController>(tag: bodyList[i].tagName);
      DashBoardType tabType = tabBodyController.dashBoardType;

      if (tabType == DashBoardType.explore) {
        debugPrint("explore");
        Container workingSpace =
            tabBodyController.realWorkingSpaceWidget as Container;
        ProblemList folder = workingSpace.child as ProblemList;
        var folderId = folder.targetFolder.value["id"];
        tabToSave.add('{"type": "explore", "id": $folderId }');
        debugPrint("folderId");
      } else if (tabType == DashBoardType.search) {
        String searchText =
            Get.find<SearchScreenController>(tag: bodyList[i].tagName)
                .searchBarController
                .text;
        String searchDifficulty =
            Get.find<SearchScreenController>(tag: bodyList[i].tagName)
                .getDifficulty()
                .toString();
        String searchContent =
            Get.find<SearchScreenController>(tag: bodyList[i].tagName)
                .getContent();

        tabToSave.add(
            '{"type": "search", "text": "$searchText" , "difficulty" : "$searchDifficulty", "content" : "$searchContent"}');
      }
    }
    storage.write(key: 'saved_tabs', value: tabToSave.toString());

    await storage.delete(key: "uid");
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
    final TotalController previousTotalController = Get.find<TotalController>();
    previousTotalController.isLoginSuccess = false;
    Get.deleteAll();
    Get.put(FolderController());
    Get.put(GroupTreeViewController());
    previousTotalController.update();
  }
}
