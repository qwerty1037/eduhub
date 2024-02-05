// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart' as flutter_material;
// import 'package:front_end/Component/exam_viewer.dart';
// import 'package:front_end/Controller/problem_list_controller.dart';
// import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
// import 'package:front_end/Controller/fluent_tab_controller.dart';
// import 'package:get/get.dart';


// class ExamList extends StatelessWidget {
//   ExamList({super.key, required this.targetFolder, required this.folderName, required this.problems, required this.problemListController});
//   String folderName;
//   TreeViewItem targetFolder;
//   List<dynamic> problems;

//   final tag = Get.find<FluentTabController>().getTabKey();
//   ProblemListController problemListController;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Future.delayed(Duration.zero),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState != ConnectionState.none && snapshot.connectionState != ConnectionState.waiting) {
//             return Column(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       children: [
//                         Text(
//                           folderName,
//                           style: const TextStyle(fontSize: 30),
//                         ),
//                         const SizedBox(
//                           width: 200,
//                         ),
//                         GetX<ProblemListController>(
//                             tag: tag,
//                             builder: (controller) {
//                               return ToggleSwitch(
//                                 checked: controller.isAllProblems.value,
//                                 onChanged: (info) async {
//                                   await controller.resetVariable(targetFolder, problems);
//                                   controller.isAllProblems.value = info;
//                                 },
//                                 content: const Text('하위 폴더 포함'),
//                               );
//                             })
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 9,
//                   child: GetX<ProblemListController>(
//                       tag: tag,
//                       builder: (controller) {
//                         return Row(
//                           children: [
//                             Expanded(
//                               flex: 3,
//                               child: Container(
//                                 padding: const EdgeInsets.all(30),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: twoColumnExamList(controller),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: controller.pageButton,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(flex: 1, child: controller.problemImageViewer.value)
//                           ],
//                         );
//                       }),
//                 ),
//               ],
//             );
//           } else {
//             return const flutter_material.CircularProgressIndicator();
//           }
//         });
//   }

//   GridView twoColumnExamList(ProblemListController controller) {
//     return GridView.count(
//         crossAxisCount: 2,
//         childAspectRatio: 7,
//         children: controller.currentPageProblems.map((element) {
//           return Button(
//             onPressed: () async {
//               DefaultTabBodyController workingSpaceController = Get.find<DefaultTabBodyController>(tag: tag);
//               workingSpaceController.saveThisWorkingSpace();
//               workingSpaceController.changeWorkingSpace(ExamViewer(examPdfFile: "examPdfFile"));
//             },
//             child: SizedBox(
//               height: 100,
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [Text(element["name"]), Text("난이도 : ${element["level"]}")],
//                 ),
//               ),
//             ),
//           );
//         }).toList());
//   }
// }
