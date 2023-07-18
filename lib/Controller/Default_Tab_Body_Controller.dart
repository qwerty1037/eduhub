import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/Pdf_Save_Controller.dart';
import 'package:front_end/Controller/Pdf_Viewer_Screen_Controller.dart';
import 'package:front_end/Controller/Problem_List_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Tag_Controller.dart';

import 'package:get/get.dart';

class DefaultTabBodyController extends GetxController {
  Container workingSpaceWidget = Container(
    color: Colors.white,
    child: const Center(child: Text("폴더 또는 기능을 선택해주세요")),
  );

  Widget? savedWorkingSpace;

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
    String tag = Get.find<TabController>().getCurrentTabKey();
    await Get.delete<PdfSaveController>(tag: tag);
    await Get.delete<PdfViewerScreenController>(tag: "Problem$tag");
    await Get.delete<PdfViewerScreenController>(tag: "Answer$tag");
    await Get.delete<SearchScreenController>(tag: tag);
    await Get.delete<ProblemListController>(tag: tag);
    await Get.delete<TagController>(tag: tag);
  }
}
