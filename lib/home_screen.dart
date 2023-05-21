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
        return SizedBox(
          height: 600,
          child: TabView(
            currentIndex: controller.currentIndex.value,
            tabs: controller.tabs,
            // tabWidthBehavior: TabWidthBehavior.sizeToContent,
            // closeButtonVisibility: CloseButtonVisibilityMode.onHover,
            showScrollButtons: true,
            onChanged: (index) {
              controller.currentIndex.value = index;
            },
            onNewPressed: () {
              controller.tabs.add(
                  controller.generateTab("new tab", const Text('what the..')));
            },
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = controller.tabs.removeAt(oldIndex);
              controller.tabs.insert(newIndex, item);
              if (controller.currentIndex == newIndex) {
                controller.currentIndex.value = oldIndex;
              } else if (controller.currentIndex == oldIndex) {
                controller.currentIndex.value = newIndex;
              }
            },
          ),
        );
      }),
    );
  }
}
