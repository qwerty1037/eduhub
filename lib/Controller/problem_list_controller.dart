import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

///ProblemList의 로직을 담당하는 컨트롤러
class ProblemListController extends GetxController {
  Rx<fileType> problemFileType = fileType.empty.obs;
  bool isExam = false;
  List<dynamic> problemList = [];
  RxInt selectedIndex = 99.obs;
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
  final int itemsPerPage = 16; //2;
  late int startIndex;
  late int endIndex;
  int lastButton = 1;
  List<Widget> pageButton = <Widget>[];
  int currentIndex = 999; //1~16;

  RxBool isOneColumn = false.obs;
  RxList<int> bytes = <int>[].obs;

  ProblemListController(List<dynamic> data, bool isExam) {
    isExam = isExam;
    problemList = data.toList();
    startIndex = currentPage * itemsPerPage;
    endIndex = currentPage * itemsPerPage + itemsPerPage;
    if (endIndex > problemList.length) {
      endIndex = problemList.length;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    lastButton = (problemList.length - 1) ~/ itemsPerPage + 1;
    if (endIndex > problemList.length) {
      endIndex = problemList.length;
    }

    makePageButton();
    await fetchPageData();
  }

  void changePage(int i) {
    if (i > lastButton) {
      debugPrint("페이지의 인덱스를 벗어난 요청입니다");
      return;
    }
    currentPage = i - 1;
    startIndex = currentPage * itemsPerPage;
    endIndex = currentPage * itemsPerPage + itemsPerPage;
    if (endIndex > problemList.length) {
      endIndex = problemList.length;
    }
  }

  ///폴더 직속문제 보기 / 폴더 아래 모든 문제 보기 버튼을 클릭했을때 내부 데이터를 새로 초기화하는 함수
  Future<void> resetVariable(
      TreeViewItem targetFolder, List<dynamic> problems) async {
    problemList.clear();
    pageButton.clear();
    currentPageProblems.clear();

    if (!isAllProblems.value) {
      final problemUrl = Uri.parse(
          'https://$HOST/api/data/problem/database_all/${targetFolder.value["id"]}');

      final response = await http.get(
        problemUrl,
        headers: await defaultHeader(httpContentType.json),
      );
      if (isHttpRequestSuccess(response)) {
        final jsonResponse = jsonDecode(response.body);
        final totalProblems = jsonResponse['problem_list'];
        List<dynamic> problemIds = [];
        for (int i = 0; i < totalProblems.length; i++) {
          problemIds.add(totalProblems[i]["id"]);
        }
        problemList.addAll(problemIds);
        lastButton = (totalProblems.length - 1) ~/ itemsPerPage + 1;
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
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint("폴더 전체 문제 받기 오류 발생");
      }
    } else {
      for (int i = 0; i < problems.length; i++) {
        problemList.add(problems[i]["id"]);
      }
      problemList.addAll(problems);
      lastButton = (problems.length - 1) ~/ itemsPerPage + 1;
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
    if (lastButton >= 10) {
      if (currentPage >= 10) {
        IconButton toFirstButton = IconButton(
          icon: const Icon(FluentIcons.chevron_left_end6),
          onPressed: () {
            changePage(1);
          },
        );

        IconButton toPrevButton = IconButton(
          icon: const Icon(FluentIcons.chevron_left_med),
          onPressed: () {
            changePage(currentPage - 10);
          },
        );
        pageButton.add(toFirstButton);
        pageButton.add(toPrevButton);
      }
    }
    int firstIdx = (currentPage + 1) - ((currentPage + 1) ~/ 10);
    int lastIdx = ((firstIdx + 9) > lastButton) ? lastButton : (firstIdx + 1);
    for (int i = firstIdx; i <= lastIdx; i++) {
      Button newButton = Button(
        child: Text(
          i.toString(),
          style: TextStyle(
              fontWeight:
                  currentPage == i ? FontWeight.bold : FontWeight.normal),
        ),
        onPressed: () async {
          changePage(i);
          fetchPageData();
          currentPageProblems.refresh();
        },
      );
      pageButton.add(newButton);
    }

    if (lastButton >= 10) {
      if (currentPage >= 10) {
        IconButton toLastButton = IconButton(
          icon: const Icon(FluentIcons.chevron_right_end6),
          onPressed: () {
            changePage(lastButton);
          },
        );

        IconButton toNextButton = IconButton(
          icon: const Icon(FluentIcons.chevron_right_med),
          onPressed: () {
            changePage(currentPage + 10);
          },
        );
        pageButton.add(toNextButton);
        pageButton.add(toLastButton);
      }
    }
  }

  ///문제 리스트 중에 현재 페이지에 있는 리스트들의 자세한 데이터를 받아오는 함수 TODO: 업데이트 예정. id, uuid모두 보내는데 id만 필요할 예정
  Future<void> fetchPageData() async {
    List<dynamic> test = problemList.sublist(startIndex, endIndex);
    for (int i = 0; i < test.length; i++) {
      final int id;
      if (isExam) {
        id = test[i]["problemId"]; //TODO 체크
      } else {
        id = test[i];
      }
      final url = Uri.parse(
          'https://$HOST/api/data/problem/get_detail_problem_data/$id');
      final response = await http.get(
        url,
        headers: await defaultHeader(httpContentType.json),
      );

      if (isHttpRequestSuccess(response)) {
        final jsonResponse = jsonDecode(response.body);
        final problemData = jsonResponse['problem_detail'];

        currentPageProblems.value.add(problemData);
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint("fetchPageData(problem_list_controller)");
      }
    }
    currentPageProblems.refresh();
  }
}

enum fileType { empty, pdf, png, jpg }
