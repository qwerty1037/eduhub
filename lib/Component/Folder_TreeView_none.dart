import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/FolderTreeView_MenuFlyout.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';

///각 탭의 대시보드에서 폴더 리스트를 보여주는 위젯
class FolderTreeViewNone extends StatelessWidget {
  FolderTreeViewNone({
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
        GetX<FolderController>(
          builder: (controller) {
            return FlyoutTarget(
              controller: flyoutController,
              child: TreeView(
                narrowSpacing: controller.temp_variable.value,
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
                onItemInvoked: (item, reason) async {},
                items: controller.firstFolders,
              ),
            );
          },
        ),
      ],
    );
  }
}
