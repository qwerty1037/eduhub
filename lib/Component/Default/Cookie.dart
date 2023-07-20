import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///저장된 쿠키를 읽고 Map<String,String>형식으로 담아 header로 쓸 수 있게 반환하는 메소드
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
