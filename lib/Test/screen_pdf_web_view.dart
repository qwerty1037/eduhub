import 'package:flutter/material.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:screenshot/screenshot.dart';

class PartialCaptureScreen extends StatefulWidget {
  const PartialCaptureScreen({super.key});

  @override
  _PartialCaptureScreenState createState() => _PartialCaptureScreenState();
}

class _PartialCaptureScreenState extends State<PartialCaptureScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Rect? _captureRect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partial Capture'),
      ),
      body: GestureDetector(
        onDoubleTap: () async {
          CapturedData? capturedData = await screenCapturer.capture(
            mode: CaptureMode.region, // screen, window
            imagePath: '<path>',
            copyToClipboard: true,
          );
          // setState(() {q
          //   _captureRect =
          //       Rect.fromPoints(details.localPosition, details.localPosition);
          // });
        },
        // onPanUpdate: (details) {
        //   setState(() {
        //     _captureRect =
        //         Rect.fromPoints(_captureRect!.topLeft, details.localPosition);
        //   });
        // },
        // onPanEnd: (details) async {
        //   final imageBytes = await _screenshotController.capture(
        //     pixelRatio: 2.0, // 캡처할 영역의 해상도를 설정합니다.
        //   );
        //   setState(() {
        //     _captureRect = null;
        //   });
        //   if (imageBytes != null) {}
        // },
        child: Stack(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
              ),
            ),
            CustomPaint(
              painter: SelectionPainter(rect: _captureRect),
              size: Size.infinite,
            ),
          ],
        ),
      ),
    );
  }
}

class Capture {
  CapturedData? capturedData;

  Future? captureRegion() async {
    capturedData = await screenCapturer.capture(
      mode: CaptureMode.region, // screen, window
      imagePath: '<path>',
      copyToClipboard: true,
    );
    return capturedData;
  }
}

class SelectionPainter extends CustomPainter {
  final Rect? rect;

  SelectionPainter({this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    if (rect != null) {
      canvas.drawRect(
        rect!,
        Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );
      canvas.drawRect(
        rect!,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
