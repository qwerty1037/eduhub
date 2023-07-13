import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Component/DefaultTextBox.dart';
import 'package:front_end/Component/SearchBarOverLay.dart';
import 'package:front_end/Controller/home_screen.controller.dart';
import 'package:front_end/Controller/tab.controller.dart';
import 'package:front_end/Controller/total.controller.dart';
import 'package:front_end/Screen/PdfViewerScreen.dart';
import 'package:front_end/Screen/SearchScreen.dart';
import 'package:front_end/Screen/TagManagementScreen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;

import 'Default_Tab_Body.dart';

class HomeScreen extends StatelessWidget {
  final FlyoutController _flyoutController = FlyoutController();
  final tabController = Get.put(TabController());

  HomeScreen({super.key});

  Widget menuCommandBar(context, controller) {
    final menuCommandBarItems = <CommandBarItem>[
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Save your Pdf files!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.save),
          label: const Text("Save Pdf",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            tabController.isHomeScreen.value = false;
            DefaultTabBody generatedTab = DefaultTabBody(workingSpace: PdfViewerScreen());
            Tab newTab = tabController.addTab(generatedTab, "Save Pdf");

            tabController.tabs.add(newTab);
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Create Test!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("Create Test",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Manage your students!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("Student Management",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Search your problems!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.search),
          label: const Text("Search",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            createHighlightOverlay(context: context, controller: controller, tabController: tabController);
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Make your tags!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.tag),
          label: const Text("Tags",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            tabController.isHomeScreen.value = false;
            DefaultTabBody generatedTab = DefaultTabBody(workingSpace: TagManagementScreen());
            Tab newTab = tabController.addTab(generatedTab, "Generate Tags");
            tabController.tabs.add(newTab);
            tabController.currentTabIndex.value = tabController.tabs.length - 1;
          },
        ),
      ),
    ];

    return CommandBar(
      primaryItems: menuCommandBarItems,
      overflowBehavior: CommandBarOverflowBehavior.noWrap,
    );
  }

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
                        MenuFlyoutItem(text: const Text('내정보'), onPressed: () {}),
                        const MenuFlyoutSeparator(),
                        MenuFlyoutItem(text: const Text('결제'), onPressed: () {}),
                        const MenuFlyoutSeparator(),
                        MenuFlyoutItem(text: const Text('로그아웃'), onPressed: () {}),
                      ]),
                  const SizedBox(
                    width: 20,
                  ),
                  menuCommandBar(context, controller),
                  // Expanded(
                  //   child: searchBar(controller),
                  // ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            backgroundColor: theme.isdark.isTrue ? DEFAULT_DARK_COLOR : DEFAULT_LIGHT_COLOR,
            actions: FlyoutTarget(
              controller: _flyoutController,
              child: IconButton(
                icon: Icon(
                  FluentIcons.status_circle_question_mark,
                  size: 40,
                  color: theme.isdark.isTrue ? DEFAULT_LIGHT_COLOR : DEFAULT_DARK_COLOR,
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
                icon: controller.paneIsOpen.isTrue ? const Icon(FluentIcons.chrome_back) : const Icon(FluentIcons.chrome_back_mirrored),
                onPressed: () {
                  controller.paneIsOpen.value = !controller.paneIsOpen.value;
                },
              ),
            ),
            displayMode: controller.paneIsOpen.isTrue ? PaneDisplayMode.open : PaneDisplayMode.compact,
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
