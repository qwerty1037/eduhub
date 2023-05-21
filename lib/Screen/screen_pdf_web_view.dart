import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:screenshot/screenshot.dart';

class PartialCapturePDFScreen extends StatefulWidget {
  @override
  _PartialCapturePDFScreenState createState() =>
      _PartialCapturePDFScreenState();
}

class _PartialCapturePDFScreenState extends State<PartialCapturePDFScreen> {
  ScreenshotController _screenshotController = ScreenshotController();
  late final PdfDocument _pdfDocument;
  int _currentPageIndex = 0;
  Rect? _captureRect;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    _pdfDocument = await PdfDocument.openAsset('assets/sample.pdf');
    setState(() {});
  }

  Future<Uint8List?> capturePDFRegion() async {
    if (_pdfDocument != null && _captureRect != null) {
      final pdfPage = await _pdfDocument.getPage(_currentPageIndex);
      final pdfPageImage = await pdfPage.render(
        x: _captureRect!.left.toInt(),
        y: _captureRect!.top.toInt(),
        width: _captureRect!.width.toInt(),
        height: _captureRect!.height.toInt(),
      );
      final Uint8List imageBytes = await pdfPageImage.pixels;
      return imageBytes;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = PdfViewerController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Partial Capture PDF'),
      ),
      body: _pdfDocument != null
          ? GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _captureRect = Rect.fromPoints(
                      details.globalPosition, details.globalPosition);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _captureRect = Rect.fromLTRB(
                    _captureRect!.left,
                    _captureRect!.top,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  );
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _captureRect = null;
                });
              },
              child: Stack(
                children: [
                  Screenshot(
                    controller: _screenshotController,
                    child: PdfViewer.openAsset(
                      'assets/hello.pdf',
                      viewerController: controller,
                      onError: (err) => print(err),
                      params: const PdfViewerParams(
                        padding: 10,
                        minScale: 1.0,
                        // scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  _captureRect != null
                      ? Positioned(
                          left: _captureRect!.left,
                          top: _captureRect!.top,
                          width: _captureRect!.width,
                          height: _captureRect!.height,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final imageBytes = await capturePDFRegion();
          if (imageBytes != null) {
            //TODO:저장
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
