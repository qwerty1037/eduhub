import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Problem_List.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:get/get.dart';

///홈스크린 관련 로직 처리하는 컨트롤러
class HomeScreenController extends GetxController {
  bool isFolderEmpty = false;

  HomeScreenController() {
    if (Get.find<FolderController>().firstFolders.isEmpty) {
      isFolderEmpty = true;
    }
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
            tabBodyController.workingSpaceWidget.value as Container;
        ProblemList folder = workingSpace.child as ProblemList;
        var folderId = folder.targetFolder.value["id"];
        tabToSave.add('{"type": "explore", "id": $folderId }');
        debugPrint("folderId");
      } else if (tabType == DashBoardType.search) {
        debugPrint("search");
        String searchText =
            Get.find<SearchScreenController>(tag: bodyList[i].tagName)
                .searchBarController
                .text;
        tabToSave.add('{"type": "search", "text": $searchText }');
        debugPrint(searchText);
        //searchscreen controller찾고 그 안의 searchBarController.text를 저장
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
    previousTotalController.update();
  }
}
