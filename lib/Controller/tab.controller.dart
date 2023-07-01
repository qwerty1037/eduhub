import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Controller/total.controller.dart';
import 'package:front_end/home_screen.dart';
import 'package:get/get.dart';

class TabController extends GetxController {
  final TotalController _totalController = Get.find<TotalController>();

  RxInt currentTabIndex = 0.obs;
  RxList<Tab> tabs = RxList<Tab>();

  //탭 가장 앞부분 home 아이콘 부분
  TabController() {
    tabs = [
      Tab(
        icon: const Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              FluentIcons.home,
            ),
          ],
        ),
        text: const Text(""),
        body: HomeScreen(),
        closeIcon: null,
      ),
    ].obs;
  }

  ///탭을 추가하는 부분, 현재는 탭 body부분만 인자로 받아 탭을 만들고 탭 이름은 New Tab으로 고정해두었는데, 추후 인자 등 변경을 통해 이름도 변경 가능.
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
      },
    );
    return newTab;
  }
}
