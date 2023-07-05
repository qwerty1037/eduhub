///Screen: File_Drag_and_Drop.
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:front_end/Screen/PdfSaveScreen.dart';
import 'package:get/get.dart';
import '../Controller/PdfViewerScreenController.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfViewerScreen> {
  final controllerProblem =
      Get.put(PdfViewerScreenController(), tag: "Problem");
  final controllerAnswer = Get.put(PdfViewerScreenController(), tag: "Answer");

  Widget selectPdfContainer(PdfViewerScreenController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 5,
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
                    Icons.insert_drive_file_rounded,
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
              InkWell(
                //A rectangular area of a Material that responds to touch.
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
                      Icons.upload_rounded,
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

  Widget pdfViewerContainer(PdfViewerScreenController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 5,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
              color: Colors.black12,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    const Icon(Icons.note_outlined),
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
                  child: FloatingActionButton(
                    backgroundColor: Colors.black26,
                    onPressed: () async {
                      controller.exitPdf();
                    },
                    child: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Visibility(
                    visible: controller.isCaptured(),
                    child: Container(
                      height: 250,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                              color: Colors.black12,
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
                            child: FloatingActionButton(
                              backgroundColor: Colors.black26,
                              onPressed: () async {
                                controller.deleteCapturedImage();
                              },
                              child: const Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !controller.isCaptured(),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black26),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        controller.capturePdf();
                      },
                      child: const Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Row(
              children: [
                Obx(() {
                  return controllerProblem.isPdfInputed
                      ? pdfViewerContainer(controllerProblem)
                      : selectPdfContainer(controllerProblem);
                }),
                Container(
                  width: 10,
                  color: Colors.black12,
                ),
                Obx(() {
                  return controllerAnswer.isPdfInputed
                      ? pdfViewerContainer(controllerAnswer)
                      : selectPdfContainer(controllerAnswer);
                }),
              ],
            ),
            Obx(() {
              return Align(
                alignment: Alignment.bottomRight,
                child: Visibility(
                  visible: (controllerProblem.isCaptured.value == true &&
                      controllerAnswer.isCaptured.value == true),
                  child: FloatingActionButton(
                    heroTag: 'Save',
                    backgroundColor: Colors.black26,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfSaveScreen(
                                controllerProblem.getCapturedImage()!,
                                controllerAnswer.getCapturedImage()!)),
                      );
                    },
                    child: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
