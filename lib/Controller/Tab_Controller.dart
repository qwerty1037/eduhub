import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:get/get.dart';

class TabController extends GetxController {
  RxInt currentTabIndex = 0.obs;
  RxList<Tab> tabs = <Tab>[].obs;
  RxBool isHomeScreen = true.obs;
  int tagNumber = 0;

  ///새로운 탭을 추가하는 함수, body와 탭 이름을 변수로 둘 수 있음.
  Tab addTab(Widget body, String? text) {
    Tab? newTab;
    newTab = Tab(
      key: Key(tagNumber.toString()),
      text: Text(
        text ?? "New Tab",
        style: const TextStyle(color: DEFAULT_LIGHT_COLOR),
      ),
      icon: const Icon(
        FluentIcons.file_template,
      ),
      body: body,
      onClosed: () {
        tabs.remove(newTab);
        if (currentTabIndex > 0) {
          currentTabIndex--;
        }
        if (currentTabIndex == 0) {
          isHomeScreen.value = true;
        }
        Get.find<DefaultTabBodyController>().deleteWorkingSpaceController();
        Get.delete<DefaultTabBodyController>(
            tag: Key(tagNumber.toString()).toString());
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
        style: const TextStyle(color: DEFAULT_LIGHT_COLOR),
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

  String getCurrentTabKey() {
    return tabs[currentTabIndex.value].key.toString();
  }
}
