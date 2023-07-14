  
              //폴더 직속 문제들만 받아오기
              final url =
                  Uri.parse('http://$HOST/api/data/problem/database/:id');

              final headers = {await sendCookieToBackend(),
              "database_id":item.value["id"]
              };

              final response = await http.get(
                url,
                headers: headers,
              );
              if (response.statusCode ~/ 100 == 2) {
                final jsonResponse = jsonDecode(response.body);
                final problemList = jsonResponse['problem_list'];
                debugPrint(problemList.toString());
              } else {
                debugPrint(response.statusCode.toString());
                debugPrint("폴더 직속 문제 받기 오류 발생");
              }
              
              //폴더 전체 문제들 받아오기

             final url =
                  Uri.parse('http://$HOST/api/data/problem/database_all/:id');
              final headers = {await sendCookieToBackend(),
              "database_id":item.value["id"]
              };
              final response = await http.get(
                url,
                headers: headers
              );
              if (response.statusCode ~/ 100 == 2) {
                final jsonResponse = jsonDecode(response.body);
                final problemList = jsonResponse['problem_list'];
                debugPrint(problemList.toString());
              } else {
                debugPrint(response.statusCode.toString());
                debugPrint("폴더 전체 문제 받기 오류 발생");
              }
              //폴더 아래 폴더 리스트 받아오기
              
             final url =
                  Uri.parse('http://$HOST/api/data/get_database/:database_id');

              final headers = {await sendCookieToBackend(),
              "database_id":item.value["id"]
              };

              final response = await http.get(
                url,
                headers: headers 
              );
              if (response.statusCode ~/ 100 == 2) {
                final jsonResponse = jsonDecode(response.body);
                final belowFolderList = jsonResponse['database'];
                debugPrint(problemList.toString());
              } else {
                debugPrint(response.statusCode.toString());
                debugPrint("하위 폴더 받기 오류 발생");
              }


              




              //problem 자세한 정보 받아오기
              final url = Uri.parse(
                              'http://$HOST/api/data/problem/get_detail_problem_data');
              final Map<String, dynamic> requestBody = {
                            "problem_list": {["id": number, "uuid": string]}

                          };

              final response = await http.post(
                            url,
                            headers: await sendCookieToBackend(),
                            body: jsonEncode(requestBody),
                          );

              if (response.statusCode ~/ 100 == 2) {
                final jsonResponse = jsonDecode(response.body);
                final belowFolderList = jsonResponse['problem_detail'];
                debugPrint(problemList.toString());
              } else {
                debugPrint(response.statusCode.toString());
                debugPrint("하위 폴더 받기 오류 발생");
              }


///한번에 폴더 다 받아올지 한단계씩 받아올지 결정해야함. 