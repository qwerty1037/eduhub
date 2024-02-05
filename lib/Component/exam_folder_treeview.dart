import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/exam_menuflyout.dart';
import 'package:front_end/Component/New_Folder_Button.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:front_end/Controller/ScreenController/home_screen_controller.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:front_end/Controller/exam_controller.dart';
import 'package:get/get.dart';

///각 탭의 대시보드에서 시험지 폴더 리스트를 보여주는 위젯
class ExamFolderTreeView extends StatelessWidget {
  ExamFolderTreeView({
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
      return homeScreenController.isExamFolderEmpty
          ? newExamFolderButton(context)
          : Column(
              children: [
                GetX<UserDataController>(builder: (controller) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text("${controller.nickName.value}의 시험지 폴더"),
                  );
                }),
                FlyoutTarget(
                  controller: flyoutController,
                  child: GetX<UserDataController>(
                    builder: (controller) {
                      return TreeView(
                        onSecondaryTap: (item, details) {
                          flyoutController.showFlyout(
                            position: details.globalPosition,
                            builder: (context) {
                              return ExamFolderMenuFlyout(
                                userDataController: controller,
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
                            controller.selectedExamDirectoryID.value = item.value["id"];
                            controller.rootExamFolders.refresh();
                            if (Get.find<FluentTabController>().currentTabIndex.value == 0) {
                              controller.examViewerInNewTab(item, context);
                            } else if (tagName != null && Get.find<DefaultTabBodyController>(tag: tagName).dashBoardType == DashBoardType.exam) {
                              Get.find<ExamController>(tag: tagName).selectedFolder = item.value["id"];
                            } else {
                              //학생 창에서 시험지 폴더 클릭할 경우 폴더 클릭시 필요한 작업 TODO: 필요없을시 삭제 예정
                              // final tabController = Get.find<FluentTabController>();
                              // Tab currentTab = tabController.tabs[tabController.currentTabIndex.value];
                              // tabController.renameTab(currentTab, item.value["name"], const Icon(FluentIcons.text_document));
                              // await controller.makeExamViewerInCurrentTab(item, tagName!);
                            }
                          }
                        },
                        items: controller.rootExamFolders,
                      );
                    },
                  ),
                ),
              ],
            );
    });
  }
}
