import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Screen/Home_Screen.dart';
import 'package:get/get.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TabController());
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: GetX<TabController>(
        builder: (controller) {
          return Stack(
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
                tabWidthBehavior: TabWidthBehavior.sizeToContent,
                closeButtonVisibility: CloseButtonVisibilityMode.always,
                onChanged: (index) {
                  controller.isHomeScreen.value = false;
                  controller.currentTabIndex.value = index;
                },
                onNewPressed: () {
                  controller.onNewPressed();
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
                        child: HomeScreen(),
                      ),
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }
}
