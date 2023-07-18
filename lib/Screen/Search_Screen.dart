import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Default/Default_TextBox.dart';
import 'package:front_end/Test/Temp_File_Class.dart';
import 'package:get/get.dart';
import 'package:front_end/Controller/Search_Controller.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(SearchScreenController());
  final TempFileClass _tempFileClass = TempFileClass();

  SearchScreen({super.key});

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
                            "Difficulty: ${controller.getDifficulty() != 999 ? controller.getDifficulty() : ''}",
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
                          children: _tempFileClass
                              .getGridView(controller.getDifficulty()),
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
