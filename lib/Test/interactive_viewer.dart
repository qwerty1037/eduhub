import 'dart:io';
import 'package:flutter_box_transform/flutter_box_transform.dart';

import 'src/rect.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TransformationController ctrl = TransformationController();
  Image image = Image.file(
    File("C:\\Users\\JungHyun Han\\Desktop\\data\\image1.png"),
  );
  double? imageWidth;
  double? imageHeight;
  double borderWidth = 3.0;
  double paddingWidth = 30.0;

  final GlobalKey _containerKey = GlobalKey();
  Size renderSize = Size.zero;
  Offset renderOffset = Offset.zero;

  Size _getSize() {
    if (_containerKey.currentContext != null) {
      final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
    return Size.zero;
  }

  Offset _getOffset() {
    if (_containerKey.currentContext != null) {
      final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      return offset;
    }
    return Offset.zero;
  }

  // Rectangle rect1 = Rectangle(lowerLeftX: 0.2, lowerLeftY: 0.2, upperRightX: 0.6, upperRightY: 0.6);
  Rect rect1 = Rect.zero;
  Rectangle rect2 = Rectangle(lowerLeftX: 0.7, lowerLeftY: 0.7, upperRightX: 0.9, upperRightY: 0.9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: borderWidth,
                  color: Colors.black,
                ),
              ),
              padding: EdgeInsets.all(paddingWidth),
              child: Stack(
                children: [
                  InteractiveViewer(
                    key: _containerKey,
                    transformationController: ctrl,
                    interactionEndFrictionCoefficient: double.infinity,
                    onInteractionUpdate: (details) {
                      setState(() {});
                    },
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Stack(
                      children: [
                        image,
                        TransformableBox(
                          contentBuilder: (content, rect, flip) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.red,
                                ),
                                color: Colors.red.withOpacity(0.5),
                              ),
                            );
                          },
                          rect: rect1,
                          onChanged: (result, event) {
                            setState(() => rect1 = result.rect);
                          },
                        ),
                        /*
                        Positioned(
                          left: rect1.lowerLeftX * _getSize().width,
                          top: rect1.lowerLeftY * _getSize().height,
                          child: GestureDetector(
                            onTap: () {
                              debugPrint("Select");
                            },
                            child: Container(
                              width: rect1.width * _getSize().width,
                              height: rect1.height * _getSize().height,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        */
                        Positioned(
                          left: rect2.lowerLeftX * _getSize().width,
                          top: rect2.lowerLeftY * _getSize().height,
                          child: GestureDetector(
                            onTap: () {
                              debugPrint("Select");
                            },
                            child: Container(
                              width: rect2.width * _getSize().width,
                              height: rect2.height * _getSize().height,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        /*
                        Transform(
                          transform: ctrl.value,
                          alignment: Alignment.topLeft,
                          child: Transform.translate(
                            offset: Offset(rect1.lowerLeftX * _getSize().width, rect1.lowerLeftY * _getSize().height),
                            child: Container(
                              width: rect1.width * _getSize().width,
                              height: rect1.height * _getSize().height,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.red,
                                ),
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
            ),
          ),
          Text(ctrl.value.toString()),
          Text("Image Width = ${_getSize()?.width}, Height = ${_getSize()?.height}"),
          IconButton(
            onPressed: () {
              ctrl.value = Matrix4.identity();
              setState(() {
                renderSize = _getSize();
                rect1 = Offset(renderSize.width * 0.2, renderSize.height * 0.2) & Size(renderSize.width * 0.6, renderSize.height * 0.6);
              });
            },
            icon: const Icon(Icons.reset_tv),
          ),
        ],
      ),
    );
  }
}
