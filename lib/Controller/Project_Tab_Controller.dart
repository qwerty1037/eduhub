import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Custom_TreeViewItem.dart';
import 'package:get/get.dart';

class ProjectTabController extends GetxController {
  RxList<TreeViewItem> folderList = [
    DraggableTreeViewItem(content: const Text("테스트")),
    TreeViewItem(content: const Text("하이탑 수학학원"), value: '1', children: [
      TreeViewItem(content: const Text('2022'), value: '2', children: [
        TreeViewItem(
          content: const Text('중1'),
          value: '3',
        ),
        TreeViewItem(
          content: const Text('중2'),
          value: '4',
        ),
        TreeViewItem(
          content: const Text('중3'),
          value: '5',
        ),
        TreeViewItem(
          content: const Text('중4'),
          value: '6',
        ),
      ])
    ])
  ].obs;
}
