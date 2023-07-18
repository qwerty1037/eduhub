import 'package:get/get.dart';

class TotalController extends GetxController {
  bool isLoginSuccess = false;

  void reverseLoginState() {
    isLoginSuccess = !isLoginSuccess;
    update();
  }
}
