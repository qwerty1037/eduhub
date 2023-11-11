import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' as material;
import 'package:file_picker/file_picker.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:flutter/services.dart';

class PdfFile {
  Uint8List? capturedImage;
}

///GetxController of pdf_test
class PdfViewerScreenController extends GetxController {
  Color defaultColor = material.Colors.grey[400]!;
  Color uploadingColor = material.Colors.blue[100]!;
  RxBool isPdfInputed = false.obs;
  File? pickedFile;
  RxString pickedFileName = "".obs;
  Uint8List? capturedImage;
  RxBool isDragged = false.obs;
  RxBool isCaptured = false.obs;
  RxInt pickedFileSize = 0.obs;
  RxBool showProcess = false.obs;

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

    CapturedData? capturedData = await screenCapturer.capture(
      mode: CaptureMode.region, // screen, window
      imagePath: "null",
      copyToClipboard: true,
    );
    if (capturedData == null) {
      print("Capture Failed");
    } else {
      // TODO: null이 입력되었을 때의 처리구문을 작성해야함
      capturedImage = capturedData.imageBytes;
      isCaptured.value = true;
    }
  }

  /// Delete capturedImage
  ///
  ///
  void deleteCapturedImage() {
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
    final folderController = Get.find<FolderController>();
    return pickedFile != null && folderController.selectedPath.value.isNotEmpty;
  }

  void makeProblemsFromPdf(BuildContext context) async {
    //
    //pickedfile을 서버에 보내기
    //보내야 하는건 저장할 위치 이름과 파일, 끝나면 서버처리 확인하는 엔드포인트(로딩) -> 끝나면 폴더 업데이트 추가
    final folderController = Get.find<FolderController>();

    if (checkPdfCondition()) {
      final url = Uri.parse('https://$HOST/api/data/create_problem');
      var request = http.MultipartRequest('POST', url);

      request.files.add(http.MultipartFile('pdf_file', pickedFile!.openRead(), pickedFileSize.value, filename: pickedFileName.value));

      request.fields.addAll({
        "parent_database": Get.find<FolderController>().selectedDirectoryID.value.toString(),
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
}
