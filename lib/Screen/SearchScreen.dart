import 'dart:ffi';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:front_end/Component/DefaultTextBox.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Test/TempFileClass.dart';
import 'package:get/get.dart';
import 'package:front_end/Controller/SearchController.dart';
import '../Component/DefaultTextFIeld.dart';
import 'package:front_end/Component/Custom_Dropdown.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(SearchScreenController());
  TempFileClass _tempFileClass = new TempFileClass();

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
