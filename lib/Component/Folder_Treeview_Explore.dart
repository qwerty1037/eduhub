import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/FolderTreeView_MenuFlyout.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:get/get.dart';
import 'package:front_end/Component/Default/Config.dart';

///각 탭의 대시보드에서 폴더 리스트를 보여주는 위젯
class FolderTreeView extends StatelessWidget {
  FolderTreeView({
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
              /*
              for (int i = 0; i < controller.totalFolders.length; i++) {
                if (controller.totalFolders[i].value["id"] == controller.selectedDirectoryID?.value) {
                  String name = controller.totalFolders[i].value["name"];
                  int id = controller.totalFolders[i].value["id"];
                  int? parent = controller.totalFolders[i].value["parent"];
                  controller.totalFolders[i] = controller.makeFolderItem(name, id, parent);
                  break;
                }
              }
              controller.firstFolders.refresh();
              */
              if (reason == TreeViewItemInvokeReason.pressed) {
                controller.selectedDirectoryID.value = item.value["id"];
                debugPrint("${controller.selectedDirectoryID.value}");
                if (Get.find<TabController>().isHomeScreen.value) {
                  await controller.makeProblemListInNewTab(item);
                } else {
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
