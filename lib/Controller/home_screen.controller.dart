import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/project_navigation_body.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList<NavigationPaneItem> paneItemList = RxList<NavigationPaneItem>();
  RxBool paneIsOpen = true.obs;

  HomeScreenController() {
    paneItemList.addAll([
      PaneItem(
        icon: const Icon(
          FluentIcons.recent,
          size: 20,
        ),
        title: const Text("최근 기록"),
        body: const Center(child: Text("최근 기록 페이지")),
      ),
      PaneItem(
        icon: const Icon(
          FluentIcons.database,
          size: 20,
        ),
        title: const Text("문제 모음"),
        body: const Center(child: Text("문제 모음 페이지")),
      ),
      PaneItem(
        icon: const Icon(
          FluentIcons.fabric_folder,
          size: 20,
        ),
        title: const Text("1 프로젝트"),
        body: Container(
          color: Colors.teal,
          child: ProjectNavigationBody(
            projectName: "1 프로젝트",
          ),
        ),
      ),
      PaneItem(
        icon: const Icon(
          FluentIcons.fabric_folder,
          size: 20,
        ),
        title: const Text("2 프로젝트"),
        body: Container(
          color: Colors.teal,
          child: ProjectNavigationBody(
            projectName: "2 프로젝트",
          ),
        ),
      ),
      PaneItem(
          icon: const Icon(
            FluentIcons.fabric_folder,
            size: 20,
          ),
          title: const Text("3 프로젝트"),
          body: Container(
            color: Colors.teal,
            child: ProjectNavigationBody(
              projectName: "3 프로젝트",
            ),
          )),
      PaneItem(
        icon: const Icon(
          FluentIcons.add,
          size: 20,
        ),
        title: const Text("New Project"),
        body: Container(
          color: Colors.teal,
          child: ProjectNavigationBody(),
        ),
      ),
    ]);
  }

  void onChanged(int value) {
    if (value != paneItemList.length - 1) {
      selectedIndex.value = value;
    } else {
      paneItemList.insert(
        paneItemList.length - 1,
        PaneItem(
          icon: const Icon(
            FluentIcons.fabric_folder,
            size: 20,
          ),
          title: const Text("새 프로젝트"),
          body: const Text("새 프로젝트 눌렀을 때 나올 부분"),
        ),
      );
      selectedIndex.value = paneItemList.length - 2;
    }
  }
}
