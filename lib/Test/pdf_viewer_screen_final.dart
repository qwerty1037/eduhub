///Screen: File_Drag_and_Drop.
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:front_end/Controller/ScreenController/pdf_viewer_screen_controller.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/user_desktop_controller.dart';
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
  final controllerProblem = Get.put(PdfViewerScreenController(),
      //     tag: "Problem${Get.find<t.FluentTabController>().getTabKey()}");
      // final controllerAnswer = Get.put(PdfViewerScreenController(),
      tag: "Answer${Get.find<FluentTabController>().getTabKey()}");
  final userDataController = Get.find<UserDataController>();
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
                        : (controllerProblem.isPdfInputed.value ? pdfViewerContainer(controllerProblem, constraints) : selectPdfContainer(controllerProblem, constraints, "문제"));
                  }),
                ],
              ),
              Obx(() {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    visible: (controllerProblem.isPdfInputed.value),
                    child: Container(
                      width: constraints.maxWidth,
                      height: 100,
                      color: Colors.grey[30],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    const Text("문제 저장 위치:  "),
                                    userDataController.selectedPath.value == ""
                                        ? Text("왼쪽 대시보드에서 문제 저장할 폴더를 클릭하세요", style: TextStyle(color: controllerProblem.defaultColor))
                                        : Text(userDataController.selectedPath.value)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Text("현재 파일 용량:  ${controllerProblem.pickedFileSize.value} bytes"),
                                    const SizedBox(
                                      width: 20,
                                    ),
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
                                        })
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                              height: 100,
                              child: Button(
                                  onPressed: () {
                                    controllerProblem.makeProblemsFromPdf(context);
                                  },
                                  child: const Align(child: Text("문제 만들기")))),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectPdfContainer(PdfViewerScreenController controller, constraints, String keyword) {
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
            // borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$keyword PDF 파일 드래그 영역",
                style: TextStyle(color: controller.buttoncolor(), fontSize: 18),
              ),
              const SizedBox(
                height: 5,
              ),
              Button(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FluentIcons.fabric_folder_fill,
                        color: controller.buttoncolor(),
                        size: 20,
                      ),
                      Text(
                        "  파일 찾기",
                        style: TextStyle(
                          color: controller.buttoncolor(),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    controller.fileUpload(context);
                  }),
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

  Widget pdfViewerContainer(PdfViewerScreenController controller, constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight - 100,
      child: Column(
        children: [
          Container(
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.3,
                //color: Colors.black,
              ),
              //color: Colors.black,
              /*
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              */
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    const Icon(FluentIcons.pdf),
                    FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "  ${controller.getFileName()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: const Icon(
                          FluentIcons.chrome_close,
                        ),
                        onPressed: () {
                          controller.exitPdf();
                        })),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  child: SfPdfViewer.file(
                    controller.pickedFile!,
                  ),
                ),
                /*
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Visibility(
                    visible: controller.isCaptured(),
                    child: SizedBox(
                      height: 250,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                //color: Colors.black,
                              ),
                              //color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: controller.isCaptured()
                                ? Image.memory(
                                    controller.getCapturedImage()!,
                                  )
                                : const SizedBox(),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              /*
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              */
                              onPressed: () async {
                                controller.deleteCapturedImage();
                              },
                              icon: const Icon(
                                FluentIcons.chrome_close,
                                //color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                */
                /*
                Visibility(
                  visible: !controller.isCaptured(),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      /*
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      */
                      onPressed: () async {
                        controller.capturePdf();
                      },
                      icon: const Icon(
                        FluentIcons.camera,
                        //scolor: Colors.white,
                      ),
                    ),
                  ),
                ),
                */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
