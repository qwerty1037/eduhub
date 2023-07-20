import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/FolderTreeView_MenuFlyout.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';

class HomeTreeView extends StatelessWidget {
  HomeTreeView({super.key});

  final flyoutController = FlyoutController();
  final TextEditingController reNameController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<FolderController>(
      builder: (folderController) {
        return FlyoutTarget(
          controller: flyoutController,
          child: TreeView(
            items: folderController.firstFolders,
            onSecondaryTap: (item, details) {
              flyoutController.showFlyout(
                position: details.globalPosition,
                builder: (context) {
                  return FolderTreeView_MenuFlyout(
                    folderController: folderController,
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
                //폴더 직속 문제들만 받아오기
                await folderController.makeProblemListInNewTab(item);
              }
            },
          ),
        );
      },
    );
  }
}
