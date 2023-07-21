import 'package:get/get.dart';

///전역변수처럼 사용되는 변수들을 모아두는 컨트롤러
class TotalController extends GetxController {
  bool isLoginSuccess = false;

  ///isLoginSuccess 값을 뒤집는 함수
  void reverseLoginState() {
    isLoginSuccess = !isLoginSuccess;
    update();
  }
}
