//  List<dynamic> test = problemList.sublist(startIndex, endIndex);
//     for (int i = 0; i < test.length; i++) {
//       debugPrint(test[i].toString());

//       final url = Uri.parse(
//           'https://$HOST/api/data/problem/get_detail_problem_data/${test[i]}');
//       final response = await http.get(
//         url,
//         headers: await defaultHeader(httpContentType.json),
//       );

//       if (isHttpRequestSuccess(response)) {
//         final jsonResponse = jsonDecode(response.body);
//         final problemData = jsonResponse['problem_detail'];
//         debugPrint(problemData.toString());

//         currentPageProblems.value.add(problemData);

//         // currentPageProblems.refresh();
//       } else {
//         debugPrint(response.statusCode.toString());
//         debugPrint("fetchPageData(problem_list_controller)");
//       }
//     }


//     ///예전 버전
//     /// final url =
//         Uri.parse('https://$HOST/api/data/problem/get_detail_problem_data');

//     final Map<String, dynamic> requestBody = {
//       "problem_list": problemList.sublist(startIndex, endIndex),
//     };
//     debugPrint(problemList.toString());
//     debugPrint(startIndex.toString());
//     debugPrint(endIndex.toString());
//     final response = await http.post(
//       url,
//       headers: await defaultHeader(httpContentType.json),
//       body: jsonEncode(requestBody),
//     );
//     if (isHttpRequestSuccess(response)) {
//       final jsonResponse = jsonDecode(response.body);
//       final problemData = jsonResponse['problem_detail'];
//       debugPrint(problemData.toString());

//       currentPageProblems.value = problemData;
//       currentPageProblems.refresh();
//     } else {
//       debugPrint(response.statusCode.toString());
//       debugPrint("현재 페이지 문제 받아오기 오류 발생");
//     }