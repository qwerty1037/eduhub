import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:front_end/Controller/SearchController.dart';
import '../Component/DefaultTextFIeld.dart';
import 'package:front_end/Component/Custom_Dropdown.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(SearchScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DefaultTextField(
            labelText: null,
            hintText: '검색하세요',
            controller: controller.searchBarController,
            onChanged: (value) {},
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      CustomDropdownPage(),
                    ],
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
