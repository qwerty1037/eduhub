import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Component/DefaultTextBox.dart';
import 'package:front_end/Controller/home_screen.controller.dart';
import 'package:front_end/Controller/tab.controller.dart';
import 'package:front_end/Controller/total.controller.dart';
import 'package:front_end/Screen/SearchScreen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;

class HomeScreen extends StatelessWidget {
  final FlyoutController _flyoutController = FlyoutController();
  final tabController = Get.put(TabController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    final theme = Get.find<TotalController>();

    return GetX<HomeScreenController>(
      builder: (controller) {
        return NavigationView(
          appBar: NavigationAppBar(
            automaticallyImplyLeading: false,
            title: Container(
              child: Row(
                children: [
                  ToggleSwitch(
                    checked: theme.isdark.value,
                    onChanged: (value) {
                      theme.isdark.value = !theme.isdark.value;
                    },
                    content: theme.isdark.isTrue
                        ? const Text(
                            "어둡게",
                            style: TextStyle(color: DEFAULT_LIGHT_COLOR),
                          )
                        : const Text(
                            "밝은색",
                            style: TextStyle(color: DEFAULT_DARK_COLOR),
                          ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  DropDownButton(
                      title: const Row(children: [
                        Icon(
                          FluentIcons.settings,
                          size: 15,
                        ),
                        Text(
                          " 설정",
                          style: TextStyle(fontSize: 12),
                        )
                      ]),
                      items: [
                        MenuFlyoutItem(
                            text: const Text('내정보'), onPressed: () {}),
                        const MenuFlyoutSeparator(),
                        MenuFlyoutItem(
                            text: const Text('결제'), onPressed: () {}),
                        const MenuFlyoutSeparator(),
                        MenuFlyoutItem(
                            text: const Text('로그아웃'), onPressed: () {}),
                      ]),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: DefaultTextBox(
                      controller: controller.searchBarController,
                      placeholder: "SearchBar",
                      prefix: const material.Icon(material.Icons.search),
                      suffix:
                          const material.Icon(material.Icons.arrow_forward_ios),
                      onChanged: (value) => controller.searchBarController.text,
                      onEditingComplete: () {
                        tabController.isHomeScreen.value = false;
                        Tab newTab = tabController.addTab(SearchScreen());

                        tabController.tabs.add(newTab);
                        tabController.currentTabIndex.value =
                            tabController.tabs.length - 1;
                      },
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            backgroundColor:
                theme.isdark.isTrue ? DEFAULT_DARK_COLOR : DEFAULT_LIGHT_COLOR,
            actions: FlyoutTarget(
              controller: _flyoutController,
              child: IconButton(
                icon: Icon(
                  FluentIcons.status_circle_question_mark,
                  size: 40,
                  color: theme.isdark.isTrue
                      ? DEFAULT_LIGHT_COLOR
                      : DEFAULT_DARK_COLOR,
                ),
                onPressed: () {
                  _flyoutController.showFlyout(builder: ((context) {
                    return MenuFlyout(
                      items: [
                        MenuFlyoutItem(
                          text: const Text("유튜브로 사용법 보기"),
                          onPressed: () {},
                        ),
                        const MenuFlyoutSeparator(),
                        MenuFlyoutItem(
                          text: const Text("언어 변경"),
                          onPressed: () {},
                        ),
                        const MenuFlyoutSeparator(),
                        MenuFlyoutItem(
                          text: const Text("피드백 보내기"),
                          onPressed: () {},
                        ),
                      ],
                    );
                  }));
                },
              ),
            ),
          ),
          pane: NavigationPane(
            menuButton: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: IconButton(
                icon: controller.paneIsOpen.isTrue
                    ? const Icon(FluentIcons.chrome_back)
                    : const Icon(FluentIcons.chrome_back_mirrored),
                onPressed: () {
                  controller.paneIsOpen.value = !controller.paneIsOpen.value;
                },
              ),
            ),
            displayMode: controller.paneIsOpen.isTrue
                ? PaneDisplayMode.open
                : PaneDisplayMode.compact,
            selected: controller.selectedIndex.value,
            onChanged: (value) {
              controller.onChanged(value);
            },
            items: controller.paneItemList,
          ),
        );
      },
    );
  }
}
