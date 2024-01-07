import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Component/Exam_Folder_Treeview.dart';
import 'package:front_end/Component/New_Folder_Button.dart';
import 'package:front_end/Component/Tag_Model.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:front_end/Controller/Tag_Controller.dart';
import 'package:get/get.dart';
import 'package:korea_regexp/korea_regexp.dart';
import 'package:http/http.dart' as http;
import 'package:front_end/Component/FolderData.dart';

class ExamController extends GetxController {
  RxInt totalCount = 0.obs;
  RxBool isFilterFinished = false.obs;
  TextEditingController countController = TextEditingController();
  TextEditingController examNameController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController minlevelController = TextEditingController();
  TextEditingController maxlevelController = TextEditingController();
  RxString tagValue = "".obs;
  RxBool chooseLevel = false.obs;
  RxSet<FolderData> folders = <FolderData>{}.obs;
  RxList<TagModel> tagsList = <TagModel>[].obs;
  RxBool isRandom = true.obs;
  List<dynamic> problemId = [];
  Set<dynamic> uniqueProblems = {};
  List<dynamic> uniqueProblemsToList = [];
  RxList<dynamic> uniqueProblemsDetail = [].obs;
  RxList<bool> isProblemSelected = <bool>[].obs;
  RxInt selectedCount = 0.obs;
  List<dynamic> problemToMakeExam = [];
  String tagName = "";
  int? selectedFolder;
  HomeScreenController homeScreenController = Get.find<HomeScreenController>();

  Rx<Widget> problemImageViewer = Container(
    child: const Center(child: Text("선택된 문제가 없습니다")),
  ).obs;

  ExamController(String name) {
    tagName = name;
    final tagController = Get.find<TagController>();
    for (int i = 0; i < tagController.totalTagList.length; i++) {
      tagsList.add(TagModel(tagController.totalTagList[i].name,
          tagController.totalTagList[i].id!, false));
    }
  }

