import 'dart:ffi';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Problem_List.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class eventListener extends StatefulWidget {
  const eventListener({super.key, required this.child});
  final Widget child;

  @override
  State<eventListener> createState() => _eventListenerState();
}

class _eventListenerState extends State<eventListener> with WindowListener {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      const storage = FlutterSecureStorage();
      storage.write(key: 'saved_uid', value: await storage.read(key: 'uid'));

      List<String> tabToSave = [];
      List<DefaultTabBody> bodyList = Get.find<TabController>().tabInfo;
      for (int i = 0; i < bodyList.length; i++) {
        DefaultTabBodyController tabBodyController =
            Get.find<DefaultTabBodyController>(tag: bodyList[i].tagName);
        DashBoardType tabType = tabBodyController.dashBoardType;

        if (tabType == DashBoardType.explore) {
          Container workingSpace =
              tabBodyController.workingSpaceWidget.value as Container;
          ProblemList folder = workingSpace.child as ProblemList;
          var folderId = folder.targetFolder.value["id"];
          tabToSave.add('{"type": "explore", "id": $folderId }');
        } else if (tabType == DashBoardType.search) {
          String searchText =
              Get.find<SearchScreenController>(tag: bodyList[i].tagName)
                  .searchBarController
                  .text;
          tabToSave.add('{"type": "search", "text": $searchText }');

          //searchscreen controller찾고 그 안의 searchBarController.text를 저장
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
