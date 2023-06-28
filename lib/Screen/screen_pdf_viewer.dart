///Implemention of pdf_viewer.

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:screen_capturer/screen_capturer.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  PDFViewerPageState createState() => PDFViewerPageState();
}

class PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: Row(
        children: [
          Container(
            child: SfPdfViewer.file(File(widget.file.path)),
            width: MediaQuery.of(context).size.width / 2 - 5,
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            child: SfPdfViewer.file(File(widget.file.path)),
            width: MediaQuery.of(context).size.width / 2 - 5,
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          CapturedData? capturedData = await screenCapturer.capture(
            mode: CaptureMode.region, // screen, window
            imagePath: '<path>',
            copyToClipboard: true,
          );
        },
        child: Text("Capture"),
        style:
            ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
