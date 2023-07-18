import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';

class TabController extends GetxController {
  final TotalController _totalController = Get.find<TotalController>();

  RxInt currentTabIndex = 0.obs;
  RxInt hiddenTabIndex = (-1).obs;
  RxList<Tab> tabs = <Tab>[].obs;
  RxList<Tab> hiddentabs = <Tab>[].obs;
  RxBool isHomeScreen = true.obs;

  ///새로운 탭을 추가하는 함수, 탭의 body부분만 인자로 받아 탭을 만들고 탭 이름은 New Tab으로 고정해두었는데, 추후 인자 등 변경을 통해 이름도 변경 가능.
  Tab addTab(Widget body, String? text) {
    Tab? newTab;
    newTab = Tab(
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
        if (currentTabIndex.value == 0) {
          isHomeScreen.value = true;
        }
      },
    );
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

    if (currentTabIndex.value == newIndex) {
      currentTabIndex.value = oldIndex;
    } else if (currentTabIndex.value == oldIndex) {
      currentTabIndex.value = newIndex;
    }
  }
}
