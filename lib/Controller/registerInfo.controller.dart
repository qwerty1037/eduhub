import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end/Component/Config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterInfoController extends GetxController {
  RxInt selectedGender = 0.obs;
  RxBool matchpassword = true.obs;
  RxBool formatCorrect = true.obs;

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
}
