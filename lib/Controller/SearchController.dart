import 'package:flutter/material.dart';
import 'package:get/get.dart';

const List<int> list = <int>[0, 1, 2, 3, 4, 5];

class SearchScreenController extends GetxController {
  TextEditingController searchBarController = TextEditingController();
  RxInt difficulty = 0.obs;
}
