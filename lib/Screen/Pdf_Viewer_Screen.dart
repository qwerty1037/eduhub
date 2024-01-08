///Screen: File_Drag_and_Drop.
//import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/ScreenController/Pdf_Viewer_Screen_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Pdf_Save_Screen.dart';
import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:front_end/Controller/Tab_Controller.dart' as t;

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfViewerScreen> {
  final controllerProblem = Get.put(PdfViewerScreenController(), tag: "Problem${Get.find<t.TabController>().getTabKey()}");
  final controllerAnswer = Get.put(PdfViewerScreenController(), tag: "Answer${Get.find<t.TabController>().getTabKey()}");
  Size renderSize = Size.zero;

  @override
  void initState() {
    super.initState();
    renderSize = _getSize();
    rect1 = Offset(renderSize.width * 0.2, renderSize.height * 0.2) & Size(renderSize.width * 0.6, renderSize.height * 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Center(
        child: Container(
          color: Get.find<TotalController>().isDark.value == true ? Colors.grey[150] : Colors.grey[30],
          child: Stack(
            children: [
              Row(
                children: [
                  Obx(() {
                    return controllerProblem.isPdfInputed.value
                        ? pdfViewerContainer(controllerProblem, constraints)
                        : selectPdfContainer(controllerProblem, constraints);
                  }),
                ],
              ),
              Obx(() {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                    visible: (controllerProblem.isCaptured.value == true && controllerAnswer.isCaptured.value == true),
                    child: IconButton(
                      onPressed: () {
                        final DefaultTabBodyController defaultTabBodyController =
                            Get.find<DefaultTabBodyController>(tag: Get.find<t.TabController>().getTabKey());
                        defaultTabBodyController.saveThisWorkingSpace();
                        defaultTabBodyController.changeWorkingSpace(PdfSaveScreen(controllerProblem.getCapturedImage()!, controllerAnswer.getCapturedImage()!));

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => PdfSaveScreen(controllerProblem.getCapturedImage()!, controllerAnswer.getCapturedImage()!)),
                        // );
                      },
                      icon: const Icon(
                        FluentIcons.save,
                        //color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectPdfContainer(PdfViewerScreenController controller, constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
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
                    FluentIcons.insert_signature_line,
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
              GestureDetector(
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
                      FluentIcons.upload,
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

  Rect rect1 = Rect.zero;
  final GlobalKey _containerKey = GlobalKey();
  TransformationController ctrl = TransformationController();

  Widget pdfViewerContainer(PdfViewerScreenController controller, constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      //color: Colors.black,
                    ),
                    //color: Colors.black,
                    /*
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    */
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          const Icon(FluentIcons.quick_note),
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
                        child: OutlinedButton(
                          /*
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          */
                          onPressed: () {
                            controller.exitPdf();
                          },
                          child: const Icon(
                            FluentIcons.chrome_close,
                            //color: Colors.white,
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
                      Obx(
                        () => InteractiveViewer(
                          key: _containerKey,
                          transformationController: ctrl,
                          interactionEndFrictionCoefficient: double.infinity,
                          onInteractionUpdate: (details) {
                            setState(() {});
                          },
                          minScale: 1.0,
                          maxScale: 3.0,
                          child: Stack(
                            children: [
                              SizedBox(
                                child: Image.memory(controller.pickedPdfImageList[1]),
                              ),
                              ...controllerProblem.rectList.map((element) {
                                return TransformableBox(
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
                                  rect: element,
                                  onChanged: (result, event) {
                                    setState(() {
                                      element = result.rect;
                                    });
                                  },
                                );
                              }),
                              /*
                              Visibility(
                                child: Text("${controllerProblem.tempInt.value}"),
                                visible: false,
                              ),
                              */
                            ],
                          ),
                        ),
                      ),
                      /*
                      SizedBox(
                        child: SfPdfViewer.file(
                          controller.pickedFile!,
                          pageLayoutMode: PdfPageLayoutMode.single,
                        ),
                      ),
                      */
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Visibility(
                          visible: controller.isCaptured(),
                          child: SizedBox(
                            height: 250,
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      //color: Colors.black,
                                    ),
                                    //color: Colors.black,
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
                                  child: IconButton(
                                    /*
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                    */
                                    onPressed: () async {
                                      controller.deleteCapturedImage();
                                    },
                                    icon: const Icon(
                                      FluentIcons.chrome_close,
                                      //color: Colors.white,
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
                          child: IconButton(
                            /*
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            */
                            onPressed: () async {
                              controller.capturePdf();
                            },
                            icon: const Icon(
                              FluentIcons.camera,
                              //scolor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: constraints.maxWidth / 2,
            height: constraints.maxHeight / 2,
            child: Column(
              children: [
                Row(
                  children: [
                    Button(
                      child: Text("박스 생성"),
                      onPressed: () {
                        renderSize = _getSize();
                        controllerProblem.generateBox(renderSize);
                      },
                    ),
                    Button(
                      child: Text("박스 삭제"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
