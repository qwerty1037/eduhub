import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  TextEditingController searchBarController = TextEditingController();

  static RxInt difficulty = 999.obs;
  static RxString content = "".obs;

  List<MenuFlyoutItemBase> difficultyList = [
    MenuFlyoutItem(
      text: const Text("0"),
      onPressed: () {
        difficulty.value = 0;
      },
    ),
    MenuFlyoutItem(
      text: const Text("1"),
      onPressed: () {
        difficulty.value = 1;
      },
    ),
    MenuFlyoutItem(
      text: const Text("2"),
      onPressed: () {
        difficulty.value = 2;
      },
    ),
    MenuFlyoutItem(
      text: const Text("3"),
      onPressed: () {
        difficulty.value = 3;
      },
    ),
    MenuFlyoutItem(
      text: const Text("4"),
      onPressed: () {
        difficulty.value = 4;
      },
    ),
    MenuFlyoutItem(
      text: const Text("5"),
      onPressed: () {
        difficulty.value = 5;
      },
    ),
  ];
  List<MenuFlyoutItemBase> contentList = [
    MenuFlyoutItem(
      text: const Text("yes"),
      onPressed: () {
        content.value = "yes";
      },
    ),
  ];

  int getDifficulty() {
    return difficulty.value;
  }

  String getContent() {
    return content.value;
  }
}
