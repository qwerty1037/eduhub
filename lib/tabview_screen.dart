import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/new_tab.dart';

class TabViewScreen extends StatefulWidget {
  const TabViewScreen({super.key});

  @override
  State<TabViewScreen> createState() => _TabViewScreenState();
}

class _TabViewScreenState extends State<TabViewScreen> {
  int currentTabIndex = 1;
  int selectedProjectIndex = 0;
  List<Tab> tabs = [
    Tab(
      text: const Text("test"),
      body: Container(
        color: Colors.orange,
      ),
    )
  ];

  Tab generateTab(Widget body) {
    Tab? newTab;
    newTab = Tab(
      text: Text(
        "New Tab",
        selectionColor: Colors.green,
      ),
      icon: const Icon(
        FluentIcons.file_template,
      ),
      body: body,
      onClosed: () {
        setState(() {
          tabs.remove(newTab);
          if (currentTabIndex > 0) {
            currentTabIndex--;
          }
        });
      },
    );
    return newTab;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const Text("header 자리"),
      content: Center(
        child: TabView(
          currentIndex: currentTabIndex,
          tabs: tabs,
          tabWidthBehavior: TabWidthBehavior.sizeToContent,
          closeButtonVisibility: CloseButtonVisibilityMode.onHover,
          showScrollButtons: true,
          onChanged: (index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          onNewPressed: () {
            setState(() {
              final newTab = generateTab(const NewTabScreen());
              tabs.add(newTab);
              currentTabIndex = tabs.length;
            });
          },
        ),
      ),
    );
  }
}
