import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

///회원 가입에 사용되는 컨트롤러
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

  ///채워야할 정보를 모두 채웠는지 확인하는 함수
  bool isCorrectFormat() {
    return idController.text.isNotEmpty && passwordController.text.isNotEmpty && nameController.text.isNotEmpty && ageController.text.isNotEmpty && emailController.text.isNotEmpty;
  }

  ///입력한 정보를 백엔드에 보내는 함수
  Future<int> sendRegisterInfo() async {
    final url = Uri.parse('https://$HOST/api/auth/register');
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

  ///유저가 회원가입 시도시 회원가입이 가능한 형태인지 검증한 후 가능한 형태시 다른 함수에 넘겨줌
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
