import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Exam_MenuFlyout.dart';
import 'package:front_end/Component/FolderTreeView_MenuFlyout.dart';
import 'package:front_end/Component/New_Folder_Button.dart';
import 'package:front_end/Controller/ExamController.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:get/get.dart';

///각 탭의 대시보드에서 폴더 리스트를 보여주는 위젯
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
                GetX<FolderController>(builder: (controller) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text("${controller.nickName.value}의 시험지 폴더"),
                  );
                }),
                FlyoutTarget(
                  controller: flyoutController,
                  child: GetX<FolderController>(
                    builder: (controller) {
                      return TreeView(
                        narrowSpacing: controller.temp_variable.value,
                        onSecondaryTap: (item, details) {
                          flyoutController.showFlyout(
                            position: details.globalPosition,
                            builder: (context) {
                              return ExamFolderMenuFlyout(
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
                            controller.selectedExamDirectoryID.value = item.value["id"];
                            controller.firstExamFolders.refresh();
                            if (Get.find<TabController>().currentTabIndex.value == 0) {
                              //TODO 새 탭에 시험지 뷰어 띄우기
                              debugPrint("뷰어 새 탭에 띄워주기");
                              // controller.makeProblemListInNewTab(item);
                            } else if (tagName != null && Get.find<DefaultTabBodyController>(tag: tagName).dashBoardType == DashBoardType.exam) {
                              Get.find<ExamController>(tag: tagName).selectedFolder = item.value["id"];
                            } else {
                              //TODO 학생 창에서 시험지 폴더 띄울경우 폴더 클릭시 필요한 작업

                              debugPrint("홈 화면이 아닙니다");
                            }
                          }
                        },
                        items: controller.firstExamFolders,
                      );
                    },
                  ),
                ),
              ],
            );
    });
  }
}
