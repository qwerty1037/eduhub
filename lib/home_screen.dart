import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/tab.controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TabController());
    return GetX<TabController>(
      builder: ((controller) {
        return TabView(
          currentIndex: controller.currentIndex.value,
          tabs: controller.tabs,
        );
      }),
    );
  }
}
