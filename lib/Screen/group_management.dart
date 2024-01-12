import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/exam_viewer.dart';
import 'package:front_end/Controller/group_controller.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:front_end/Controller/user_desktop_controller.dart';
import 'package:get/get.dart';

class GroupManagementScreen extends StatelessWidget {
  GroupManagementScreen({super.key, required this.item, required this.controller});
  final TreeViewItem item;
  final GroupController controller;
  String tagName = Get.find<FluentTabController>().getTabKey();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          item.value["name"],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: GroupMenu(
                        menuText: "학생 관리",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: GroupMenu(
                        menuText: "과제 생성",
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: GroupMenu(
                        menuText: "과제 관리",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: GroupMenu(
                        menuText: "설정",
                        onTap: () {
                          DefaultTabBodyController workingSpaceController = Get.find<DefaultTabBodyController>(tag: tagName);
                          workingSpaceController.changeWorkingSpace(ExamViewer(examPdfFile: "examPdfFile"));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class GroupMenu extends StatelessWidget {
  const GroupMenu({Key? key, required this.menuText, required this.onTap}) : super(key: key);
  final String menuText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            color: Get.find<UserDesktopController>().isDark.value == true ? Colors.grey[130] : Colors.grey[50],
          ),
          child: Center(
            child: Text(
              menuText,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }
}
