import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:get/get.dart';

class TabController extends GetxController {
  RxInt currentTabIndex = (-1).obs;
  RxList<Tab> tabs = <Tab>[].obs;
  RxBool isHomeScreen = true.obs;
  int tagNumber = 0;

  ///새로운 탭을 추가하는 함수, body와 탭 이름을 변수로 둘 수 있음.
  Tab addTab(Widget body, String? text) {
    Tab? newTab;
    Key newKey = Key(tagNumber.toString());
    newTab = Tab(
      key: newKey,
      text: Text(
        text ?? "New Tab",
        style: const TextStyle(color: DEFAULT_DARK_COLOR),
      ),
      icon: const Icon(
        FluentIcons.file_template,
      ),
      body: body,
      onClosed: () {
        tabs.remove(newTab);

        currentTabIndex--;

        if (currentTabIndex == -1) {
          isHomeScreen.value = true;
        }
        Get.find<DefaultTabBodyController>(tag: newKey.toString())
            .deleteWorkingSpaceController();
        Get.delete<DefaultTabBodyController>(tag: newKey.toString());
      },
    );
    tagNumber++;
    return newTab;
  }

  void renameTab(Tab tab, String newName) {
    Tab newTab;
    newTab = Tab(
      text: Text(
        newName,
        style: const TextStyle(color: DEFAULT_DARK_COLOR),
      ),
      icon: tab.icon,
      body: tab.body,
      onClosed: () {
        tab.onClosed;
      },
    );
    tab = newTab;
    tabs.refresh();
  }

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

  void onNewPressed() {
    isHomeScreen.value = false;
    DefaultTabBody generatedTab = DefaultTabBody();
    Tab newTab = addTab(generatedTab, null);
    tabs.add(newTab);
    currentTabIndex.value = tabs.length - 1;
  }

  String _getCurrentTabKey() {
    return tabs[currentTabIndex.value].key.toString();
  }

  String _getNewTabKey() {
    return Key(tagNumber.toString()).toString();
  }

  String getTabKey() {
    if (currentTabIndex.value == -1) {
      return _getNewTabKey();
    } else {
      return _getCurrentTabKey();
    }
  }
}
