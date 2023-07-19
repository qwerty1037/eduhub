import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class loginScreenController extends GetxController {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  Future<void> saveCookieToSecureStorage(String uid, String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: 'uid', value: uid);
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  void loginSuccess() async {
    TotalController totalController = Get.find<TotalController>();
    FolderController folderController = Get.find<FolderController>();
    await folderController.receiveData();
    totalController.reverseLoginState();
    totalController.update();
    Get.delete<loginScreenController>();
  }

  Future<void> logInRequest(BuildContext context) async {
    final url = Uri.parse('http://$HOST/api/auth/login');
    final Map<String, dynamic> requestBody = {"user_id": idController.text, "user_password": passwordController.text};
    final headers = {"Content-type": "application/json"};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
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
