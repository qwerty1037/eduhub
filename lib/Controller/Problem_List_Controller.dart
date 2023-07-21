import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

///ProblemList의 로직을 담당하는 컨트롤러
class ProblemListController extends GetxController {
  List<dynamic> problemList = [];
  List<List<dynamic>> savedProblemArray = [];
  RxList<dynamic> currentPageProblems = [].obs;
  Rx<Widget> problemImageViewer = Container(
    decoration: const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Colors.black,
          width: 0.5,
        ),
      ),
    ),
    child: const Center(child: Text("선택된 문제가 없습니다")),
  ).obs;
  RxBool isAllProblems = false.obs;
  int currentPage = 0;
  int itemsPerPage = 16;
  late int startIndex;
  late int endIndex;
  int lastButton = 1;
  List<Button> pageButton = <Button>[];

  ProblemListController(this.problemList) {
    startIndex = currentPage * itemsPerPage;
    endIndex = currentPage * itemsPerPage + itemsPerPage;
  }

  @override
  void onInit() async {
    super.onInit();

    lastButton = (problemList.length - 1) ~/ 16 + 1;
    if (endIndex > problemList.length) {
      endIndex = problemList.length;
    }
    makePageButton();
    await fetchPageData();
  }

  ///폴더 직속문제 보기 / 폴더 아래 모든 문제 보기 버튼을 클릭했을때 내부 데이터를 새로 초기화하는 함수
  void resetVariable(TreeViewItem targetFolder, List<dynamic> problems) async {
    problemList.clear();
    savedProblemArray.clear();
    pageButton.clear();
    currentPageProblems.clear();

    if (!isAllProblems.value) {
      final problemUrl = Uri.parse(
          'http://$HOST/api/data/problem/database_all/${targetFolder.value["id"]}');

      final response = await http.get(
        problemUrl,
        headers: await defaultHeader(httpContentType.json),
      );
      if (isHttpRequestSuccess(response)) {
        final jsonResponse = jsonDecode(response.body);

        final totalProblems = jsonResponse['problem_list'];
        problemList.addAll(totalProblems);
        lastButton = (totalProblems.length - 1) ~/ 20 + 1;
        currentPage = 0;
        startIndex = 0;
        endIndex = itemsPerPage;

        if (endIndex > problemList.length) {
          endIndex = problemList.length;
        }
        makePageButton();
        problemImageViewer.value = Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
          ),
          child: const Center(
            child: Text("선택된 문제가 없습니다"),
          ),
        );
        await fetchPageData();
      } else if (isHttpRequestFailure(response)) {
        debugPrint(response.statusCode.toString());
        debugPrint("폴더 전체 문제 받기 오류 발생");
      }
    } else {
      problemList.addAll(problems);
      lastButton = (problems.length - 1) ~/ 20 + 1;
      currentPage = 0;
      startIndex = 0;
      endIndex = itemsPerPage;

      if (endIndex > problemList.length) {
        endIndex = problemList.length;
      }
      makePageButton();
      problemImageViewer.value = Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
        ),
        child: const Center(
          child: Text("선택된 문제가 없습니다"),
        ),
      );
      await fetchPageData();
    }
    currentPageProblems.refresh();
  }

  ///문제 리스트들의 페이지 버튼을 새로 만드는 함수
  void makePageButton() {
    for (int i = 1; i <= lastButton; i++) {
      savedProblemArray.add([]);
      Button newButton = Button(
        child: Text(
          i.toString(),
          style: TextStyle(
              fontWeight:
                  currentPage == i ? FontWeight.bold : FontWeight.normal),
        ),
        onPressed: () async {
          if (savedProblemArray[i].isEmpty) {
            currentPage = i;
            await fetchPageData();
            savedProblemArray[i] = currentPageProblems.toList();
          } else {
            currentPageProblems.value = savedProblemArray[i].toList();
            currentPageProblems.refresh();
          }
        },
      );
      pageButton.add(newButton);
    }
  }

  ///문제 리스트 중에 현재 페이지에 있는 리스트들의 자세한 데이터를 받아오는 함수
  Future<void> fetchPageData() async {
    final url =
        Uri.parse('http://$HOST/api/data/problem/get_detail_problem_data');
    final Map<String, dynamic> requestBody = {
      "problem_list": problemList.sublist(startIndex, endIndex),
    };

    final response = await http.post(
      url,
      headers: await defaultHeader(httpContentType.json),
      body: jsonEncode(requestBody),
    );
    if (isHttpRequestSuccess(response)) {
      final jsonResponse = jsonDecode(response.body);
      final problemList = jsonResponse['problem_detail'];
      currentPageProblems.value = problemList;
      currentPageProblems.refresh();
      debugPrint(problemList.toString());
    } else {
      debugPrint(response.statusCode.toString());
      debugPrint("현재 페이지 문제 받아오기 오류 발생");
    }
  }
}
