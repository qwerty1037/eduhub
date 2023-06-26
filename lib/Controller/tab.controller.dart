import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:get/get.dart';

class TabController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxList<Tab> tabs = <Tab>[].obs;

  void generateTab(String title, Widget body) {
    late Tab tab;
    tab = Tab(
      text: Text(title),
      icon: const Icon(
        FluentIcons.file_template,
      ),
      body: Container(
        color: DEFAULT_TAB_COLOR,
        child: body,
      ),
      onClosed: () {
        tabs.remove(tab);
        if (currentIndex > 0) {
          currentIndex--;
        }
      },
    );
    tabs.add(tab);
  }
}
