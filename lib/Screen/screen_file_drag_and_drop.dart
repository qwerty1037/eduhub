///Screen: File_Drag_and_Drop.
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:get/get.dart';
import '../Controller/Controller_FileDragAndDrop.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class FileDragAndDropScreen extends StatefulWidget {
  const FileDragAndDropScreen({super.key});

  @override
  State<FileDragAndDropScreen> createState() => _FileDragAndDropScreenState();
}

class _FileDragAndDropScreenState extends State<FileDragAndDropScreen> {
  final controller = Get.put(FileDragAndDropController());
  @override
  Widget SelectPdfContainer(PdfFileType pdffiletype) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 5,
      child: DropTarget(
        onDragDone: (detail) async {
          controller.onDragDone(
            detail,
            context,
            pdffiletype,
          );
        },
        onDragEntered: (detail) {
          controller.onDragEntered(detail);
        },
        onDragExited: (detail) {
          controller.onDragExited(detail);
        },
        child: Container(
          height: 200,
          width: 400,
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
                  controller.fileUpload(pdffiletype, context);
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
                controller.showFileName.value,
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
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 5,
      child: SfPdfViewer.file(
        file!,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetX<FileDragAndDropController>(
          builder: (controller) {
            ///desktop_drop library
            return Row(
              children: [
                controller.pdfInputedProblem
                    ? pdfViewerContainer(PdfFileType.problem)
                    : SelectPdfContainer(PdfFileType.problem),
                Container(
                  width: 10,
                  color: Colors.black12,
                ),
                controller.pdfInputedAnswer
                    ? pdfViewerContainer(PdfFileType.answer)
                    : SelectPdfContainer(PdfFileType.answer),
              ],
            );
          },
        ),
      ),
    );
  }
}
