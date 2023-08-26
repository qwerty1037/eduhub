import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;

import 'package:get/get.dart';

///전역변수처럼 사용되는 변수들을 모아두는 컨트롤러
class TotalController extends GetxController {
  bool isLoginSuccess = false;

  Color? mainColor;
  AccentColor activeColor = Colors.blue;

  RxBool isDark = false.obs;

  ///isLoginSuccess 값을 뒤집는 함수
  void reverseLoginState() {
    isLoginSuccess = !isLoginSuccess;
    update();
  }

  m.ColorScheme customColorScheme = m.ColorScheme.fromSeed(seedColor: Colors.red);

  final ResourceDictionary customRes = const ResourceDictionary.raw(
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
    subtleFillColorSecondary: Color(0xffe81123), //Colors.red.normal
    subtleFillColorTertiary: Color(0x06000000),
    subtleFillColorDisabled: Color(0x00ffffff),
    controlAltFillColorTransparent: Color(0x00ffffff),
    controlAltFillColorSecondary: Color(0xffffeb3b), //Colors.yellow.normal
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
    solidBackgroundFillColorTertiary: Color(0xFFf9f9f9),
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
}
