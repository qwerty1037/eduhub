import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Controller/problem_list_controller.dart';
import 'package:front_end/Screen/db_edit_screen.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

///문제 이미지 뷰어 + 왼쪽 문제 리스트

class ProblemViewer extends StatelessWidget {
  const ProblemViewer({super.key, required this.controller});

  final ProblemListController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: controller.isOneColumn.value ? 5 : 2,
      child: Obx(
        () => Column(
          children: [
            controller.problemFileType.value == fileType.empty
                ? const Expanded(
                    child: Center(
                    child: Text("왼쪽에서 문제를 클릭해주세요"),
                  ))
                : Expanded(
                    child: Column(
                      children: [
                        controller.problemFileType.value == fileType.pdf
                            ? Expanded(child: SfPdfViewer.memory(Uint8List.fromList(controller.bytes)))
                            : Expanded(child: Image.memory(Uint8List.fromList(controller.bytes))),
                        Button(
                          onPressed: () {
                            displayInfoBar(
                              context,
                              builder: (context, close) {
                                return const InfoBar(
                                  title: Text('수정하기:'),
                                  content: Text(
                                    '현재 준비 중인 기능입니다',
                                  ),
                                  severity: InfoBarSeverity.info,
                                );
                              },
                            );
                            //TODO : Redirect to DBEditScreen
                          },
                          child: const Text("수정하기"),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

Widget columnProblemList(ProblemListController controller) {
  return Obx(
    () => GridView.count(
        crossAxisCount: controller.isOneColumn.value ? 1 : 2,
        childAspectRatio: 7,
        children: controller.currentPageProblems.map((element) {
          return Button(
            onPressed: () async {
              // ${element["problem_string"].toString().substring(4, element["problem_string"].length - 1)}
              final url = Uri.parse('https://$HOST/api/data/problem-pdf/${element["problem_string"]}');
              final response = await http.get(
                url,
                headers: await defaultHeader(httpContentType.json),
              );
              if (isHttpRequestSuccess(response)) {
                debugPrint("문제 클릭");
                controller.bytes.value = response.bodyBytes;
                if (controller.bytes.length >= 4 &&
                    controller.bytes[0] == 37 &&
                    controller.bytes[1] == 80 &&
                    controller.bytes[2] == 68 &&
                    controller.bytes[3] == 70) {
                  controller.problemFileType.value = fileType.pdf;
                } else if (controller.bytes.length >= 2 && controller.bytes[0] == 255 && controller.bytes[1] == 216) {
                  controller.problemFileType.value = fileType.jpg;
                } else if (controller.bytes.length >= 8 &&
                    controller.bytes[0] == 137 &&
                    controller.bytes[1] == 80 &&
                    controller.bytes[2] == 78 &&
                    controller.bytes[3] == 71 &&
                    controller.bytes[4] == 13 &&
                    controller.bytes[5] == 10 &&
                    controller.bytes[6] == 26 &&
                    controller.bytes[7] == 10) {
                  controller.problemFileType.value = fileType.png;
                } else {
                  debugPrint("pdf, jpg, png 형태의 파일이 아닙니다");
                }
                controller.bytes.refresh();
              } else {
                controller.problemFileType.value = fileType.empty;
                debugPrint(response.statusCode.toString());
                debugPrint("문제 이미지 불러오기 오류 발생(problem_viewer)");
              }
            },
            child: SizedBox(
              height: 100,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(element["name"]), Text("난이도 : ${element["level"]}")],
                ),
              ),
            ),
          );
        }).toList()),
  );
}
