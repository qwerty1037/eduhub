import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/Project_Tab_Controller.dart';
import 'package:get/get.dart';

class ProjectTabScreen extends StatelessWidget {
  const ProjectTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProjectTabController());

    ///나중에 폴더 선택해서 할 작업이 있으면 oniteminvoked랑 selectionMode등 넣으면 구현가능
    return GetX<ProjectTabController>(
      builder: (controller) {
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TreeView(
                    shrinkWrap: true,
                    items: controller.folderList,
                    onSecondaryTap: (item, details) {
                      debugPrint(item.content.toString());
                      print(controller.folderList);
                      controller.folderList.remove(item);
                      print(controller.folderList);
                      //폴더 관련 삭제(프론트, 백 구현)
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: DragTarget(
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (data) {
                  print(data.toString());
                },
                builder: ((context, candidateData, rejectedData) {
                  return Container(
                    color: Colors.grey,
                  );
                }),
              ),
            )
          ],
        );
      },
    );
  }
}
