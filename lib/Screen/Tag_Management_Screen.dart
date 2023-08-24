import 'package:fluent_ui/fluent_ui.dart';

import 'package:front_end/Component/Default/Default_Key_Text.dart';
import 'package:front_end/Component/Default/Default_TextBox.dart';
import 'package:front_end/Controller/Tag_Controller.dart';
import 'package:front_end/Test/Temp_Tag.dart';
import 'package:get/get.dart';

class TagManagementScreen extends StatelessWidget {
  TagManagementScreen({super.key});
  final tagController = Get.find<TagController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
          child: Column(
            children: [
              const DefaultKeyText(text: "추가하실 태그를 입력하세요"),
              SizedBox(
                height: 50,
                child: DefaultTextBox(
                  placeholder: "Insert Tags",
                  onEditingComplete: () {
                    if (tagController.tagsInputController.text != " ") {
                      //TODO: 나중에 엄밀한 문자열 알고리즘 필요
                      tagController.inputedTagsList.add(
                        Tag(
                          id: null,
                          name: tagController.tagsInputController.text,
                          problemCount: 0,
                          ownerId: null,
                        ),
                      );
                      tagController.numberOfTags++;
                      tagController.tagsInputController.text = "";
                    }
                  },
                  controller: tagController.tagsInputController,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.horizontal,
                    children: tagController.inputedChipsList(),
                  ),
                );
              }),
              const SizedBox(height: 20),
              saveButtonField(),
            ],
          ),
        ),
      ),
    );
  }

  /// Button that saves inputed Tags
  ///
  /// When button clicked, http requests to backend
  Widget saveButtonField() {
    return Button(
      onPressed: () {
        tagController.sendTags();
      },
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: const Text(
          "태그 저장하기",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
