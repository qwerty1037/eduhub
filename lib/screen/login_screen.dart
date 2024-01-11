import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:front_end/Controller/ScreenController/Login_Screen_Controller.dart';
import 'package:front_end/Controller/Register_Info_Controller.dart';
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

  Container rightScreen(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      color: Theme.of(context).colorScheme.primaryContainer, //const Color.fromARGB(52, 117, 117, 117),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Login",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ), /*
                GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSecondaryContainer, //Colors.white,
              fontSize: 18,*/
          ),
          const SizedBox(
            height: 16,
          ),
          loginTextfield(context),
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
              RegisterInfoButton(),
              const InquiryButton(),
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

  TextField loginTextfield(BuildContext context) {
    return TextField(
      controller: loginController.idController,
      /*style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),*/
      decoration: InputDecoration(
        prefixIcon: const Icon(
          FontAwesomeIcons.mailBulk,
          size: 15.0,
          //color: Theme.of(context).colorScheme.onSecondaryContainer, //Color.fromARGB(155, 255, 255, 255),
        ),
        hintText: "ID",
        /*
        hintStyle: const TextStyle(
          color: Color.fromARGB(127, 255, 255, 255),
        ),*/
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
        // Container(
        //   padding: const EdgeInsets.all(4),
        //   decoration: BoxDecoration(
        //     boxShadow: const [
        //       BoxShadow(
        //         offset: Offset(0, 2),
        //         blurRadius: 5,
        //         color: Color.fromARGB(255, 46, 46, 46),
        //       )
        //     ],
        //     color: Colors.black87,
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       const CircleAvatar(
        //         backgroundColor: Color.fromARGB(255, 46, 46, 46),
        //         maxRadius: 15,
        //         child: Icon(
        //           Icons.play_arrow,
        //           color: Colors.white,
        //           size: 15.0,
        //         ),
        //       ),
        //       const SizedBox(
        //         width: 8.0,
        //       ),
        //       Text(
        //         "유튜브 보기",
        //         style: GoogleFonts.poppins(
        //           color: Colors.white,
        //           fontSize: 12.0,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       const SizedBox(
        //         width: 8.0,
        //       ),
        //     ],
        //   ),
        // )
      ],
    );
  }
}

class InquiryButton extends StatelessWidget {
  const InquiryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      /*
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      */
      child: Text(
        "문의하기",
        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }
}

class RegisterInfoButton extends StatelessWidget {
  RegisterInfoButton({
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
