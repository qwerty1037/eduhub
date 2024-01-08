// showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 shadowColor: Colors.transparent,
//                 title: const Text(
//                   "회원가입",
//                   textAlign: TextAlign.center,
//                 ),
//                 content: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                     ),
//                     child: GetBuilder<RegisterInfoController>(
//                       builder: (controller) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("아이디"),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             registerTextfield(controller.idController, false),
//                             ...betweenTextfield("비밀번호"),
//                             registerTextfield(controller.passwordController, true),
//                             ...betweenTextfield("비밀번호 확인"),
//                             registerTextfield(controller.checkPasswordController, true),
//                             ...betweenTextfield("이름"),
//                             registerTextfield(controller.nameController, false),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             const Text("성별"),
//                             chooseSexButton(controller),
//                             ...betweenTextfield("나이"),
//                             registerTextfield(controller.ageController, false),
//                             ...betweenTextfield("이메일"),
//                             registerTextfield(controller.emailController, false),
//                             ...betweenTextfield("닉네임"),
//                             registerTextfield(controller.nicknameController, false),
//                             SizedBox(
//                               height: 20,
//                               child: controller.matchpassword ? const Text("") : const Text("비밀번호가 다릅니다"),
//                             ),
//                             SizedBox(
//                               height: 20,
//                               child: controller.formatCorrect
//                                   ? const Text("")
//                                   : const Text(
//                                       "입력이 완료되지 않았습니다",
//                                       style: TextStyle(fontSize: 10),
//                                     ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 actions: [
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             padding: const EdgeInsets.all(16.0),
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                             Get.delete<RegisterInfoController>();
//                           },
//                           child: const Text("취소"),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               padding: const EdgeInsets.all(16.0)),
//                           onPressed: () {
//                             _registerInfoController.tryMakeId(context);
//                           },
//                           child: const Text("가입하기"),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               );
//             });