import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Folder_Treeview_Explore.dart';
import 'package:front_end/Controller/ScreenController/Pdf_Save_Screen_Controller.dart';
import 'package:front_end/Controller/ScreenController/Pdf_Viewer_Screen_Controller.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Tag_Controller.dart';

import 'package:get/get.dart';

///각 탭을 관리하는 컨트롤러
class DefaultTabBodyController extends GetxController {
  final String tagName;
  final DashBoardType dashBoardType;

  Container workingSpaceWidget = Container(
    color: Colors.white,
    child: const Center(child: Text("폴더 또는 기능을 선택해주세요")),
  );

  Widget? savedWorkingSpace;

  DefaultTabBodyController(this.tagName, this.dashBoardType, Widget? workingSpace) {
    if (workingSpace != null) {
      changeWorkingSpace(workingSpace);
    }
  }

  ///현재 작업창 내용을 저장하는 함수
  void saveThisWorkingSpace() {
    savedWorkingSpace = workingSpaceWidget;
  }

  ///default tab body의 workingspace부분을 바꾸는 method
  void changeWorkingSpace(Widget newWorkingSpace) {
    workingSpaceWidget = Container(child: newWorkingSpace);
    update();
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
  }

  Widget dashBoard(DashBoardType dashBoardType) {
    switch (dashBoardType) {
      case DashBoardType.explore:
        return FolderTreeView(
          tagName: tagName,
        );
      case DashBoardType.savePdf:
        return FolderTreeView(
          tagName: tagName,
        );
      case DashBoardType.search:
        return FolderTreeView(
          tagName: tagName,
        );
      case DashBoardType.tagManagement:
        return FolderTreeView(
          tagName: tagName,
        );
    }
  }
}
