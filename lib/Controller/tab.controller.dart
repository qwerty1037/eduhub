import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Controller/total.controller.dart';
import 'package:get/get.dart';

class TabController extends GetxController {
  final TotalController _totalController = Get.find<TotalController>();

  RxInt currentTabIndex = 0.obs;
  RxList<Tab> tabs = RxList<Tab>();
  RxBool isHomeScreen = true.obs;

  ///새로운 탭을 추가하는 함수, 탭의 body부분만 인자로 받아 탭을 만들고 탭 이름은 New Tab으로 고정해두었는데, 추후 인자 등 변경을 통해 이름도 변경 가능.
  Tab addTab(Widget body) {
    Tab? newTab;
    newTab = Tab(
      text: Text(
        "New Tab",
        style: TextStyle(
            color: _totalController.isdark.value
                ? DEFAULT_LIGHT_COLOR
                : DEFAULT_DARK_COLOR),
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
