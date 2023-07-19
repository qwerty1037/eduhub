import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/HttpConfig.dart';

Future<Map<String, String>> sendCookieToBackend() async {
  const storage = FlutterSecureStorage();
  final uid = await storage.read(key: 'uid');
  final accessToken = await storage.read(key: 'access_token');
  final refreshToken = await storage.read(key: 'refresh_token');

  Map<String, String> header = {
    "cookie":
        "access_token=$accessToken; refresh_token=$refreshToken; uid=$uid",
  };
  return header;
}
