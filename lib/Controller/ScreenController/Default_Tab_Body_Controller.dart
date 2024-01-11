import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/exam_folder_treeview.dart';
import 'package:front_end/Component/folder_treeView_none.dart';
import 'package:front_end/Component/folder_treeview_explore.dart';
import 'package:front_end/Component/folder_treeview_save.dart';
import 'package:front_end/Controller/ScreenController/Pdf_Save_Screen_Controller.dart';
import 'package:front_end/Controller/ScreenController/Pdf_Viewer_Screen_Controller.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tag_Controller.dart';
import 'package:front_end/Controller/desktop_Controller.dart';
import 'package:front_end/Controller/exam_controller.dart';
import 'package:front_end/Screen/Group.dart';

import 'package:get/get.dart';

///각 탭을 관리하는 컨트롤러
class DefaultTabBodyController extends GetxController {
  final String tagName;
  DashBoardType dashBoardType;

  Rx<Widget> workingSpaceWidget = Obx(() => Container(
        color: Get.find<DesktopController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
        child: const Center(child: Text("폴더 또는 기능을 선택해주세요")),
      )).obs;

  Widget realWorkingSpaceWidget = Container(
    color: Get.find<DesktopController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
    child: const Center(child: Text("폴더 또는 기능을 선택해주세요")),
  );

  late Rx<Widget> dashBoard;

  Widget? savedWorkingSpace;

  DefaultTabBodyController(this.tagName, this.dashBoardType, Widget? workingSpace) {
    if (workingSpace != null) {
      changeWorkingSpace(workingSpace);
    }
    dashBoard = makeDashBoard(dashBoardType).obs;
  }

  ///현재 작업창 내용을 저장하는 함수
  void saveThisWorkingSpace() {
    savedWorkingSpace = workingSpaceWidget.value;
  }

  ///default tab body의 workingspace부분을 바꾸는 method
  void changeWorkingSpace(Widget newWorkingSpace) {
    workingSpaceWidget.value = Obx(() => Container(
          color: Get.find<DesktopController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
          child: newWorkingSpace,
        ));
    realWorkingSpaceWidget = Container(
      color: Get.find<DesktopController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
      child: newWorkingSpace,
    );
  }

  ///현재 탭 안에서 만들어진 컨트롤러들을 제거하는 함수
  Future<void> deleteWorkingSpaceController() async {
    savedWorkingSpace = null;
    String tag = tagName;
    await Get.delete<PdfSaveController>(tag: tag);
    await Get.delete<PdfViewerScreenController>(tag: "Problem$tag");
    await Get.delete<PdfViewerScreenController>(tag: "Answer$tag");
    await Get.delete<SearchScreenController>(tag: tag);
    await Get.delete<ProblemListController>(tag: tag);
    await Get.delete<TagController>(tag: tag);
    await Get.delete<ExamController>(tag: tag);
  }

  Widget makeDashBoard(DashBoardType type) {
    dashBoardType = type;
    switch (type) {
      case DashBoardType.explore:
        return FolderTreeViewExplore(
          tagName: tagName,
        );
      case DashBoardType.savePdf:
        return FolderTreeViewSave(
          tagName: tagName,
        );
      case DashBoardType.exam:
        return FolderTreeViewNone(
          tagName: tagName,
        );
      case DashBoardType.search:
        return FolderTreeViewExplore(
          tagName: tagName,
        );
      case DashBoardType.tagManagement:
        return FolderTreeViewExplore(
          tagName: tagName,
        );
      case DashBoardType.none:
        return FolderTreeViewExplore(
          tagName: tagName,
        );
      case DashBoardType.examExplore:
        return ExamFolderTreeView();
      case DashBoardType.group:
        return Group(
          tagName: tagName,
        );
    }
  }
}
