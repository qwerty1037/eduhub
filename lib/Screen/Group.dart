import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/GroupTreeView_MenuFlyout.dart';
import 'package:front_end/Controller/Group_TreeView_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:get/get.dart';

///각 탭의 대시보드에서 Group 리스트를 보여주는 위젯
class Group extends StatelessWidget {
  Group({
    this.tagName,
    super.key,
  });

  final String? tagName;
  final flyoutController = FlyoutController();
  final TextEditingController reNameController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("  ㅇㅇ님의 워크스페이스"),
        ),
        GetX<GroupTreeViewController>(
          builder: (controller) {
            return FlyoutTarget(
              controller: flyoutController,
              child: TreeView(
                onSecondaryTap: (item, details) {
                  flyoutController.showFlyout(
                    position: details.globalPosition,
                    builder: (context) {
                      return GroupTreeView_MenuFlyout(
                        groupController: controller,
                        item: item,
                        details: details,
                        reNameController: reNameController,
                        newNameController: newNameController,
                        flyoutController: flyoutController,
                      );
                    },
                  );
                },
                onItemInvoked: (item, reason) async {
                  if (reason == TreeViewItemInvokeReason.pressed) {
                    controller.selectedGroupID.value = item.value["id"];
                    controller.totalGroups.refresh();

                    final tabController = Get.find<TabController>();
                    Tab currentTab =
                        tabController.tabs[tabController.currentTabIndex.value];
                    tabController.renameTab(currentTab, item.value["name"],
                        const Icon(FluentIcons.fabric_folder));
                    await controller.makeGroupListInCurrentTab(item, tagName!);
                  }
                },
                items: controller.totalGroups,
              ),
            );
          },
        ),
      ],
    );
  }
}
