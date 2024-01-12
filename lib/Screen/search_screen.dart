import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/default_text_box.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:front_end/Test/temp_file_class.dart';
import 'package:get/get.dart';
import 'package:front_end/Controller/search_controller.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(SearchScreenController(), tag: Get.find<FluentTabController>().getTabKey());
  final TempFileClass _tempFileClass = TempFileClass();

  SearchScreen({super.key, String? text, int? difficulty, String? content}) {
    if (text != null) {
      controller.searchBarController.text = text;
    }
    if (difficulty != null) {
      controller.setDifficulty(difficulty);
    }
    if (content != null) {
      controller.setContent(content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextBox(
          labelText: null,
          placeholder: '검색하세요',
          controller: controller.searchBarController,
          onChanged: (value) {},
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 200,
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    //CustomDropdownPage(),
                    Obx(
                      () => DropDownButton(
                        items: controller.difficultyList,
                        title: Expanded(
                          child: Text(
                            "Difficulty: ${controller.getDifficulty() ?? ""}",
                            style: const TextStyle(fontSize: 21),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => DropDownButton(
                        items: controller.contentList,
                        title: Expanded(
                          child: Text(
                            "Content: ${controller.getContent()}",
                            style: const TextStyle(fontSize: 21),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => CustomScrollView(
                    primary: false,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverGrid.count(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: _tempFileClass.getGridView(controller.getDifficulty()),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
