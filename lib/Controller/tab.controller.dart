import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:get/get.dart';

class TabController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxList<Tab> tabs = <Tab>[].obs;

  Tab generateTab(String title) {
    late Tab tab;
    tab = Tab(
      text: Text(title),
      icon: const Icon(
        FluentIcons.file_template,
      ),
      body: Container(
        color: DEFAULT_TAB_COLOR,
      ),
      onClosed: () {
        tabs.remove(tab);
        if (currentIndex > 0) {
          currentIndex--;
        }
      },
    );
    return tab;
  }
}
