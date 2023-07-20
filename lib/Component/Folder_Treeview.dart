import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/FolderTreeView_MenuFlyout.dart';
import 'package:front_end/Controller/Folder_Controller.dart';

class FolderTreeView extends StatelessWidget {
  FolderTreeView(this.folderController, this.tagName, {super.key});

  FolderController folderController;
  String tagName;
  final flyoutController = FlyoutController();
  final TextEditingController reNameController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: flyoutController,
      child: TreeView(
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
            await folderController.makeProblemListInCurrentTab(item, tagName);
          }
        },
        items: folderController.firstFolders,
      ),
    );
  }
}
