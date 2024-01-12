import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:get/get.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: GetX<FluentTabController>(
        builder: (controller) {
          return TabView(
            minTabWidth: 0,
            currentIndex: controller.currentTabIndex.value,
            tabs: controller.tabs,
            tabWidthBehavior: TabWidthBehavior.sizeToContent,
            closeButtonVisibility: CloseButtonVisibilityMode.always,
            onChanged: (index) {
              controller.currentTabIndex.value = index;
            },
            onNewPressed: () {
              controller.onNewPressed();
            },
            onReorder: (oldIndex, newIndex) {
              if (oldIndex * newIndex > 0) {
                controller.onReorder(oldIndex, newIndex);
              } else {
                null;
              }
            },
          );
        },
      ),
    );
  }
}
