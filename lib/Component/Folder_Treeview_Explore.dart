import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/FolderTreeView_MenuFlyout.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:get/get.dart';

///각 탭의 대시보드에서 폴더 리스트를 보여주는 위젯
class FolderTreeViewExplore extends StatelessWidget {
  FolderTreeViewExplore({
    this.tagName,
    super.key,
  });

  final String? tagName;
  final flyoutController = FlyoutController();
  final TextEditingController reNameController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<FolderController>(
      builder: (controller) {
        return FlyoutTarget(
          controller: flyoutController,
          child: TreeView(
            onSecondaryTap: (item, details) {
              flyoutController.showFlyout(
                position: details.globalPosition,
                builder: (context) {
                  return FolderTreeView_MenuFlyout(
                    folderController: controller,
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
                controller.selectedDirectoryID.value = item.value["id"];
                controller.firstFolders.refresh();
                await controller.getPath();
                //debugPrint("${controller.selectedDirectoryID.value}");
                if (Get.find<TabController>().currentTabIndex.value == 0) {
                  controller.makeProblemListInNewTab(item);
                } else {
                  final tabController = Get.find<TabController>();
                  Tab currentTab =
                      tabController.tabs[tabController.currentTabIndex.value];
                  tabController.renameTab(currentTab, item.value["name"],
                      const Icon(FluentIcons.fabric_folder));
                  await controller.makeProblemListInCurrentTab(item, tagName!);
                }
              }
            },
            items: controller.firstFolders,
          ),
        );
      },
    );
  }
}
