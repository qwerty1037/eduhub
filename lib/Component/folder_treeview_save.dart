import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/new_folder_button.dart';
import 'package:front_end/Component/folder_treeview_menuflyout.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/ScreenController/home_screen_controller.dart';
import 'package:get/get.dart';

///각 탭의 대시보드에서 폴더 리스트를 보여주는 위젯
class FolderTreeViewSave extends StatelessWidget {
  FolderTreeViewSave({
    this.tagName,
    super.key,
  });

  final String? tagName;
  final flyoutController = FlyoutController();
  final TextEditingController reNameController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(builder: (homeScreenController) {
      return homeScreenController.isFolderEmpty
          ? newFolderButton(context)
          : Column(
              children: [
                GetX<UserDataController>(builder: (controller) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text("${controller.nickName.value}의 문제 폴더"),
                  );
                }),
                GetX<UserDataController>(
                  builder: (controller) {
                    return FlyoutTarget(
                      controller: flyoutController,
                      child: TreeView(
                        onSecondaryTap: (item, details) {
                          flyoutController.showFlyout(
                            position: details.globalPosition,
                            builder: (context) {
                              return FolderTreeViewMenuFlyout(
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
                            controller.selectedProblemDirectoryId.value = item.value["id"];
                            controller.rootProblemFolders.refresh();
                            await controller.getPath();
                          }
                        },
                        items: controller.rootProblemFolders,
                      ),
                    );
                  },
                ),
              ],
            );
    });
  }
}
