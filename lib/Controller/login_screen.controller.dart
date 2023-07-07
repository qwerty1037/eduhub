import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Controller/total.controller.dart';
import 'package:get/get.dart';

class loginScreenController extends GetxController {
  String? getCookieValue(String cookieHeader, String cookieName) {
    if (cookieHeader.isNotEmpty) {
      RegExp regex = RegExp('$cookieName=([^;]+)');
      Match? match = regex.firstMatch(cookieHeader);
      if (match != null) {
        return match.group(1)!;
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

  void loginSuccess() {
    TotalController totalController = Get.find<TotalController>();
    totalController.cookieExist.value = true;
  }
}
