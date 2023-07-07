import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/tab.controller.dart';
import 'home_screen.dart';
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
                  controller.isHomeScreen.value = false;
                  controller.currentTabIndex.value = index;
                },
                onNewPressed: () {
                  controller.isHomeScreen.value = false;
                  Tab newTab = controller.addTab(Container(
                    color: Colors.green,
                    child: const Text("new tab test"),
                  ));

                  controller.tabs.add(newTab);
                  controller.currentTabIndex.value = controller.tabs.length - 1;
                },
                onReorder: (oldIndex, newIndex) {
                  controller.onReorder(oldIndex, newIndex);
                },
              ),
              Positioned(
                  top: 34.0,
                  child: controller.isHomeScreen.isTrue
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: HomeScreen())
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ))
            ],
          ),
        );
      },
    );
  }
}
