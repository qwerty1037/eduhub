import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:get/get.dart';

class loginScreenController extends GetxController {
  String? getCookieValue(String cookieHeader, String cookieName) {
    if (cookieHeader.isNotEmpty) {
      List<String> cookies = cookieHeader.split(RegExp(r';|,'));
      for (String cookie in cookies) {
        cookie = cookie.trim();
        if (cookie.startsWith('$cookieName=')) {
          return cookie.substring(cookieName.length + 1);
        }
      }
    }
    return null;
  }

  Future<void> saveCookieToSecureStorage(
      String uid, String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: 'uid', value: uid);
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  void loginSuccess() async {
    TotalController totalController = Get.find<TotalController>();
    FolderController folderController = Get.find<FolderController>();
    await folderController.receiveData();
    totalController.reverseLoginState();
    totalController.update();
    Get.delete<loginScreenController>();
  }
}
