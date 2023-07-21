import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';

///홈스크린 관련 로직 처리하는 컨트롤러
class HomeScreenController extends GetxController {
  bool isFolderEmpty = false;

  HomeScreenController() {
    if (Get.find<FolderController>().firstFolders.isEmpty) {
      isFolderEmpty = true;
    }
  }

  ///로그아웃 함수로 현재는 쿠키를 없애고 total컨트롤러를 제외한 모든 컨트롤러 인스턴스를 제거
  void logout() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: "uid");
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
    final TotalController previousTotalController = Get.find<TotalController>();
    previousTotalController.isLoginSuccess = false;
    previousTotalController.update();
    Get.deleteAll();
  }
}
