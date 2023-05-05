import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class FilePickerTestController extends GetxController {
  RxString showFileName = "".obs;

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
}

class FilePickerTest extends StatefulWidget {
  const FilePickerTest({super.key});

  @override
  State<FilePickerTest> createState() => _FilePickerTestState();
}

class _FilePickerTestState extends State<FilePickerTest> {
  String showFileName = "";
  Color defaultColor = Colors.grey[400]!;

  Scaffold makeFilePicker() {
    Get.put(FilePickerTestController());
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 400,
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: defaultColor),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: GetX<FilePickerTestController>(
                  builder: (controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                "Find and Upload",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: defaultColor,
                                  fontSize: 20,
                                ),
                              ),
                              Icon(
                                Icons.upload_rounded,
                                color: defaultColor,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "(*.pdf)",
                          style: TextStyle(
                            color: defaultColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${controller.showFileName.value}',
                          style: TextStyle(
                            color: defaultColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return makeFilePicker();
  }
}
