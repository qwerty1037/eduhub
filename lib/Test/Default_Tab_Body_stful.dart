// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:front_end/Component/Default/Config.dart';
// import 'package:front_end/Component/Folder_Treeview_Explore.dart';
// import 'package:front_end/Component/New_Folder_Button.dart';
// import 'package:front_end/Component/Search_Bar_Overlay.dart';
// import 'package:front_end/Controller/Folder_Controller.dart';
// import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
// import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
// import 'package:front_end/Controller/Search_Controller.dart';
// import 'package:front_end/Controller/Tab_Controller.dart';
// import 'package:front_end/Controller/Total_Controller.dart';
// import 'package:front_end/Screen/Pdf_Viewer_Screen.dart';
// import 'package:front_end/Screen/Tag_Management_Screen.dart';
// import 'package:get/get.dart';

// class DefaultTabBody extends StatefulWidget {
//   DefaultTabBody({
//     super.key,
//     required this.dashBoardType,
//     this.workingSpace,
//   }) {
//     tagName = tabController.getNewTabKey();
//     _defaultTabBodyController = Get.put(
//         DefaultTabBodyController(tagName, dashBoardType, workingSpace),
//         tag: tagName);
//   }
//   final DashBoardType dashBoardType;
//   final Widget? workingSpace;
//   final TabController tabController = Get.find<TabController>();
//   late DefaultTabBodyController _defaultTabBodyController;

//   late final String tagName;

//   @override
//   State<DefaultTabBody> createState() => _DefaultTabBodyState();
// }

// class _DefaultTabBodyState extends State<DefaultTabBody>
//     with AutomaticKeepAliveClientMixin<DefaultTabBody> {
//   @override
//   bool get wantKeepAlive => true;
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     debugPrint(widget.tagName);
//     return GetX<DefaultTabBodyController>(
//       tag: widget.tagName,
//       builder: (controller) {
//         return Column(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: 40,
//               child: topCommandBar(controller, context),
//             ),
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width / 6,
//                       child: controller.dashBoard.value,
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Get.find<TotalController>().isDark.value == true
//                           ? Colors.grey[150]
//                           : Colors.grey[30],
//                       border: Border(
//                         left: BorderSide(
//                           color:
//                               Get.find<TotalController>().isDark.value == true
//                                   ? Colors.grey[130]
//                                   : Colors.grey[50],
//                           width: 1,
//                         ),
//                       ),
//                     ),
//                     width: MediaQuery.of(context).size.width / 6 * 5,
//                     child: controller.workingSpaceWidget.value,
//                   )
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Center topCommandBar(
//       DefaultTabBodyController controller, BuildContext context) {
//     final menuCommandBarItems = <CommandBarItem>[
//       CommandBarBuilderItem(
//         builder: (context, mode, widget) => Tooltip(
//           message: "hwp, pdf 파일에서 문제 추출",
//           child: widget,
//         ),
//         wrappedItem: CommandBarButton(
//           icon: const Icon(FluentIcons.save),
//           label: const Text("문제 저장",
//               style: TextStyle(
//                 fontSize: 15,
//               )),
//           onPressed: () async {
//             await controller.deleteWorkingSpaceController();
//             controller.changeWorkingSpace(
//               const PdfViewerScreen(),
//             );
//             controller.dashBoard.value =
//                 controller.makeDashBoard(DashBoardType.savePdf);
//             Tab currentTab = widget
//                 .tabController.tabs[widget.tabController.currentTabIndex.value];
//             widget.tabController
//                 .renameTab(currentTab, "문제 저장", const Icon(FluentIcons.save));
//           },
//         ),
//       ),
//       CommandBarBuilderItem(
//         builder: (context, mode, widget) => Tooltip(
//           message: "시험지 만들기",
//           child: widget,
//         ),
//         wrappedItem: CommandBarButton(
//           icon: const Icon(FluentIcons.page),
//           label: const Text("시험지",
//               style: TextStyle(
//                 fontSize: 15,
//               )),
//           onPressed: () {},
//         ),
//       ),
//       CommandBarBuilderItem(
//         builder: (context, mode, widget) => Tooltip(
//           message: "학생 관리",
//           child: widget,
//         ),
//         wrappedItem: CommandBarButton(
//           icon: const Icon(FluentIcons.page),
//           label: const Text("학생",
//               style: TextStyle(
//                 fontSize: 15,
//               )),
//           onPressed: () {},
//         ),
//       ),
//       CommandBarBuilderItem(
//         builder: (context, mode, widget) => Tooltip(
//           message: "문제 검색",
//           child: widget,
//         ),
//         wrappedItem: CommandBarButton(
//           icon: const Icon(FluentIcons.search),
//           label: const Text("검색",
//               style: TextStyle(
//                 fontSize: 15,
//               )),
//           onPressed: () async {
//             createHighlightOverlay(
//                 context: context,
//                 controller:
//                     Get.put(SearchScreenController(), tag: controller.tagName),
//                 tabController: widget.tabController);

//             controller.dashBoard.value =
//                 controller.makeDashBoard(DashBoardType.search);
//           },
//         ),
//       ),
//       CommandBarBuilderItem(
//         builder: (context, mode, widget) => Tooltip(
//           message: "태그 만들기",
//           child: widget,
//         ),
//         wrappedItem: CommandBarButton(
//           icon: const Icon(FluentIcons.tag),
//           label: const Text("태그",
//               style: TextStyle(
//                 fontSize: 15,
//               )),
//           onPressed: () async {
//             await controller.deleteWorkingSpaceController();
//             controller.changeWorkingSpace(TagManagementScreen());
//             controller.dashBoard.value =
//                 controller.makeDashBoard(DashBoardType.tagManagement);
//             Tab currentTab = widget
//                 .tabController.tabs[widget.tabController.currentTabIndex.value];
//             widget.tabController
//                 .renameTab(currentTab, "태그", const Icon(FluentIcons.tag));
//           },
//         ),
//       ),
//     ];

//     return Center(
//       child: CommandBar(
//         primaryItems: menuCommandBarItems,
//         overflowBehavior: CommandBarOverflowBehavior.noWrap,
//       ),
//     );
//   }
// }
