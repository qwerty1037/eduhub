import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/Default_Key_Text.dart';
import 'package:front_end/Component/Default/Default_Text_FIeld.dart';

import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:front_end/Controller/Feedback_Controller.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void createFeedbackOverlay({
  required BuildContext context,
}) {
  final controller = Get.put(FeedbackController());
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    // Create a new OverlayEntry.
    builder: (BuildContext context) {
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.1,
        top: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Center(
                              child: Text(
                                "피드백 보내기",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              child: const Text("나가기"),
                              onPressed: () {
                                controller.delete();
                                overlayEntry?.remove();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: [
                                const DefaultKeyText(text: "제목"),
                                DefaultTextField(
                                  controller: controller.titleController,
                                  hintText: "제목을 입력하세요",
                                  onChanged: (value) =>
                                      controller.titleController.text,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const DefaultKeyText(text: "피드백 내용"),
                                Scrollbar(
                                  child: DefaultTextField(
                                    controller: controller.contentController,
                                    hintText: "피드백 내용을 입력하세요",
                                    onChanged: (value) =>
                                        controller.contentController.text,
                                    minLines: 1,
                                    maxLines: 8,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final url = Uri.parse(
                                        'http://$HOST/api/data/feedback');
                                    final headers = await defaultHeader(
                                        httpContentType.json);
                                    final Map<String, dynamic> requestBody = {
                                      "title": controller.titleController.text,
                                      "feedback":
                                          controller.contentController.text,
                                    };
                                    final response = await http.post(
                                      url,
                                      headers: headers,
                                      body: jsonEncode(requestBody),
                                    );
                                    if (response.statusCode ~/ 100 == 2) {
                                      debugPrint(
                                          response.statusCode.toString());
                                      debugPrint("피드백 전송 완료");
                                      Get.delete<FeedbackController>();
                                      Navigator.pop(context);
                                    } else {
                                      debugPrint(
                                          response.statusCode.toString());
                                      debugPrint("피드백 전송 오류");
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: const Text(
                                      "이렇게 저장하기",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  overlayState.insert(overlayEntry);
  // Add the OverlayEntry to the Overlay.
  // Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
}
