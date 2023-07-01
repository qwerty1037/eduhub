import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/tab.controller.dart';
import 'package:get/get.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TabController());
    return GetX<TabController>(
      builder: (controller) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: TabView(
            currentIndex: controller.currentTabIndex.value,
            tabs: controller.tabs,
            tabWidthBehavior: TabWidthBehavior.sizeToContent,
            closeButtonVisibility: CloseButtonVisibilityMode.always,
            showScrollButtons: true,
            onChanged: (index) {
              controller.currentTabIndex.value = index;
            },
            onNewPressed: () {
              Tab newTab = controller.addTab(Container(
                color: Colors.green,
                child: const Text("new tab test"),
              ));

              controller.tabs.add(newTab);
              controller.currentTabIndex.value = controller.tabs.length - 1;
            },
          ),
        );
      },
    );
  }
}
