  // Column chooseSexButton(RegisterInfoController controller) {
  //   return Column(
  //     children: [
  //       RadioListTile<int>(
  //         value: 0,
  //         groupValue: controller.selectedGender,
  //         onChanged: (value) {
  //           controller.selectedGender = value!;
  //           controller.update();
  //         },
  //         title: const Text('남'),
  //       ),
  //       RadioListTile<int>(
  //         value: 1,
  //         groupValue: controller.selectedGender,
  //         onChanged: (value) {
  //           controller.selectedGender = value!;
  //           controller.update();
  //         },
  //         title: const Text('여'),
  //       ),
  //     ],
  //   );
  // }

  // SizedBox registerTextfield(TextEditingController controller, bool obscure) {
  //   return SizedBox(
  //     width: 300,
  //     child: TextField(
  //       controller: controller,
  //       obscureText: obscure,
  //       style: const TextStyle(),
  //       decoration: InputDecoration(
  //         filled: true,
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 16.0,
  //         ),
  //         fillColor: const Color.fromARGB(111, 158, 158, 158),
  //         border: OutlineInputBorder(
  //           borderSide: const BorderSide(color: Colors.transparent),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: const BorderSide(color: Colors.transparent),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: const BorderSide(color: Colors.transparent),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<Widget> betweenTextfield(String name) {
  //   return [
  //     const SizedBox(
  //       height: 10,
  //     ),
  //     Text(name),
  //     const SizedBox(
  //       height: 5,
  //     )
  //   ];
  // }