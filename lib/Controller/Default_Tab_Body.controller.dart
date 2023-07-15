import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class DefaultTabBodyController extends GetxController {
  Rx<Widget> workingSpaceWidget = Container(
    color: Colors.white,
    child: const Center(child: Text("폴더 또는 기능을 선택해주세요")),
  ).obs;
}
