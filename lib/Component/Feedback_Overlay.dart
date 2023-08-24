import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/Default_Key_Text.dart';
import 'package:front_end/Component/Default/Default_TextBox.dart';

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
          child: ScaffoldPage(
            content: Stack(
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
                                "평가 및 건의",
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
                            child: Button(
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
                                SizedBox(
                                  height: 50,
                                  child: DefaultTextBox(
                                    placeholder: "제목을 입력하세요",
                                    controller: controller.titleController,
                                    onChanged: (value) =>
                                        controller.titleController.text,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const DefaultKeyText(text: "평가 및 건의 내용"),
                                Scrollbar(
                                    child: SizedBox(
                                  height: 50,
                                  child: DefaultTextBox(
                                    placeholder: "내용을 입력하세요",
                                    controller: controller.contentController,
                                    onChanged: (value) =>
                                        controller.contentController.text,
                                    minLines: 1,
                                    maxLines: 8,
                                  ),
                                )),
                                const SizedBox(
                                  height: 20,
                                ),
                                Button(
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: const Text(
                                      "이렇게 저장하기",
                                      style: TextStyle(
                                        fontSize: 20,
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
