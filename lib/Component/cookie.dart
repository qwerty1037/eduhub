import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//쿠키 관련 함수 모두 이곳으로 옮길 것

///저장된 쿠키를 읽고 Map<String,String>형식으로 담아 header로 쓸 수 있게 반환하는 메소드
Future<Map<String, String>> sendCookieToBackend() async {
  const storage = FlutterSecureStorage();
  final uid = await storage.read(key: 'uid');
  final accessToken = await storage.read(key: 'access_token');
  final refreshToken = await storage.read(key: 'refresh_token');

  Map<String, String> header = {
    "cookie": "access_token=$accessToken; refresh_token=$refreshToken; uid=$uid",
  };
  return header;
}

///cookieData에서 cookieName에 해당하는 값들을 추출하는 함수. uid와 access, refresh 토큰을 추출하는데 사용
String? extractCookieValue(String cookieData, String cookieName) {
  if (cookieData.isNotEmpty) {
    List<String> cookies = cookieData.split(RegExp(r';|,'));
    for (String cookie in cookies) {
      cookie = cookie.trim();
      if (cookie.startsWith('$cookieName=')) {
        return cookie.substring(cookieName.length + 1);
      }
    }
  }
  return null;
}

///안전한 곳에 쿠키 데이터 저장하는 함수
Future<void> saveCookieToSecureStorage(String uid, String accessToken, String refreshToken) async {
  const storage = FlutterSecureStorage();

  await storage.write(key: 'uid', value: uid);
  await storage.write(key: 'access_token', value: accessToken);
  await storage.write(key: 'refresh_token', value: refreshToken);
}
