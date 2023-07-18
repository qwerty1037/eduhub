import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterInfoController extends GetxController {
  //0이면 남자 1이면 여자(버튼 순서)
  int selectedGender = 0;
  bool matchpassword = true;
  bool formatCorrect = true;

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  bool isCorrectFormat() {
    return idController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        emailController.text.isNotEmpty;
  }

  Future<int> sendRegisterInfo() async {
    final url = Uri.parse('http://$HOST/api/auth/register');
    final Map<String, dynamic> requestBody = {
      "user_id": idController.text,
      "user_password": passwordController.text,
      "user_email": emailController.text,
      "user_nickname": nicknameController.text,
      "real_name": nameController.text,
      "gender": selectedGender == 0 ? true : false,
      "age": int.parse(ageController.text),
    };
    final headers = {"Content-type": "application/json"};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    return response.statusCode;
  }

  Future<void> tryMakeId(BuildContext context) async {
    matchpassword = true;
    formatCorrect = true;

    if (passwordController.text != checkPasswordController.text) {
      matchpassword = false;
      update();
    } else {
      if (isCorrectFormat()) {
        final statusCode = await sendRegisterInfo();
        if (statusCode == 200) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("회원가입이 완료되었습니다"),
            ),
          );
          Get.delete<RegisterInfoController>();
        } else {
          debugPrint("서버에서 회원가입 거부");
          formatCorrect = false;
          update();
        }
      } else {
        formatCorrect = false;
        update();
      }
    }
  }
}
