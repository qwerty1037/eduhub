import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/tabview_screen.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int selectedIndex = 0;
  List<NavigationPaneItem> paneItemList = [
    PaneItem(
      icon: const Icon(
        FluentIcons.recent,
        size: 20,
      ),
      title: const Text("최근 기록"),
      body: const Text("최근 기록 페이지"),
    ),
    PaneItem(
      icon: const Icon(
        FluentIcons.database,
        size: 20,
      ),
      title: const Text("데이터베이스"),
      body: const Text("데이터베이스 페이지"),
    ),
    PaneItem(
      icon: const Icon(
        FluentIcons.fabric_folder,
        size: 20,
      ),
      title: const Text("1 프로젝트"),
      body: const TabViewScreen(),
    ),
    PaneItem(
      icon: const Icon(
        FluentIcons.fabric_folder,
        size: 20,
      ),
      title: const Text("2 프로젝트"),
      body: const Text("2 프로젝트 페이지"),
    ),
    PaneItem(
      icon: const Icon(
        FluentIcons.fabric_folder,
        size: 20,
      ),
      title: const Text("3 프로젝트"),
      body: const Text("3 프로젝트 페이지"),
    ),
    PaneItem(
      icon: const Icon(
        FluentIcons.add,
        size: 20,
      ),
      body: const Text("New project"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: _getAppBar(),
      pane: _getNavigationPane(),
    );
  }

  NavigationAppBar _getAppBar() {
    return NavigationAppBar(
      leading: null,
      title: const SizedBox(
        child: Text('바선생'),
      ),
      actions: Row(
        children: [
          const Text('검색창 들어갈 부분'),
          IconButton(
              icon: const Icon(FluentIcons.status_circle_question_mark),
              onPressed: () {
                //유튜브 영상, 피드백 보내기, 언어바꿈 등
              })
        ],
      ),
    );
  }

  NavigationPane _getNavigationPane() {
    return NavigationPane(
        size: const NavigationPaneSize(
          openMinWidth: 250.0,
          openMaxWidth: 320.0,
        ),
        selected: selectedIndex,
        onChanged: (value) {
          if (value != paneItemList.length - 1) {
            setState(() {
              selectedIndex = value;
            });
          } else {
            setState(() {
              paneItemList.insert(
                paneItemList.length - 1,
                PaneItem(
                  icon: const Icon(
                    FluentIcons.recent,
                    size: 20,
                  ),
                  title: const Text("새 프로젝트"),
                  body: const Text("새 프로젝트 눌렀을 때 나올 부분"),
                  //수정 필요
                ),
              );
            });
          }
        },
        items: paneItemList);
  }
}
