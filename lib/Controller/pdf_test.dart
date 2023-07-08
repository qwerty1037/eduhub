import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:get/get.dart';

class FileDragAndDropController extends GetxController {
  Color defaultColor = Colors.grey[400]!;
  Color uploadingColor = Colors.blue[100]!;
  RxString showFileName = "".obs;
  RxBool dragging = false.obs;

  void fileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      String fileName = result.files.first.name;
      debugPrint(fileName);
      showFileName.value = 'Now File Name: $fileName';
    }
  }

  void onDragZone(detail) {
    debugPrint('onDragDone:');
    if (detail != null && detail.files.isNotEmpty) {
      String fileName = detail.files.first.name;
      debugPrint(fileName);
      showFileName.value = "Now File Name: $fileName";
    }
  }

  void onDragEntered(detail) {
    debugPrint('onDragEntered:');
    dragging.value = true;
  }

  void onDragExited(detail) {
    debugPrint('onDragExited:');
    dragging.value = false;
  }

  Color buttoncolor() {
    return dragging.value ? uploadingColor : defaultColor;
  }
}

class FileDragAndDrop extends StatefulWidget {
  const FileDragAndDrop({super.key});

  @override
  State<FileDragAndDrop> createState() => _FileDragAndDropState();
}

class _FileDragAndDropState extends State<FileDragAndDrop> {
  @override
  Widget build(BuildContext context) {
    Get.put(FileDragAndDropController());
    return Scaffold(
      body: Center(
        child: GetX<FileDragAndDropController>(
          builder: (controller) {
            return DropTarget(
              onDragDone: (detail) async {
                controller.onDragZone(detail);
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
                        controller.fileUpload();
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
            );
          },
        ),
      ),
    );
  }
}
