import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  final storage = const FlutterSecureStorage();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    ///life cycle 관찰하다가 앱이 일시 중지될 때(종료)시 쿠키 데이터 삭제
    if (state == AppLifecycleState.paused) {
      await storage.delete(key: 'uid');
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');
    }
  }
}
