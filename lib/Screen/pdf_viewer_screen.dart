///Screen: File_Drag_and_Drop.
//import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:front_end/Component/Class/frame.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:front_end/Controller/ScreenController/pdf_viewer_screen_controller.dart';
import 'package:front_end/Controller/user_desktop_controller.dart';

import 'package:front_end/Screen/pdf_save_screen.dart';
import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfViewerScreen> {
  final controllerProblem = Get.put(PdfViewerScreenController(), tag: "Problem${Get.find<FluentTabController>().getTabKey()}");
  final controllerAnswer = Get.put(PdfViewerScreenController(), tag: "Answer${Get.find<FluentTabController>().getTabKey()}");
  Size renderSize = Size.zero;

  @override
  void initState() {
    super.initState();
    renderSize = _getSize();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Center(
        child: Container(
          color: Get.find<UserDesktopController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
          child: Stack(
            children: [
              Row(
                children: [
                  Obx(() {
                    return controllerProblem.showProcess.value
                        ? SpinKitWave(
                            duration: const Duration(seconds: 40),
                          )
                        : (controllerProblem.isPdfInputed.value ? pdfViewerContainer(controllerProblem, constraints) : selectPdfContainer(controllerProblem, constraints));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectPdfContainer(PdfViewerScreenController controller, constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: DropTarget(
        onDragDone: (detail) async {
          controller.onDragDone(
            detail,
            context,
          );
        },
        onDragEntered: (detail) {
          controller.onDragEntered(detail);
        },
        onDragExited: (detail) {
          controller.onDragExited(detail);
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            border: Border.all(width: 5, color: controller.buttoncolor()),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Drop Your ",
                    style: TextStyle(color: controller.buttoncolor()),
                  ),
                  Text(
                    ".pdf File",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: controller.buttoncolor(),
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    FluentIcons.insert_signature_line,
                    color: controller.buttoncolor(),
                  ),
                  Text(
                    " Here",
                    style: TextStyle(
                      color: controller.buttoncolor(),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  controller.fileUpload(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "or ",
                      style: TextStyle(
                        color: controller.buttoncolor(),
                      ),
                    ),
                    Text(
                      "Find and Upload",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.buttoncolor(),
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      FluentIcons.upload,
                      color: controller.buttoncolor(),
                    ),
                  ],
                ),
              ),
              Text(
                "(*.pdf)",
                style: TextStyle(
                  color: controller.buttoncolor(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                controller.getFileName()!,
                style: TextStyle(
                  color: controller.buttoncolor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Size _getSize() {
    if (_containerKey.currentContext != null) {
      final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
    return Size.zero;
  }

  Offset _getOffset() {
    if (_containerKey.currentContext != null) {
      final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      return offset;
    }
    return Offset.zero;
  }

  final GlobalKey _containerKey = GlobalKey();
  int selectedBoxIndex = 99999;

  Widget pdfViewerContainer(PdfViewerScreenController controller, constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      //color: Colors.black,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          const Icon(FluentIcons.quick_note),
                          Expanded(
                            child: Text(
                              "File name: ${controller.getFileName()}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: () {
                                controller.exitPdf();
                              },
                              child: const Icon(
                                FluentIcons.chrome_close,
                                //color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 1,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Obx(
                        () => InteractiveViewer(
                          key: _containerKey,
                          interactionEndFrictionCoefficient: double.infinity,
                          onInteractionUpdate: (details) {
                            setState(() {});
                          },
                          minScale: 1.0,
                          maxScale: 3.0,
                          child: Stack(
                            children: [
                              SizedBox(
                                child: Image.memory(controller.pickedPdfImageList[controller.pageIndex.value]),
                              ),
                              for (int idx = 0; idx < controller.rectList.length; idx++) ...[
                                TransformableBox(
                                  contentBuilder: (content, rect, flip) {
                                    return GestureDetector(
                                      onTap: () {
                                        selectedBoxIndex = idx;
                                        debugPrint("selected index : $idx");
                                        debugPrint("total box length: ${controller.rectList.length}");
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: (selectedBoxIndex == idx) ? Colors.red : Colors.red.withOpacity(0.9),
                                          ),
                                          color: (selectedBoxIndex == idx) ? Colors.red.withOpacity(0.5) : Colors.red.withOpacity(0.1),
                                        ),
                                      ),
                                    );
                                  },
                                  rect: controller.rectList[idx],
                                  onChanged: (result, event) {
                                    controller.rectList[idx] = result.rect;
                                    controller.rectList.refresh();
                                    if (controller.firstFrameFinished) {
                                      controller.pageRectList[controller.pageIndex.value] = <Rect>[];
                                      for (var element in controller.rectList) {
                                        controller.pageRectList[controller.pageIndex.value].add(element);
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: constraints.maxWidth / 2,
            height: constraints.maxHeight,
            child: Column(
              children: [
                controller.firstFrameFinished ? const Text("페이지별 문제 박스를 확인해주세요") : const Text("문제의 열에 맞게 프레임을 설정해주세요"),
                Text("현재 파일 용량:  ${controllerProblem.pickedFileSize.value} bytes"),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Button(
                      child: const Text("박스 생성"),
                      onPressed: () {
                        renderSize = _getSize();
                        controller.generateBox(renderSize);
                        setState(() {});
                      },
                    ),
                    Button(
                      child: const Text("박스 삭제"),
                      onPressed: () {
                        setState(() {
                          if (selectedBoxIndex == 99999) {
                          } else {
                            controller.deleteBox(selectedBoxIndex);
                            selectedBoxIndex = 99999;
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Button(
                      child: const Text("이전 페이지"),
                      onPressed: () {
                        if (controller.pageIndex.value == 0) {
                          displayInfoBar(
                            context,
                            builder: (context, close) {
                              return InfoBar(
                                severity: InfoBarSeverity.warning,
                                title: const Text('첫 페이지입니다'),
                                action: IconButton(
                                  icon: const Icon(FluentIcons.clear),
                                  onPressed: close,
                                ),
                              );
                            },
                          );
                        } else {
                          if (controller.firstFrameFinished) {
                            var toRemove = [];
                            for (var element in controller.secondFrameList) {
                              if (controller.pageIndex.value == element.page) {
                                toRemove.add(element);
                              }
                            }
                            controller.secondFrameList.removeWhere((e) => toRemove.contains(e));

                            for (var element in controller.pageRectList[controller.pageIndex.value]) {
                              Offset topLeft = element.topLeft;
                              Offset bottomRight = element.bottomRight;
                              double minX = topLeft.dx / renderSize.width;
                              double minY = topLeft.dy / renderSize.height;
                              double maxX = bottomRight.dx / renderSize.width;
                              double maxY = bottomRight.dy / renderSize.height;
                              Frame tempFrame = Frame(page: controller.pageIndex.value, minX: minX, minY: minY, maxX: maxX, maxY: maxY);
                              controller.secondFrameList.add(tempFrame);
                            }
                          }
                          controller.pageIndex.value--;
                          if (controller.firstFrameFinished) {
                            controller.rectList = <Rect>[].obs;
                            for (var element in controller.secondFrameList) {
                              if (controller.pageIndex.value == element.page) {
                                double dx = element.minX;
                                double dy = element.minY;
                                double width = element.maxX - element.minX;
                                double height = element.maxY - element.minY;
                                Rect tRect = Offset(renderSize.width * dx, renderSize.height * dy) & Size(renderSize.width * width, renderSize.height * height);
                                controller.rectList.add(tRect);
                              }
                            }
                          }
                          setState(() {});
                        }
                      },
                    ),
                    Button(
                      child: const Text("다음 페이지"),
                      onPressed: () {
                        if (controller.pageIndex.value == controller.pageNum - 1) {
                          displayInfoBar(
                            context,
                            builder: (context, close) {
                              return InfoBar(
                                severity: InfoBarSeverity.warning,
                                title: const Text('마지막 페이지입니다'),
                                action: IconButton(
                                  icon: const Icon(FluentIcons.clear),
                                  onPressed: close,
                                ),
                              );
                            },
                          );
                        } else {
                          if (controller.firstFrameFinished) {
                            var toRemove = [];
                            for (var element in controller.secondFrameList) {
                              if (controller.pageIndex.value == element.page) {
                                toRemove.add(element);
                              }
                            }
                            controller.secondFrameList.removeWhere((e) => toRemove.contains(e));
                            for (var element in controller.pageRectList[controller.pageIndex.value]) {
                              Offset topLeft = element.topLeft;
                              Offset bottomRight = element.bottomRight;
                              double minX = topLeft.dx / renderSize.width;
                              double minY = topLeft.dy / renderSize.height;
                              double maxX = bottomRight.dx / renderSize.width;
                              double maxY = bottomRight.dy / renderSize.height;
                              Frame tempFrame = Frame(page: controller.pageIndex.value, minX: minX, minY: minY, maxX: maxX, maxY: maxY);
                              controller.secondFrameList.add(tempFrame);
                            }
                          }
                          controller.pageIndex.value++;
                          if (controller.firstFrameFinished) {
                            controller.rectList = <Rect>[].obs;
                            for (var element in controller.secondFrameList) {
                              if (controller.pageIndex.value == element.page) {
                                double dx = element.minX;
                                double dy = element.minY;
                                double width = element.maxX - element.minX;
                                double height = element.maxY - element.minY;
                                Rect tRect = Offset(renderSize.width * dx, renderSize.height * dy) & Size(renderSize.width * width, renderSize.height * height);
                                controller.rectList.add(tRect);
                              }
                            }
                          }
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Button(
                    child: const Text("PDF 압축하기"),
                    onPressed: () async {
                      final Uri url = Uri.parse('https://www.adobe.com/kr/acrobat/online/compress-pdf.html');
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw Exception('Could not launch $url');
                      }
                    }),
                const SizedBox(height: 10),
                !controller.firstFrameFinished
                    ? Button(
                        child: const Text("1차 프레임 저장"),
                        onPressed: () async {
                          setState(() {
                            renderSize = _getSize();
                          });
                          if (controller.rectList.isEmpty) {
                            showEmptyDialog(context);
                            setState(() {});
                          } else {
                            List<Frame> frameList = [];
                            for (int pageIdx = 0; pageIdx < controller.pageNum; pageIdx++) {
                              for (Rect element in controller.rectList) {
                                Offset topLeft = element.topLeft;
                                Offset bottomRight = element.bottomRight;
                                double minX = topLeft.dx / renderSize.width;
                                double minY = topLeft.dy / renderSize.height;
                                double maxX = bottomRight.dx / renderSize.width;
                                double maxY = bottomRight.dy / renderSize.height;
                                Frame tempFrame = Frame(page: pageIdx, minX: minX, minY: minY, maxX: maxX, maxY: maxY);
                                frameList.add(tempFrame);
                                debugPrint("pageIdx: $pageIdx, minX: $minX, minY: $minY, maxX: $maxX, maxY: $maxY");
                              }
                            }
                            await controller.sendFirstFrameInfo(frameList);

                            renderSize = _getSize();

                            for (var element in controller.secondFrameList) {
                              double dx = element.minX;
                              double dy = element.minY;
                              double width = element.maxX - element.minX;
                              double height = element.maxY - element.minY;
                              Rect tRect = Offset(renderSize.width * dx, renderSize.height * dy) & Size(renderSize.width * width, renderSize.height * height);
                              controller.pageRectList[element.page].add(tRect);
                            }

                            setState(() {
                              controller.rectList = <Rect>[].obs;
                              for (var element in controller.pageRectList[controller.pageIndex.value]) {
                                controller.rectList.add(element);
                              }

                              controller.firstFrameFinished = true;
                            });
                          }
                        },
                      )
                    : Button(
                        child: const Text("DB 저장"),
                        onPressed: () async {
                          setState(() {
                            renderSize = _getSize();
                          });
                          var toRemove = [];
                          for (var element in controller.secondFrameList) {
                            if (controller.pageIndex.value == element.page) {
                              toRemove.add(element);
                            }
                          }
                          controller.secondFrameList.removeWhere((e) => toRemove.contains(e));
                          for (var element in controller.pageRectList[controller.pageIndex.value]) {
                            Offset topLeft = element.topLeft;
                            Offset bottomRight = element.bottomRight;
                            double minX = topLeft.dx / renderSize.width;
                            double minY = topLeft.dy / renderSize.height;
                            double maxX = bottomRight.dx / renderSize.width;
                            double maxY = bottomRight.dy / renderSize.height;
                            Frame tempFrame = Frame(page: controller.pageIndex.value, minX: minX, minY: minY, maxX: maxX, maxY: maxY);
                            controller.secondFrameList.add(tempFrame);
                          }
                          for (int i = 0; i < controller.secondFrameList.length; i++) {
                            for (int j = 0; j < controller.secondFrameList.length - 1; j++) {
                              if (controller.secondFrameList[j].page > controller.secondFrameList[j + 1].page) {
                                final temp = controller.secondFrameList[j];
                                controller.secondFrameList[j] = controller.secondFrameList[j + 1];
                                controller.secondFrameList[j + 1] = temp;
                              }
                            }
                          }
                          if (controller.secondFrameList.isEmpty) {
                            showEmptyDialog(context);
                            setState(() {});
                          } else {
                            for (var element in controller.secondFrameList) {
                              debugPrint("pageIdx: ${element.page}, minX: ${element.minX}, minY: ${element.minY}, maxX: ${element.maxX}, maxY: ${element.maxY}");
                            }
                            List<int> byte = await controller.pickedFile!.readAsBytes();

                            final DefaultTabBodyController defaultTabBodyController = Get.find<DefaultTabBodyController>(tag: Get.find<FluentTabController>().getTabKey());
                            defaultTabBodyController.saveThisWorkingSpace();
                            defaultTabBodyController.changeWorkingSpace(
                              PdfSaveScreen(byte, controller.secondFrameList),
                            );
                          }
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showEmptyDialog(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text('1차 프레임을 설정해주세요'),
      content: const Text(
        '문제의 열을 따라 1차 프레임을 설정해주세요.',
      ),
      actions: [
        FilledButton(
          child: const Text('확인'),
          onPressed: () => Navigator.pop(context, 'User canceled dialog'),
        ),
      ],
    ),
  );
}
