///Screen: File_Drag_and_Drop.
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:get/get.dart';
import '../Controller/Controller_PdfView.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final controller = Get.put(PdfScreenController());
  final controller2 = Get.put(PdfScreenController());

  Widget selectPdfContainer(PdfFileType pdfFileType) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 5,
      child: DropTarget(
        onDragDone: (detail) async {
          controller.onDragDone(
            detail,
            context,
            pdfFileType,
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
                  controller.fileUpload(pdfFileType, context);
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
                controller.getFileName(pdfFileType)!,
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

  Widget pdfViewerContainer(PdfFileType pdfFileType) {
    File? file;
    if (pdfFileType == PdfFileType.problem) {
      file = controller.pickedFileProblem;
    }
    if (pdfFileType == PdfFileType.answer) {
      file = controller.pickedFileAnswer;
    }
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
                        "File name: ${controller.getFileName(pdfFileType)}",
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
                      controller.exitPdf(pdfFileType);
                      setState(() {});
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
                    file!,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Visibility(
                    visible: controller.isCaptured(pdfFileType),
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
                            child: controller.isCaptured(pdfFileType)
                                ? Image.memory(
                                    controller.getCapturedImage(pdfFileType)!,
                                  )
                                : const SizedBox(),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: FloatingActionButton(
                              backgroundColor: Colors.black26,
                              onPressed: () async {
                                controller.deleteCapturedImage(pdfFileType);
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
                  visible: !controller.isCaptured(pdfFileType),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor: Colors.black26,
                      onPressed: () async {
                        controller.capturePdf(pdfFileType);
                        setState(() {});
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
        child: GetX<PdfScreenController>(
          builder: (controller) {
            ///desktop_drop library
            return Row(
              children: [
                controller.pdfInputedProblem
                    ? pdfViewerContainer(PdfFileType.problem)
                    : selectPdfContainer(PdfFileType.problem),
                Container(
                  width: 10,
                  color: Colors.black12,
                ),
                controller.pdfInputedAnswer
                    ? pdfViewerContainer(PdfFileType.answer)
                    : selectPdfContainer(PdfFileType.answer),
              ],
            );
          },
        ),
      ),
    );
  }
}
