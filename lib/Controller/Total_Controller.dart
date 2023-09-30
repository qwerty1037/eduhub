import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/Component/Default/Config.dart';
import 'package:front_end/Component/Default/HttpConfig.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

///전역변수처럼 사용되는 변수들을 모아두는 컨트롤러
class TotalController extends GetxController {
  bool isLoginSuccess = false;

  Color? mainColor;
  AccentColor activeColor = Colors.blue;

  RxBool isDark = false.obs;

  late Timer _timer;

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

  Future<void> saveCookieToSecureStorage(String uid, String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: 'uid', value: uid);
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  @override
  void onInit() async {
    super.onInit();
    _timer = Timer.periodic(const Duration(minutes: 29), (timer) async {
      if (isLoginSuccess) {
        final url = Uri.parse('https://$HOST/api/auth/refresh');
        final response = await http.post(
          url,
          headers: await defaultHeader(httpContentType.json),
        );

        if (isHttpRequestSuccess(response)) {
          String? cookieList = response.headers["set-cookie"];

          String? uid = getCookieValue(cookieList!, "uid");
          String? accessToken = getCookieValue(cookieList, "access_token");
          String? refreshToken = getCookieValue(cookieList, "refresh_token");
          if (uid == null || accessToken == null || refreshToken == null) {
            debugPrint("refresh 토큰 받기 도중 변환 실패");
          } else {
            await saveCookieToSecureStorage(uid, accessToken, refreshToken);
          }
        } else if (isHttpRequestFailure(response)) {
          debugPrint("refresh 토큰 받기 오류 발생(서버연결x)");
        }
      }
    });
  }

  ///isLoginSuccess 값을 뒤집는 함수
  void reverseLoginState() {
    isLoginSuccess = !isLoginSuccess;
    update();
  }

  m.ColorScheme customColorScheme = m.ColorScheme.fromSeed(seedColor: Colors.red);

