import 'package:fluent_ui/fluent_ui.dart';

import 'package:front_end/Component/Folder_Treeview.dart';
import 'package:front_end/Component/Search_Bar_OverLay.dart';
import 'package:front_end/Controller/Default_Tab_Body_Controller.dart';

import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Screen/Pdf_Viewer_Screen.dart';
import 'package:front_end/Screen/Tag_Management_Screen.dart';
import 'package:get/get.dart';

class DefaultTabBody extends StatelessWidget {
  Widget? workingSpace;
  DefaultTabBody({super.key, this.workingSpace});
  final FlyoutController _flyoutController = FlyoutController();
  TabController tabController = Get.find<TabController>();

  @override
  Widget build(BuildContext context) {
    DefaultTabBodyController firstController = Get.put(
        DefaultTabBodyController(),
        tag: tabController.getCurrentTabKey());
    if (workingSpace != null) {
      firstController.workingSpaceWidget = Container(child: workingSpace);
    }
    FolderController foldercontroller = Get.find<FolderController>();

    return GetBuilder<DefaultTabBodyController>(
      tag: tabController.getCurrentTabKey(),
      builder: (controller) {
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              color: Colors.teal,
              child: topCommandBar(controller, context),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                      child: FolderTreeView(
                          foldercontroller, tabController.getCurrentTabKey()),
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left:
                                  BorderSide(color: Colors.black, width: 0.5))),
                      width: MediaQuery.of(context).size.width / 6 * 5,
                      child: controller.workingSpaceWidget)
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Center topCommandBar(
      DefaultTabBodyController controller, BuildContext context) {
    final menuCommandBarItems = <CommandBarItem>[
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Save your Pdf files!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.save),
          label: const Text("Save Pdf",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () async {
            await controller.deleteWorkingSpaceController();
            controller.changeWorkingSpace(
              const PdfViewerScreen(),
            );
            Tab currentTab =
                tabController.tabs[tabController.currentTabIndex.value];
            tabController.renameTab(currentTab, "Save Pdf");
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Create Test!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("Create Test",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Manage your students!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.page),
          label: const Text("Student Management",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () {},
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Search your problems!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.search),
          label: const Text("Search",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () async {
            await controller.deleteWorkingSpaceController();
            createHighlightOverlay(
                context: context,
                controller: controller,
                tabController: tabController);
          },
        ),
      ),
      CommandBarBuilderItem(
        builder: (context, mode, widget) => Tooltip(
          message: "Make your tags!",
          child: widget,
        ),
        wrappedItem: CommandBarButton(
          icon: const Icon(FluentIcons.tag),
          label: const Text("Tags",
              style: TextStyle(
                fontSize: 15,
              )),
          onPressed: () async {
            await controller.deleteWorkingSpaceController();
            controller.changeWorkingSpace(TagManagementScreen());
            Tab currentTab =
                tabController.tabs[tabController.currentTabIndex.value];
            tabController.renameTab(currentTab, "Generate Tags");
          },
        ),
      ),
    ];

    return Center(
      child: CommandBar(
        primaryItems: menuCommandBarItems,
        overflowBehavior: CommandBarOverflowBehavior.noWrap,
      ),
    );
  }
}
