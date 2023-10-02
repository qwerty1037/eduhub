///Screen: File_Drag_and_Drop.
//import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/ScreenController/Pdf_Viewer_Screen_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Pdf_Save_Screen.dart';
import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:front_end/Controller/Tab_Controller.dart' as t;

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfViewerScreen> {
  final controllerProblem = Get.put(PdfViewerScreenController(),
      tag: "Problem${Get.find<t.TabController>().getTabKey()}");
  final controllerAnswer = Get.put(PdfViewerScreenController(),
      tag: "Answer${Get.find<t.TabController>().getTabKey()}");

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Center(
        child: Container(
          color: Get.find<TotalController>().isDark.value == true
              ? Colors.grey[150]
              : Colors.grey[30],
          child: Stack(
            children: [
              Row(
                children: [
                  Obx(() {
                    return controllerProblem.isPdfInputed.value
                        ? pdfViewerContainer(controllerProblem, constraints)
                        : selectPdfContainer(controllerProblem, constraints);
                  }),
                  Container(
                    width: 4,
                    //color: Colors.black,
                  ),
                  Obx(() {
                    return controllerAnswer.isPdfInputed.value
                        ? pdfViewerContainer(controllerAnswer, constraints)
                        : selectPdfContainer(controllerAnswer, constraints);
                  }),
                ],
              ),
              Obx(() {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                    visible: (controllerProblem.isPdfInputed.value == true &&
                        controllerAnswer.isPdfInputed.value == true),
                    child: IconButton(
                      onPressed: () {
                        //TODO: pdf압축 관련 screen띄우기, 새로운 저장 UI띄우기
                        /*
                        final DefaultTabBodyController
                            defaultTabBodyController =
                            Get.find<DefaultTabBodyController>(
                                tag: Get.find<t.TabController>().getTabKey());
                        defaultTabBodyController.saveThisWorkingSpace();
                        defaultTabBodyController.changeWorkingSpace(
                            PdfSaveScreen(controllerProblem.getCapturedImage()!,
                                controllerAnswer.getCapturedImage()!));
                        */
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => PdfSaveScreen(controllerProblem.getCapturedImage()!, controllerAnswer.getCapturedImage()!)),
                        // );
                      },
                      icon: const Icon(
                        FluentIcons.save,
                        //color: Colors.white,
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

  Widget selectPdfContainer(PdfViewerScreenController controller, constraints) {
    return SizedBox(
      width: constraints.maxWidth / 2 - 5,
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

  Widget pdfViewerContainer(PdfViewerScreenController controller, constraints) {
    return SizedBox(
      width: constraints.maxWidth / 2 - 5,
      height: constraints.maxHeight,
      child: Column(
        children: [
          Container(
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
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
                    const Icon(FluentIcons.quick_note),
                    FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "File name: ${controller.getFileName()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
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
          ),
          Container(
            color: Colors.black,
            height: 1,
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