  /// 선택된 칩 리스트 반환
  List<Widget> selectedChipsList() {
    List<Widget> chips = [];
    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i].isSelected == true) {
        Widget item = m.Card(
          elevation: 0,
          color: Colors.grey[30],
          child: m.FilterChip(
            label: Text(tagsList[i].label),
            labelStyle: const TextStyle(fontSize: 16),
            backgroundColor: Colors.grey[50],
            selected: tagsList[i].isSelected,
            onSelected: (bool value) {
              tagsList[i].isSelected = false;
              tagsList.refresh();
            },
          ),
        );
        chips.add(item);
      }
    }
    return chips;
  }

  List<Widget> filterChipsList() {
    List<Widget> chips = [];
    if (tagValue.value == "") return chips;
    RegExp regExp = getRegExp(
      tagValue.value,
      RegExpOptions(
        initialSearch: true,
        startsWith: false,
        endsWith: false,
        fuzzy: true,
        ignoreSpace: true,
        ignoreCase: true,
      ),
    );

    for (int i = 0; i < tagsList.length; i++) {
      if (tagValue.value == "") {
        break;
      }
      if (regExp.hasMatch(tagsList[i].label)) {
        Widget item = m.Card(
          elevation: 0,
          color: Colors.grey[30],
          child: m.FilterChip(
            elevation: 0.0,
            label: Text(tagsList[i].label),
            labelStyle: const TextStyle(fontSize: 16),
            backgroundColor: Colors.grey[50],
            selected: tagsList[i].isSelected,
            onSelected: (bool value) {
              tagsList[i].isSelected = value;
              tagsList.refresh();
            },
          ),
        );
        if (tagsList[i].isSelected == false) {
          chips.add(item);
        }
      }
    }
    return chips;
  }

  ///선택한 폴더 영역에 해당하는 문제들을 서버로부터 가져오고 필터로 걸러내는 알고리즘
  void getfilteredProblem() async {
    problemId.clear();
    if (folders.isNotEmpty) {
      for (var item in folders) {
        final problemUrl =
            Uri.parse('https://$HOST/api/data/problem/database_all/${item.id}');

        final response = await http.get(
          problemUrl,
          headers: await defaultHeader(httpContentType.json),
        );
        if (isHttpRequestSuccess(response)) {
          final jsonResponse = jsonDecode(response.body);
          problemId.addAll(jsonResponse['problem_list']);
        } else {
          debugPrint("선택한 폴더들 서버에서 문제 받아오기 실패");
        }
      }
    } else {
      for (var item in Get.find<FolderController>().firstFolders) {
        final problemUrl = Uri.parse(
            'https://$HOST/api/data/problem/database_all/${item.value["id"]}');

        final response = await http.get(
          problemUrl,
          headers: await defaultHeader(httpContentType.json),
        );
        if (isHttpRequestSuccess(response)) {
          final jsonResponse = jsonDecode(response.body);
          problemId.addAll(jsonResponse['problem_list']);
        } else {
          debugPrint("선택한 폴더들 서버에서 문제 받아오기 실패");
        }
      }
    }

    uniqueProblems.clear();
    Set<int> uniqueKeys = {}; // 중복을 확인하기 위한 Set

    List<String> targetTags = [];
    for (var item in tagsList) {
      if (item.isSelected) {
        targetTags.add(item.label);
      }
    }

    //필터 작업
    for (var item in problemId) {
      final key = item["id"];
      if (!uniqueKeys.contains(key)) {
        var level = item["level"];
        if ((minlevelController.text.isNotEmpty &&
                maxlevelController.text.isNotEmpty &&
                int.parse(minlevelController.text) <= level &&
                int.parse(maxlevelController.text) >= level) ||
            minlevelController.text.isEmpty) {
          bool? alltagsContained =
              targetTags.every((element) => item["tags"].contains(element));
          if (targetTags.isEmpty || alltagsContained) {
            uniqueProblems.add({"id": item["id"], "uuid": item["uuid"]});
            uniqueKeys.add(key);
          }
        }
      }
    }

    totalCount.value = uniqueProblems.length;
    isFilterFinished.value = true;
    countController.text = totalCount.value.toString();
    await fetchProblemDetail();
  }

  Future<void> fetchProblemDetail() async {
    uniqueProblemsToList = uniqueProblems.toList();
    final url =
        Uri.parse('https://$HOST/api/data/problem/get_detail_problem_data');
    final Map<String, dynamic> requestBody = {
      "problem_list": uniqueProblemsToList,
    };
    isProblemSelected.value =
        List.generate(uniqueProblems.length, (index) => false);
    final response = await http.post(
      url,
      headers: await defaultHeader(httpContentType.json),
      body: jsonEncode(requestBody),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);
      final problemList = jsonResponse['problem_detail'];
      uniqueProblemsDetail.value = problemList;
      uniqueProblemsDetail.refresh();
    } else {
      debugPrint(response.statusCode.toString());
      debugPrint("현재 페이지 문제 받아오기 오류 발생");
    }
  }

  void makeExam(BuildContext context) {
    final examNameController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Center(child: Text("시험지 만들기")),
            content: Column(children: [
              const Text("시험지 이름"),
              const SizedBox(
                height: 15,
              ),
              TextBox(
                controller: examNameController,
                placeholder: "시험지 이름을 입력해주세요",
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("시험지를 저장할 폴더를 선택해주세요"),
              const SizedBox(
                height: 15,
              ),
              Container(
                  child: ExamFolderTreeView(
                tagName: tagName,
              ))
            ]),
            actions: [
              Button(
                child: const Text('취소'),
                onPressed: () {
                  problemToMakeExam.clear();
                  Navigator.pop(context);
                },
              ),
              FilledButton(
                  child: const Text('만들기'),
                  onPressed: () async {
                    if (selectedFolder != null &&
                        examNameController.text.isNotEmpty) {
                      final url =
                          Uri.parse('https://$HOST/api/data/create_exam');
                      final Map<String, dynamic> requestBody = {
                        "problem_list": problemToMakeExam,
                        "name": examNameController.text,
                        "parent_database": selectedFolder,
                        "level": 3,
                      };

                      debugPrint(requestBody.toString());
                      final response = await http.post(
                        url,
                        headers: await defaultHeader(httpContentType.json),
                        body: jsonEncode(requestBody),
                      );
                      if (isHttpRequestSuccess(response)) {
                        final jsonResponse = jsonDecode(response.body);

                        debugPrint(jsonResponse.toString());
                        problemToMakeExam.clear();
                        Navigator.pop(context);
                        displayInfoBar(context, builder: (context, close) {
                          return InfoBar(
                            title: const Text('성공 : '),
                            content: const Text('시험지 생성이 완료되었습니다.'),
                            action: IconButton(
                              icon: const Icon(FluentIcons.clear),
                              onPressed: close,
                            ),
                            severity: InfoBarSeverity.success,
                          );
                        });
                        final examUrl = Uri.parse(
                            'https://$HOST/api/data/user_exam_database');
                        final examResponse = await http.get(
                          examUrl,
                          headers: await defaultHeader(httpContentType.json),
                        );

                        if (isHttpRequestSuccess(examResponse)) {
                          final jsonResponse = jsonDecode(examResponse.body);
                          final examDatabaseFolder =
                              jsonResponse['database_folders'];
                          Get.find<FolderController>()
                              .makeExamFolderListInfo(examDatabaseFolder);
                        } else if (isHttpRequestFailure(response)) {
                          debugPrint("시험지 폴더 리스트 받기 오류 발생");
                        }
                      } else {
                        displayInfoBar(context, builder: (context, close) {
                          return InfoBar(
                            title: const Text('오류 : '),
                            content: const Text(
                                '시험지 생성 과정에서 오류가 발생하였습니다. 관리자에게 문의바랍니다.'),
                            action: IconButton(
                              icon: const Icon(FluentIcons.clear),
                              onPressed: close,
                            ),
                            severity: InfoBarSeverity.error,
                          );
                        });
                        debugPrint(response.statusCode.toString());
                        debugPrint("현재 페이지 문제 받아오기 오류 발생");
                      }
                    } else {
                      displayInfoBar(context, builder: (context, close) {
                        return InfoBar(
                          title: const Text('경고 : '),
                          content: const Text(
                              '시험지 이름 또는 저장할 시험지 폴더가 완료되지 않았습니다. 다시 시도해주세요.'),
                          action: IconButton(
                            icon: const Icon(FluentIcons.clear),
                            onPressed: close,
                          ),
                          severity: InfoBarSeverity.warning,
                        );
                      });
                    }
                  }),
            ],
          );
        });
  }
}
