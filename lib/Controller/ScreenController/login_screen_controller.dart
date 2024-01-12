import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/config.dart';
import 'package:front_end/Component/Default/http_config.dart';
import 'package:front_end/Component/cookie.dart';
import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/group_treeview_controller.dart';
import 'package:front_end/Controller/Register_Info_Controller.dart';
import 'package:front_end/Controller/user_desktop_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

///로그인 관련 로직처리하는 컨트롤러
class loginScreenController extends GetxController {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var storage = const FlutterSecureStorage();

  ///백엔드에 로그인을 요청하는 함수로 성공시 쿠키를 저장하고 loginSuccess를 실행한다
  Future<void> logInRequest(BuildContext context) async {
    final url = Uri.parse('https://$HOST/api/auth/login');
    final Map<String, dynamic> requestBody = {"user_id": idController.text, "user_password": passwordController.text};
    final headers = {"Content-type": "application/json"};
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    storage.write(key: "id", value: idController.text);
    if (isHttpRequestSuccess(response)) {
      String? cookieList = response.headers["set-cookie"];
      String? uid = extractCookieValue(cookieList!, "uid");
      String? accessToken = extractCookieValue(cookieList, "access_token");
      String? refreshToken = extractCookieValue(cookieList, "refresh_token");
      if (uid == null || accessToken == null || refreshToken == null) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              severity: InfoBarSeverity.error,
              title: const Text('서버 상태가 불안정합니다. 홈페이지에 문의 부탁드립니다.'),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: close,
              ),
            );
          },
        );
      } else {
        await saveCookieToSecureStorage(uid, accessToken, refreshToken);
        loginSuccess();
      }
    } else {
      displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            severity: InfoBarSeverity.error,
            title: const Text('등록되지 않은 아이디입니다'),
            action: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: close,
            ),
          );
        },
      );
    }
  }

  ///로그인 성공시 적용되는 로직으로 초기 데이터를 받아오고 메인 페이지를 띄워주며 로그인 관련 컨트롤러 인스턴스를 삭제
  void loginSuccess() async {
    UserDesktopController userDesktopController = Get.find<UserDesktopController>();
    UserDataController userDataController = Get.find<UserDataController>();
    GroupTreeViewController groupController = Get.find<GroupTreeViewController>();
    await userDataController.receiveData();
    await groupController.receiveData(); //TODO: UserDataController에 이동후 추후 삭제 예정
    userDesktopController.login();
    Get.delete<loginScreenController>();
    Get.delete<RegisterInfoController>();
  }
}
