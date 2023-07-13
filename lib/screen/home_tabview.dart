import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/tab.controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';

import 'package:front_end/Screen/HomeScreen.dart';
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
          content: Stack(
            children: [
              TabView(
                closeDelayDuration: const Duration(milliseconds: 100),
                header: IconButton(
                    icon: const Icon(
                      FluentIcons.home,
                    ),
                    onPressed: () {
                      controller.currentTabIndex.value = -1;
                      controller.isHomeScreen.value = true;
                    }),
                currentIndex: controller.currentTabIndex.value,
                tabs: controller.tabs,
                tabWidthBehavior: TabWidthBehavior.equal,
                closeButtonVisibility: CloseButtonVisibilityMode.onHover,
                showScrollButtons: true,
                onChanged: (index) {
                  if (index == -1) {
                    debugPrint("테스트");
                  }
                  controller.isHomeScreen.value = false;
                  controller.currentTabIndex.value = index;
                },
                onNewPressed: () {
                  controller.isHomeScreen.value = false;
                  DefaultTabBody generatedTab = DefaultTabBody();
                  Tab newTab = controller.addTab(generatedTab, null);

                  controller.tabs.add(newTab);
                  controller.currentTabIndex.value = controller.tabs.length - 1;
                },
                onReorder: (oldIndex, newIndex) {
                  controller.onReorder(oldIndex, newIndex);
                },
              ),
              controller.isHomeScreen.isTrue
                  ? Positioned(
                      top: 38.0,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 38,
                          child: HomeScreen()))
                  : Container()
            ],
          ),
        );
      },
    );
  }
}
