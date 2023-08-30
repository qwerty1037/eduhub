import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Search_Bar_Overlay.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Screen/Home_Screen.dart';
import 'package:get/get.dart';

///앱 전체적으로 사용되는 탭들을 관리하는 컨트롤러
class TabController extends GetxController {
  RxInt currentTabIndex = (0).obs;
  RxList<Tab> tabs = <Tab>[].obs;
  List<DefaultTabBody> tabInfo = <DefaultTabBody>[];

  int tagNumber = 0;
  bool isNewTab = true;
  TotalController totalController = Get.find<TotalController>();

  TabController() {
    tabs.add(
      Tab(
        icon: const Icon(FluentIcons.home),
        text: const SizedBox.shrink(),
        body: Obx(() => Container(
              color: totalController.isDark.value == true
                  ? Colors.grey[170]
                  : Colors.grey[10],
              child: HomeScreen(tabController: this),
            )),
        closeIcon: null,
        onClosed: () {},
      ),
    );
  }
  @override
  void onInit() async {
    super.onInit();
    const storage = FlutterSecureStorage();

    if (await storage.read(key: 'uid') ==
            await storage.read(key: 'saved_uid') &&
        await storage.read(key: 'saved_tabs') != null) {
      List<dynamic> tabToRestore =
          jsonDecode(await storage.read(key: 'saved_tabs') as String);

      FolderController folderController = Get.find<FolderController>();
      for (int i = 0; i < tabToRestore.length; i++) {
        String type = tabToRestore[i]["type"];
        if (type == "explore") {
          int folderId = tabToRestore[i]["id"];
          //아이디로 폴더 찾고,
          TreeViewItem currentFolder =
              folderController.findTreeViewItem(folderId);
          folderController.makeProblemListInNewTab(currentFolder);
        } else if (type == "search") {
          String searchText = tabToRestore[i]["text"];
          //텍스트 넣은채로 탭 구현, 현재는 검색 오버레이와 검색 세부 내역이 연동이 안되어 있어 미구현.
          debugPrint("검색창 복구 구현해야함(관련 위젯 tab 컨트롤러, event리스너, 홈스크린 컨트롤러)");
        }
      }
    }
  }

  ///새로운 탭을 추가하는 함수, body와 탭 이름, 아이콘을 파라미터로 받는다 탭 이름은 안주면 NewTab으로 된다.
  Tab addTab(final Widget body, final String? text, final Icon? icon) {
    Tab? newTab;
    tabInfo.add(body as DefaultTabBody);
    Key newKey = Key(tagNumber.toString());
    newTab = Tab(
      key: newKey,
      text: Text(
        text ?? "New Tab",
      ),
      icon: icon ??
          const Icon(
            FluentIcons.file_template,
          ),
      body: Obx(() => Container(
            color: totalController.isDark.value == true
                ? Colors.grey[170]
                : Colors.grey[10],
            child: body,
          )),
      onClosed: () async {
        final int indexToDelete = tabs.indexOf(newTab);
        tabs.remove(newTab);
        tabInfo.remove(body);

        if (indexToDelete <= currentTabIndex.value) {
          currentTabIndex.value--;
        }
        await Get.find<DefaultTabBodyController>(tag: newKey.toString())
            .deleteWorkingSpaceController();

        Get.delete<DefaultTabBodyController>(tag: newKey.toString());
        if (currentTabIndex.value == 0) {
          isNewTab = true;
        }
      },
    );
    tagNumber++;
    return newTab;
  }

  ///탭의 이름을 바꾸는 함수로 바꿀 탭과 바꿀 이름, 아이콘을 파라미터로 주면 된다
  void renameTab(final Tab tab, final String newName, final Icon? newIcon) {
    Tab? newTab;

    newTab = Tab(
      key: tab.key,
      text: Text(
        newName,
      ),
      icon: newIcon ?? tab.icon,
      body: tab.body,
      onClosed: () async {
        tabs.remove(newTab);
        final int indexToDelete = tabs.indexOf(newTab);

        if (indexToDelete <= currentTabIndex.value) {
          currentTabIndex.value--;
        }

        await Get.find<DefaultTabBodyController>(tag: tab.key.toString())
            .deleteWorkingSpaceController();

        Get.delete<DefaultTabBodyController>(
            tag: tab.key.toString(), force: true);
        if (currentTabIndex.value == 0) {
          isNewTab = true;
        }
      },
    );
    final int index = tabs.indexOf(tab);
    tabs[index] = newTab;
    //탭 바 부분이 currentIndex가 바뀌어야 다시 렌더링됌
    currentTabIndex.value++;
    currentTabIndex.value--;
  }

  ///탭의 순서가 바뀔때 로직
  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = tabs.removeAt(oldIndex);
    tabs.insert(newIndex, item);

    if (currentTabIndex == newIndex) {
      currentTabIndex.value = oldIndex;
    } else if (currentTabIndex == oldIndex) {
      currentTabIndex.value = newIndex;
    }
  }

  ///tab view에서 오른쪽의 +버튼을 눌렀을때 로직
  void onNewPressed() {
    isNewTab = true;
    DefaultTabBody generatedTab = DefaultTabBody(
      dashBoardType: DashBoardType.explore,
    );
    Tab newTab = addTab(generatedTab, null, null);

    tabs.add(newTab);

    currentTabIndex.value = tabs.length - 1;
    isNewTab = false;
  }

  ///현재 탭의 키를 반환하는 함수
  String _getCurrentTabKey() {
    return tabs[currentTabIndex.value].key.toString();
  }

  ///새로 만들 탭의 key값을 반환하는 함수
  String getNewTabKey() {
    return Key(tagNumber.toString()).toString();
  }

  ///새탭을 만들경우 getNewTabKey를 아닐 경우 _getCurrentTabKey를 반환하는 함수
  String getTabKey() {
    if (isNewTab) {
      return getNewTabKey();
    } else {
      return _getCurrentTabKey();
    }
  }
}