  final ResourceDictionary customResourceLight = const ResourceDictionary.raw(
    textFillColorPrimary: Color(0xe4000000),
    textFillColorSecondary: Color(0x9e000000),
    textFillColorTertiary: Color(0x72000000),
    textFillColorDisabled: Color(0x5c000000),
    textFillColorInverse: Color(0xFFffffff),
    accentTextFillColorDisabled: Color(0x5c000000),
    textOnAccentFillColorSelectedText: Color(0xFFffffff),
    textOnAccentFillColorPrimary: Color(0xFFffffff),
    textOnAccentFillColorSecondary: Color(0xb3ffffff),
    textOnAccentFillColorDisabled: Color(0xFFffffff),
    controlFillColorDefault: Color(0xb3ffffff),
    controlFillColorSecondary: Color(0x80f9f9f9),
    controlFillColorTertiary: Color(0x4df9f9f9),
    controlFillColorDisabled: Color(0x4df9f9f9),
    controlFillColorTransparent: Color(0x00ffffff),
    controlFillColorInputActive: Color(0xFFffffff),
    controlStrongFillColorDefault: Color(0x72000000),
    controlStrongFillColorDisabled: Color(0x51000000),
    controlSolidFillColorDefault: Color(0xFFffffff),
    subtleFillColorTransparent: Color(0x00ffffff),
    subtleFillColorSecondary: Color(0x09000000), //Color(0xffe81123), //Colors.red.normal
    subtleFillColorTertiary: Color(0x06000000),
    subtleFillColorDisabled: Color(0x00ffffff),
    controlAltFillColorTransparent: Color(0x00ffffff),
    controlAltFillColorSecondary: Color(0x06000000), //Color(0xffffeb3b), //Colors.yellow.normal
    controlAltFillColorTertiary: Color(0x0f000000),
    controlAltFillColorQuarternary: Color(0x18000000),
    controlAltFillColorDisabled: Color(0x00ffffff),
    controlOnImageFillColorDefault: Color(0xc9ffffff),
    controlOnImageFillColorSecondary: Color(0xFFf3f3f3),
    controlOnImageFillColorTertiary: Color(0xFFebebeb),
    controlOnImageFillColorDisabled: Color(0x00ffffff),
    accentFillColorDisabled: Color(0x37000000),
    controlStrokeColorDefault: Color(0x0f000000),
    controlStrokeColorSecondary: Color(0x29000000),
    controlStrokeColorOnAccentDefault: Color(0x14ffffff),
    controlStrokeColorOnAccentSecondary: Color(0x66000000),
    controlStrokeColorOnAccentTertiary: Color(0x37000000),
    controlStrokeColorOnAccentDisabled: Color(0x0f000000),
    controlStrokeColorForStrongFillWhenOnImage: Color(0x59ffffff),
    cardStrokeColorDefault: Color(0x0f000000),
    cardStrokeColorDefaultSolid: Color(0xFFebebeb),
    controlStrongStrokeColorDefault: Color(0x72000000),
    controlStrongStrokeColorDisabled: Color(0x37000000),
    surfaceStrokeColorDefault: Color(0x66757575),
    surfaceStrokeColorFlyout: Color(0x0f000000),
    surfaceStrokeColorInverse: Color(0x15ffffff),
    dividerStrokeColorDefault: Color(0x0f000000),
    focusStrokeColorOuter: Color(0xe4000000),
    focusStrokeColorInner: Color(0xb3ffffff),
    cardBackgroundFillColorDefault: Color(0xb3ffffff),
    cardBackgroundFillColorSecondary: Color(0x80f6f6f6),
    smokeFillColorDefault: Color(0x4d000000),
    layerFillColorDefault: Color(0x80ffffff),
    layerFillColorAlt: Color(0xFFffffff),
    layerOnAcrylicFillColorDefault: Color(0x40ffffff),
    layerOnAccentAcrylicFillColorDefault: Color(0x40ffffff),
    layerOnMicaBaseAltFillColorDefault: Color(0xb3ffffff),
    layerOnMicaBaseAltFillColorSecondary: Color(0x0a000000),
    layerOnMicaBaseAltFillColorTertiary: Color(0xFFf9f9f9),
    layerOnMicaBaseAltFillColorTransparent: Color(0x00000000),
    solidBackgroundFillColorBase: Color(0xFFf3f3f3),
    solidBackgroundFillColorSecondary: Color(0xFFeeeeee),
    solidBackgroundFillColorTertiary: Color(0xFFFAF9F8), //Colors.grey[10], // Default: Color(0xFFf9f9f9),
    solidBackgroundFillColorQuarternary: Color(0xFFffffff),
    solidBackgroundFillColorTransparent: Color(0x00f3f3f3),
    solidBackgroundFillColorBaseAlt: Color(0xFFdadada),
    systemFillColorSuccess: Color(0xFF0f7b0f),
    systemFillColorCaution: Color(0xFF9d5d00),
    systemFillColorCritical: Color(0xFFc42b1c),
    systemFillColorNeutral: Color(0x72000000),
    systemFillColorSolidNeutral: Color(0xFF8a8a8a),
    systemFillColorAttentionBackground: Color(0x80f6f6f6),
    systemFillColorSuccessBackground: Color(0xFFdff6dd),
    systemFillColorCautionBackground: Color(0xFFfff4ce),
    systemFillColorCriticalBackground: Color(0xFFfde7e9),
    systemFillColorNeutralBackground: Color(0x06000000),
    systemFillColorSolidAttentionBackground: Color(0xFFf7f7f7),
    systemFillColorSolidNeutralBackground: Color(0xFFf3f3f3),
  );

