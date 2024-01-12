import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/default_tab_body.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:front_end/Controller/search_controller.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:front_end/Screen/problem_list.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class WindowEventListener extends StatefulWidget {
  const WindowEventListener({super.key, required this.child});
  final Widget child;

  @override
  State<WindowEventListener> createState() => _WindowEventListenerState();
}

class _WindowEventListenerState extends State<WindowEventListener> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    delayTimeToSaveData;
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void delayTimeToSaveData() async {
    await windowManager.setPreventClose(true);
  }

  ///앱을 종료할 때 로컬에 마지막 접속 아이디, 탭들을 저장하는 함수
  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      const storage = FlutterSecureStorage();
      storage.write(key: 'saved_uid', value: await storage.read(key: 'uid'));

      //기존에 저장되었던 탭 삭제
      await storage.delete(key: 'saved_tabs');
      List<String> tabToSave = [];
      List<DefaultTabBody> tabInfoList = Get.find<FluentTabController>().tabInfo;

      for (int i = 0; i < tabInfoList.length; i++) {
        DefaultTabBodyController tabBodyController = Get.find<DefaultTabBodyController>(tag: tabInfoList[i].tagName);
        DashBoardType dashBoardType = tabBodyController.dashBoardType;

        //FIXME //TODO: 기능 확장시 업데이트 필요

        //ProblemList 탭 저장
        if (dashBoardType == DashBoardType.explore) {
          Container workingSpace = tabBodyController.realWorkingSpaceWidget as Container;
          ProblemList problemList = workingSpace.child as ProblemList; // 혹시 DashBoardType.explore가 사용되는 다른 기능이 생길 경우 업데이트
          var folderId = problemList.targetFolder.value["id"];
          tabToSave.add('{"type": "explore", "id": $folderId }');
        }
        //SearchScreen 탭 저장
        else if (dashBoardType == DashBoardType.search) {
          String searchText = Get.find<SearchScreenController>(tag: tabInfoList[i].tagName).searchBarController.text;
          String searchDifficulty = Get.find<SearchScreenController>(tag: tabInfoList[i].tagName).getDifficulty().toString();
          String searchContent = Get.find<SearchScreenController>(tag: tabInfoList[i].tagName).getContent();
          tabToSave.add('{"type": "search", "text": "$searchText" , "difficulty" : "$searchDifficulty", "content" : "$searchContent"}');
        }
      }
      storage.write(key: 'saved_tabs', value: tabToSave.toString());
      await storage.delete(key: 'uid');
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');
      Get.deleteAll(force: true);
      await windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
