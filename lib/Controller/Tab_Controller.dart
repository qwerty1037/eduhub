import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:get/get.dart';

class TabController extends GetxController {
  final TotalController _totalController = Get.find<TotalController>();

  RxInt currentTabIndex = 0.obs;
  int hiddenTabIndex = (-1);
  RxList<Tab> tabs = <Tab>[].obs;
  List<Tab> hiddentabs = <Tab>[];
  RxBool isHomeScreen = true.obs;

  ///새로운 탭을 추가하는 함수, body와 탭 이름을 변수로 둘 수 있음.
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
        if (currentTabIndex == 0) {
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
}