  final ResourceDictionary customResourceDark = const ResourceDictionary.raw(
    textFillColorPrimary: Color(0xFFffffff),
    textFillColorSecondary: Color(0xc5ffffff),
    textFillColorTertiary: Color(0x87ffffff),
    textFillColorDisabled: Color(0x5dffffff),
    textFillColorInverse: Color(0xe4000000),
    accentTextFillColorDisabled: Color(0x5dffffff),
    textOnAccentFillColorSelectedText: Color(0xFFffffff),
    textOnAccentFillColorPrimary: Color(0xFF000000),
    textOnAccentFillColorSecondary: Color(0x80000000),
    textOnAccentFillColorDisabled: Color(0x87ffffff),
    controlFillColorDefault: Color(0x0fffffff),
    controlFillColorSecondary: Color(0x15ffffff),
    controlFillColorTertiary: Color(0x08ffffff),
    controlFillColorDisabled: Color(0x0bffffff),
    controlFillColorTransparent: Color(0x00ffffff),
    controlFillColorInputActive: Color(0xb31e1e1e),
    controlStrongFillColorDefault: Color(0x8bffffff),
    controlStrongFillColorDisabled: Color(0x3fffffff),
    controlSolidFillColorDefault: Color(0xFF454545),
    subtleFillColorTransparent: Color(0x00ffffff),
    subtleFillColorSecondary: Color(0x0fffffff),
    subtleFillColorTertiary: Color(0x0affffff),
    subtleFillColorDisabled: Color(0x00ffffff),
    controlAltFillColorTransparent: Color(0x00ffffff),
    controlAltFillColorSecondary: Color(0x19000000),
    controlAltFillColorTertiary: Color(0x0bffffff),
    controlAltFillColorQuarternary: Color(0x12ffffff),
    controlAltFillColorDisabled: Color(0x00ffffff),
    controlOnImageFillColorDefault: Color(0xb31c1c1c),
    controlOnImageFillColorSecondary: Color(0xFF1a1a1a),
    controlOnImageFillColorTertiary: Color(0xFF131313),
    controlOnImageFillColorDisabled: Color(0xFF1e1e1e),
    accentFillColorDisabled: Color(0x28ffffff),
    controlStrokeColorDefault: Color(0x12ffffff),
    controlStrokeColorSecondary: Color(0x18ffffff),
    controlStrokeColorOnAccentDefault: Color(0x14ffffff),
    controlStrokeColorOnAccentSecondary: Color(0x23000000),
    controlStrokeColorOnAccentTertiary: Color(0x37000000),
    controlStrokeColorOnAccentDisabled: Color(0x33000000),
    controlStrokeColorForStrongFillWhenOnImage: Color(0x6b000000),
    cardStrokeColorDefault: Color(0x19000000),
    cardStrokeColorDefaultSolid: Color(0xFF1c1c1c),
    controlStrongStrokeColorDefault: Color(0x8bffffff),
    controlStrongStrokeColorDisabled: Color(0x28ffffff),
    surfaceStrokeColorDefault: Color(0x66757575),
    surfaceStrokeColorFlyout: Color(0x33000000),
    surfaceStrokeColorInverse: Color(0x0f000000),
    dividerStrokeColorDefault: Color(0x15ffffff),
    focusStrokeColorOuter: Color(0xFFffffff),
    focusStrokeColorInner: Color(0xb3000000),
    cardBackgroundFillColorDefault: Color(0x0dffffff),
    cardBackgroundFillColorSecondary: Color(0x08ffffff),
    smokeFillColorDefault: Color(0x4d000000),
    layerFillColorDefault: Color(0x4c3a3a3a),
    layerFillColorAlt: Color(0x0dffffff),
    layerOnAcrylicFillColorDefault: Color(0x09ffffff),
    layerOnAccentAcrylicFillColorDefault: Color(0x09ffffff),
    layerOnMicaBaseAltFillColorDefault: Color(0x733a3a3a),
    layerOnMicaBaseAltFillColorSecondary: Color(0x0fffffff),
    layerOnMicaBaseAltFillColorTertiary: Color(0xFF2c2c2c),
    layerOnMicaBaseAltFillColorTransparent: Color(0x00ffffff),
    solidBackgroundFillColorBase: Color(0xFF202020),
    solidBackgroundFillColorSecondary: Color(0xFF1c1c1c),
    solidBackgroundFillColorTertiary: Color(0xFF282828),
    solidBackgroundFillColorQuarternary: Color(0xFF2c2c2c),
    solidBackgroundFillColorTransparent: Color(0x00202020),
    solidBackgroundFillColorBaseAlt: Color(0xFF0a0a0a),
    systemFillColorSuccess: Color(0xFF6ccb5f),
    systemFillColorCaution: Color(0xFFfce100),
    systemFillColorCritical: Color(0xFFff99a4),
    systemFillColorNeutral: Color(0x8bffffff),
    systemFillColorSolidNeutral: Color(0xFF9d9d9d),
    systemFillColorAttentionBackground: Color(0x08ffffff),
    systemFillColorSuccessBackground: Color(0xFF393d1b),
    systemFillColorCautionBackground: Color(0xFF433519),
    systemFillColorCriticalBackground: Color(0xFF442726),
    systemFillColorNeutralBackground: Color(0x08ffffff),
    systemFillColorSolidAttentionBackground: Color(0xFF2e2e2e),
    systemFillColorSolidNeutralBackground: Color(0xFF2e2e2e),
  );
}
