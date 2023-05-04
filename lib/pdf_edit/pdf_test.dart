import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class FilePickerTest extends StatefulWidget {
  const FilePickerTest({super.key});

  @override
  State<FilePickerTest> createState() => _FilePickerTestState();
}

class _FilePickerTestState extends State<FilePickerTest> {
  String showFileName = "";
  Color defaultColor = Colors.grey[400]!;

  Scaffold makeFilePicker() {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      //A rectangular area of a Material that responds to touch.
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null && result.files.isNotEmpty) {
                          String fileName = result.files.first.name;
                          debugPrint(fileName);
                          setState(() {
                            showFileName = "Now File Name: $fileName";
                          });
                          /*
                          TODO
                          */
                        }
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
                      "(*.csv)",
                      style: TextStyle(
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      showFileName,
                      style: TextStyle(
                        color: defaultColor,
                      ),
                    ),
                  ],
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
