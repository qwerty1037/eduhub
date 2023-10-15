import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Group_TreeView_Controller.dart';
import 'package:front_end/Controller/Register_Info_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

///로그인 관련 로직처리하는 컨트롤러
class loginScreenController extends GetxController {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var storage = const FlutterSecureStorage();

  ///쿠키 headder와 cookieName을 파라미터로 받아 이름에 해당하는 내용을 추출하는 함수
  String? getCookieValue(String cookieHeader, String cookieName) {
    if (cookieHeader.isNotEmpty) {
      List<String> cookies = cookieHeader.split(RegExp(r';|,'));
      for (String cookie in cookies) {
        cookie = cookie.trim();
        if (cookie.startsWith('$cookieName=')) {
          return cookie.substring(cookieName.length + 1);
        }
      }
    }
    return null;
  }

  ///쿠키를 안전한 보관소에 저장하는 함수
  Future<void> saveCookieToSecureStorage(
      String uid, String accessToken, String refreshToken) async {
    await storage.write(key: 'uid', value: uid);
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  ///로그인 성공시 적용되는 로직으로 초기 데이터를 받아오고 탭뷰를 띄워주며 현재 컨트롤러 인스턴스를 삭제
  void loginSuccess() async {
    TotalController totalController = Get.find<TotalController>();
    FolderController folderController = Get.find<FolderController>();
    GroupTreeViewController groupController =
        Get.find<GroupTreeViewController>();
    await folderController.receiveData();
    await groupController.receiveData();
    totalController.reverseLoginState();
    totalController.update();
    Get.delete<loginScreenController>();
    Get.delete<RegisterInfoController>();
  }

  ///백엔드에 로그인을 요청하는 함수로 성공시 쿠키를 저장하고 loginSuccess를 실행한다
  Future<void> logInRequest(BuildContext context) async {
    final url = Uri.parse('https://$HOST/api/auth/login');

    final Map<String, dynamic> requestBody = {
      "user_id": idController.text,
      "user_password": passwordController.text
    };
    final headers = {"Content-type": "application/json"};
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    storage.write(key: "id", value: idController.text);
    if (isHttpRequestSuccess(response)) {
      String? cookieList = response.headers["set-cookie"];

      String? uid = getCookieValue(cookieList!, "uid");
      String? accessToken = getCookieValue(cookieList, "access_token");
      String? refreshToken = getCookieValue(cookieList, "refresh_token");

      if (uid == null || accessToken == null || refreshToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("쿠키 저장 오류"),
          ),
        );
      } else {
        await saveCookieToSecureStorage(uid, accessToken, refreshToken);

        loginSuccess();
      }
    }

    if (isHttpRequestFailure(response)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("등록되지 않은 아이디입니다"),
        ),
      );
    }
  }
}
