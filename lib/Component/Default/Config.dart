import 'package:flutter/material.dart';

const DEFAULT_DARK_COLOR = Color(0xFF000000);
const DEFAULT_TAB_COLOR = Colors.grey;
// Color(0xFF363943);

const DEFAULT_LIGHT_COLOR = Color(0xFFFFFFFF);

const DEFAULT_TEXT_COLOR = Colors.black;
const DEFAULT_TEXT_ALERT_COLOR = Colors.red;
const DEFAULT_BUTTON_COLOR = Colors.blueAccent;
const DEFAULT_UNABLE_COLOR = Colors.grey;

const double DEFAULT_HEAD_FONT_SIZE = 40;
const double DEFAULT_TEXT_FONT_SIZE = 25;
const double DEFAULT_BUTTON_FONT_SIZE = 30;

const String HOST = '175.197.24.70:3000';

//175.197.24.70
//61.82.182.149 원격연결

/*
Future<int> httpMultipartFilePost(Uri url, ) async{

    final url = Uri.parse('http://$HOST/api/data/create_problem');
    var request = http.MultipartRequest('POST', url);

    var multipartFileProblem = http.MultipartFile.fromBytes(
      'problem_image',
      capturedImageProblem,
      filename: capturedFileNameProblem,
      contentType:
          MediaType('image', 'jpeg'), // 이미지의 적절한 Content-Type을 설정해야 합니다.
    );

    var multipartFileAnswer = http.MultipartFile.fromBytes(
      'problem_image',
      capturedImageAnswer,
      filename: capturedFileNameAnswer,
      contentType:
          MediaType('image', 'jpeg'), // 이미지의 적절한 Content-Type을 설정해야 합니다.
    );

    final Map<String, dynamic> requestBody = {
      "problem_name": problemNameController.text,
      "parent_database": 1,
      //"directory": "\"{directorytext}\"",
      "tags": selectedTags
          .join(), //애초에 TAG class가 있고 거기에서 id만 List<LongLongInt>로 보내기
      "level": difficultySliderValue.round(),
      //"problem_image": [multipartFileProblem, multipartFileAnswer],
      "problem_string": capturedFileNameProblem,
      "answer_string": capturedFileNameAnswer,
    };
    final Map<String, String> temp = {};
    requestBody.forEach((key, value) {
      temp.addAll(Map.fromEntries([MapEntry(key, value.toString())]));
    });

    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(multipartFileProblem);
    request.files.add(multipartFileAnswer);
    request.fields.addAll(temp);

    final response = await request.send();
    print(response.statusCode);
    return response.statusCode;
}
*/
