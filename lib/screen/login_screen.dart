import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:front_end/Component/Default/Config.dart';

import 'package:front_end/Controller/Login_Screen_Controller.dart';
import 'package:front_end/Controller/Register_Info_Controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

///로그인 화면
class LoginScreen extends StatelessWidget {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  loginScreenController loginController = Get.put(loginScreenController());
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: leftScreen(),
          ),
          Expanded(
            flex: 1,
            child: rightScreen(context),
          ),
        ],
      ),
    );
  }

  Container rightScreen(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      color: const Color.fromARGB(52, 117, 117, 117),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Login",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          loginTextfield(),
          const SizedBox(
            height: 8,
          ),
          passwordTextfield(),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: loginTryButton(loginController, context),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              registerInfoButton(),
              const inquiryButton(),
            ],
          )
        ],
      ),
    );
  }

  Stack leftScreen() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(172, 68, 137, 255),
                Color.fromARGB(119, 68, 137, 255)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.baby,
                    size: 15.0,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Baby Teacher",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const Spacer(),
              loginMainDescription(),
              const Spacer(),
            ],
          ),
        )
      ],
    );
  }

  ElevatedButton loginTryButton(
      loginScreenController loginController, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16.0)),
      onPressed: () async {
        final url = Uri.parse('http://$HOST/api/auth/login');
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
        if (response.statusCode == 200) {
          String? cookieList = response.headers["set-cookie"];

          String? uid = loginController.getCookieValue(cookieList!, "uid");
          String? accessToken =
              loginController.getCookieValue(cookieList, "access_token");
          String? refreshToken =
              loginController.getCookieValue(cookieList, "refresh_token");

          if (uid == null || accessToken == null || refreshToken == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("쿠키 저장 오류"),
              ),
            );
          } else {
            await loginController.saveCookieToSecureStorage(
                uid, accessToken, refreshToken);

            loginController.loginSuccess();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("등록되지 않은 아이디입니다"),
            ),
          );
        }
      },
      child: const Text("로그인"),
    );
  }

  TextField passwordTextfield() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          FontAwesomeIcons.lock,
          size: 15.0,
          color: Color.fromARGB(155, 255, 255, 255),
        ),
        hintText: "Password",
        hintStyle: const TextStyle(
          color: Color.fromARGB(127, 255, 255, 255),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        fillColor: const Color.fromARGB(41, 255, 255, 255),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  TextField loginTextfield() {
    return TextField(
      controller: idController,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          FontAwesomeIcons.mailBulk,
          size: 15.0,
          color: Color.fromARGB(155, 255, 255, 255),
        ),
        hintText: "ID",
        hintStyle: const TextStyle(
          color: Color.fromARGB(127, 255, 255, 255),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        fillColor: const Color.fromARGB(41, 255, 255, 255),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Column loginMainDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "선생님을 위한\n최고의 도구\n바-선생",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 48.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 5,
                color: Color.fromARGB(255, 46, 46, 46),
              )
            ],
            color: Colors.black87,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 46, 46, 46),
                maxRadius: 15,
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 15.0,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                "유튜브 보기",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class inquiryButton extends StatelessWidget {
  const inquiryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Text(
        "문의하기",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w300,
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
    );
  }
}

class registerInfoButton extends StatelessWidget {
  registerInfoButton({
    super.key,
  });
  final RegisterInfoController _registerInfoController =
      Get.put(RegisterInfoController());

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shadowColor: Colors.transparent,
                title: const Text(
                  "회원가입",
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: GetBuilder<RegisterInfoController>(
                      builder: (controller) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("아이디"),
                            const SizedBox(
                              height: 5,
                            ),
                            registerTextfield(controller.idController, false),
                            ...betweenTextfield("비밀번호"),
                            registerTextfield(
                                controller.passwordController, true),
                            ...betweenTextfield("비밀번호 확인"),
                            registerTextfield(
                                controller.checkPasswordController, true),
                            ...betweenTextfield("이름"),
                            registerTextfield(controller.nameController, false),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("성별"),
                            chooseSexButton(controller),
                            ...betweenTextfield("나이"),
                            registerTextfield(controller.ageController, false),
                            ...betweenTextfield("이메일"),
                            registerTextfield(
                                controller.emailController, false),
                            ...betweenTextfield("닉네임"),
                            registerTextfield(
                                controller.nicknameController, false),
                            SizedBox(
                              height: 20,
                              child: controller.matchpassword
                                  ? const Text("")
                                  : const Text("비밀번호가 다릅니다"),
                            ),
                            SizedBox(
                              height: 20,
                              child: controller.formatCorrect
                                  ? const Text("")
                                  : const Text(
                                      "입력이 완료되지 않았습니다",
                                      style: TextStyle(fontSize: 10),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(16.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Get.delete<RegisterInfoController>();
                          },
                          child: const Text("취소"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(16.0)),
                          onPressed: () {
                            _registerInfoController.tryMakeId(context);
                          },
                          child: const Text("가입하기"),
                        ),
                      )
                    ],
                  ),
                ],
              );
            });
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Text(
        "회원가입",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w300,
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
    );
  }

  Column chooseSexButton(RegisterInfoController controller) {
    return Column(
      children: [
        RadioListTile<int>(
          value: 0,
          groupValue: controller.selectedGender,
          onChanged: (value) {
            controller.selectedGender = value!;
            controller.update();
          },
          title: const Text('남'),
        ),
        RadioListTile<int>(
          value: 1,
          groupValue: controller.selectedGender,
          onChanged: (value) {
            controller.selectedGender = value!;
            controller.update();
          },
          title: const Text('여'),
        ),
      ],
    );
  }

  SizedBox registerTextfield(TextEditingController controller, bool obscure) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(),
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          fillColor: const Color.fromARGB(111, 158, 158, 158),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  List<Widget> betweenTextfield(String name) {
    return [
      const SizedBox(
        height: 10,
      ),
      Text(name),
      const SizedBox(
        height: 5,
      )
    ];
  }
}
