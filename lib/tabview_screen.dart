import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/new_tab.dart';

class TabViewScreen extends StatefulWidget {
  const TabViewScreen({super.key});

  @override
  State<TabViewScreen> createState() => _TabViewScreenState();
}

class _TabViewScreenState extends State<TabViewScreen> {
  int currentIndex = 1;
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
          if (currentIndex > 0) {
            currentIndex--;
          }
        });
      },
    );
    return newTab;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: TabView(
        currentIndex: currentIndex,
        tabs: tabs,
        tabWidthBehavior: TabWidthBehavior.sizeToContent,
        closeButtonVisibility: CloseButtonVisibilityMode.onHover,
        showScrollButtons: true,
        onChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        onNewPressed: () {
          setState(() {
            final newTab = generateTab(const NewTabScreen());
            tabs.add(newTab);
            currentIndex = tabs.length;
          });
        },
      ),
    );
  }
}
