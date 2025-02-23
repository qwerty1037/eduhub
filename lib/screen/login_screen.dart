import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:front_end/Controller/ScreenController/login_screen_controller.dart';
import 'package:front_end/Controller/register_info_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

///로그인 화면
class LoginScreen extends StatelessWidget {
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
            child: leftDecorationScreen(),
          ),
          Expanded(
            flex: 1,
            child: userLogin(context),
          ),
        ],
      ),
    );
  }

  Stack leftDecorationScreen() {
    return Stack(
      children: [
        //배경이 되는 사진
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //색 첨가
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(172, 68, 137, 255), Color.fromARGB(119, 68, 137, 255)],
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
                    "팀 404_Not_Found ",
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

  Container userLogin(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Login",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          idTextfield(context),
          const SizedBox(
            height: 8,
          ),
          passwordTextfield(context),
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
              MemberRegister(),
              TextButton(
                onPressed: () {},
                child: Text(
                  "문의하기",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  ElevatedButton loginTryButton(loginScreenController loginController, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16.0)),
      onPressed: () async {
        loginController.logInRequest(context);
      },
      child: const Text("로그인"),
    );
  }

  Column loginMainDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "초중고 선생님을 위한\n최고의 툴\n에듀허브",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 48.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  TextField passwordTextfield(BuildContext context) {
    return TextField(
      controller: loginController.passwordController,
      obscureText: true,
      onEditingComplete: () {
        loginController.logInRequest(context);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          FontAwesomeIcons.lock,
          size: 15.0,
        ),
        hintText: "Password",
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

  TextField idTextfield(BuildContext context) {
    return TextField(
      controller: loginController.idController,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          FontAwesomeIcons.mailBulk,
          size: 15.0,
        ),
        hintText: "ID",
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
}

class MemberRegister extends StatelessWidget {
  MemberRegister({
    super.key,
  }) {
    Get.put(RegisterInfoController());
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final Uri url = Uri.parse('https://bateacher.com');
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        "회원가입",
        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }
}
