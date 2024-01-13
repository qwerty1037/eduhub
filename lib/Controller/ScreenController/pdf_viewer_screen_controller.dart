import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Class/frame.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart' as material;
import 'package:file_picker/file_picker.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class PdfFile {
  Uint8List? capturedImage;
}

///GetxController of pdf_test
class PdfViewerScreenController extends GetxController {
  Color defaultColor = material.Colors.grey[400]!;
  Color uploadingColor = material.Colors.blue[100]!;
  RxBool isPdfInputed = false.obs;
  File? pickedFile;
  List pickedPdfImageList = <Uint8List>[];

  RxString pickedFileName = "".obs;
  Uint8List? capturedImage;
  RxBool isDragged = false.obs;
  RxBool isCaptured = false.obs;
  RxInt pickedFileSize = 0.obs;
  RxBool showProcess = false.obs;

  RxInt tempInt = 0.obs;
  int pageNum = 0;
  RxList rectList = <Rect>[].obs;
  List<List<Rect>> pageRectList = [];
  var ctrlList = <TransformationController>[];
  int boxIndex = 0;
  RxInt pageIndex = 0.obs;
  var secondFrameList = <Frame>[];

  ///Upload file into Application using FIlePicker.
  ///
  ///insert uploaded file's name into member variable showFileName.
  void fileUpload(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      pickedFile = File(result.files.first.path!);
      String fileName = result.files.first.name;
      debugPrint(fileName);
      debugPrint(result.files.first.path!);
      pickedFileName.value = fileName;
      pickedFileSize.value = await pickedFile!.length();

      final pdf = await PdfDocument.openFile(result.files.first.path!);
      // final size = await pdf.getPage(1).;
      pageNum = pdf.pagesCount;
      for (int i = 1; i <= pageNum; i++) {
        PdfPage page = await pdf.getPage(i);
        PdfPageImage? pageImage = await page.render(
          width: page.width,
          height: page.height,
        );
        Uint8List rawImage = pageImage!.bytes;
        pickedPdfImageList.add(rawImage);
      }

      isPdfInputed.value = true;
    } else {
      print("Upload Failed");
    }
  }

  ///Function when Drag&Drop is done.
  void onDragDone(
    detail,
    context,
  ) async {
    debugPrint('onDragDone:');
    if (detail != null && detail.files.isNotEmpty) {
      String fileName = detail.files.first.name;
      debugPrint(fileName);
      debugPrint(detail.files.first.path);
      pickedFileName.value = fileName;
      pickedFile = File(detail.files.first.path);
      pickedFileSize.value = await pickedFile!.length();

      final pdf = await PdfDocument.openFile(detail.files.first.path);
      // final size = await pdf.getPage(1).;
      pageNum = pdf.pagesCount;
      for (int i = 1; i <= pageNum; i++) {
        PdfPage page = await pdf.getPage(i);
        PdfPageImage? pageImage = await page.render(
          width: page.width,
          height: page.height,
        );
        Uint8List rawImage = pageImage!.bytes;
        pickedPdfImageList.add(rawImage);
      }

      isPdfInputed.value = true;
    }
  }

  ///Function when Drag enter the target.
  void onDragEntered(detail) {
    debugPrint('onDragEntered:');
    isDragged.value = true;
  }

  ///Function when Drag exit the target.
  void onDragExited(detail) {
    debugPrint('onDragExited:');
    isDragged.value = false;
  }

  String? getFileName() {
    return pickedFileName.value;
  }

  void exitPdf() {
    isPdfInputed.value = false;
  }

  /// Capture image and save
  ///
  /// Always Delete saved Image and capture
  ///
  /// If capturedData is null,
  void capturePdf() async {
    deleteCapturedImage();
    Directory directory = await getApplicationDocumentsDirectory();

    CapturedData? capturedData = await screenCapturer.capture(
      mode: CaptureMode.region, // screen, window
      imagePath: '${directory.path}/screen_capturer_example/Screenshots/a.png',
      copyToClipboard: true,
    );
    await Future.delayed(const Duration(seconds: 1));
    var imageBytes = await screenCapturer.readImageFromClipboard();
    if (capturedData == null) {
      if (imageBytes != null) {
        capturedImage = imageBytes;
        isCaptured.value = true;
      } else {
        await Future.delayed(const Duration(seconds: 1));
        imageBytes = await screenCapturer.readImageFromClipboard();
        if (imageBytes != null) {
          capturedImage = imageBytes;
          isCaptured.value = true;
        } else {
          print("Capture Failed");
        }
      }
    } else {
      // TODO: null이 입력되었을 때의 처리구문을 작성해야함
      capturedImage = capturedData.imageBytes;
      isCaptured.value = true;
    }
  }

  /// Delete capturedImage
  ///
  ///
  void deleteCapturedImage() async {
    isCaptured.value = false;
    capturedImage = null;
  }

  /// Return capturedImage
  Uint8List? getCapturedImage() {
    return capturedImage;
  }

  /// Target Box Color.
  ///
  /// When Drag Cursor is inside the target, color = uploadingColor.
  ///
  /// When Drag Cursor is outside the target, color = defaultColor.
  Color buttoncolor() {
    return isDragged.value ? uploadingColor : defaultColor;
  }

  bool checkPdfCondition() {
    final folderController = Get.find<UserDataController>();
    return pickedFile != null && folderController.selectedPath.value.isNotEmpty;
  }

  void makeProblemsFromPdf(BuildContext context) async {
    //
    //pickedfile을 서버에 보내기
    //보내야 하는건 저장할 위치 이름과 파일, 끝나면 서버처리 확인하는 엔드포인트(로딩) -> 끝나면 폴더 업데이트 추가
    final folderController = Get.find<UserDataController>();

    if (checkPdfCondition()) {
      final url = Uri.parse('https://$HOST/api/data/수정');
      var request = http.MultipartRequest('POST', url);

      request.files.add(http.MultipartFile('pdf_file', pickedFile!.openRead(), pickedFileSize.value, filename: pickedFileName.value));

      request.fields.addAll({
        "parent_database": Get.find<UserDataController>().selectedProblemDirectoryId.value.toString(),
      });
      request.headers.addAll(await defaultHeader(httpContentType.multipart));

      final response = await request.send();

      if (isHttpRequestSuccess(response)) {
        debugPrint("서버에서 문제 처리 완료");
        //TODO: 확인하는 엔드포인트 만들어지면 url과 while내부의 if문 조건 수정

        final checkUrl = Uri.parse('https://$HOST/api/수정');
        showProcess.value = true;
        while (showProcess.value) {
          final checkResponse = await http.get(
            checkUrl,
            headers: await defaultHeader(httpContentType.json),
          );
          if (isHttpRequestSuccess(checkResponse)) {
            showProcess.value = false;
            displayInfoBar(context, builder: (context, close) {
              return InfoBar(
                title: const Text("문제 만들기 완료:"),
                content: const Text("문제 생성이 완료되었습니다"),
                action: IconButton(
                  icon: const Icon(FluentIcons.clear),
                  onPressed: close,
                ),
                severity: InfoBarSeverity.error,
              );
            });
          } else {
            Future.delayed(const Duration(milliseconds: 500));
            continue;
          }
        }
        //TODO: 이부분에서 폴더 문제 업데이트 하기
      } else {
        displayInfoBar(context, builder: (context, close) {
          return InfoBar(
            title: const Text("문제 만들기 실패:"),
            content: const Text("서버와 양식이 맞지 않거나 서버에 오류가 발생하였습니다"),
            action: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: close,
            ),
            severity: InfoBarSeverity.error,
          );
        });
        //info bar로 오류 발생 처리
      }
    } else {
      displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('문제 만들기 실패'),
          content: const Text('저장 위치 또는 파일 선택이 완료되지 않았습니다'),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.warning,
        );
      });
    }
  }

  void generateBox(Size renderSize) {
    Rect tRect = Offset(renderSize.width * 0.2, renderSize.height * 0.2) & Size(renderSize.width * 0.4, renderSize.height * 0.4);
    rectList.add(tRect);
    boxIndex++;
  }

  void deleteBox(int index) {
    rectList.removeAt(index);
    rectList.refresh();
  }

  Future<int> sendFirstFrameInfo(List<Frame> frameList) async {
    List<int> pdfBytes = await pickedFile!.readAsBytes();

    // final url = Uri.parse('https://uwkedrf.request.dreamhack.games');
    final url = Uri.parse('https://$HOST/api/data/parse_pdf');
    var request = http.MultipartRequest('POST', url);
    var multipartFileProblem = http.MultipartFile.fromBytes(
      'source_document',
      pdfBytes,
      filename: "first_frame",
      contentType: MediaType('application', 'pdf'), // pdf의 MIME타입
    );

    var temp = [];
    for (int i = 0; i < frameList.length; i++) {
      final Map<String, dynamic> tmp = {
        "page": frameList[i].page,
        "minX": double.parse(frameList[i].minX.toStringAsFixed(8)),
        "minY": double.parse(frameList[i].minY.toStringAsFixed(8)),
        "maxX": double.parse(frameList[i].maxX.toStringAsFixed(8)),
        "maxY": double.parse(frameList[i].maxY.toStringAsFixed(8)),
      };
      temp.add(tmp);
    }

    final Map<String, String> requestField = {
      "frame_list": jsonEncode(temp),
    };
    debugPrint(jsonEncode(temp));

    request.files.add(multipartFileProblem);
    request.fields.addAll(requestField);

    request.headers.addAll(await defaultHeader(httpContentType.multipart));
    final response = await request.send();
    debugPrint("${response.statusCode}");

    var responseBody = await response.stream.bytesToString();

    var decodedBody = jsonDecode(responseBody);

    pageRectList = List.generate(pageNum, (index) => <Rect>[]);

    for (var element in decodedBody) {
      Frame tempFrame = Frame(page: element["page"], minX: element["minX"], minY: element["minY"], maxX: element["maxX"], maxY: element["maxY"]);
      debugPrint("pageIdx: ${tempFrame.page}, minX: ${tempFrame.minX}, minY: ${tempFrame.minY}, maxX: ${tempFrame.maxX}, maxY: ${tempFrame.maxY}");

      secondFrameList.add(tempFrame);
    }

    return response.statusCode;
  }
}
