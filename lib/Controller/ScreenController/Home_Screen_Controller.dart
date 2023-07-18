import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  bool isFolderEmpty = false;

  HomeScreenController() {
    if (Get.find<FolderController>().firstFolders.isEmpty) {
      isFolderEmpty = true;
    }
  }

  void logout() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: "uid");
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
    Get.deleteAll();
    // final TotalController totalController =
    //     Get.find<TotalController>();
    // totalController.isLoginSuccess = false;
  }
}
