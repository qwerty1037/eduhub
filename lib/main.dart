import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:front_end/Component/Applifecycle_Observer.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Tag_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
import 'package:front_end/Screen/Home_Tabview.dart';
import 'package:front_end/Screen/Login_Screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appLifecycleObserver = AppLifecycleObserver();
  WidgetsBinding.instance.addObserver(appLifecycleObserver);
  await windowManager.ensureInitialized();
  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.aero,
    color: const Color.fromARGB(50, 0, 0, 0),
  );
  WindowOptions windowOptions = const WindowOptions(
      // fullScreen: true,

      minimumSize: Size(1000, 250),
      titleBarStyle: TitleBarStyle.normal);
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TotalController(), permanent: true);
    Get.put(FolderController());

    return GetBuilder<TotalController>(
      builder: (controller) {
        if (controller.isLoginSuccess) {
          //서버 없을때 주석 풀기 + TotalController의 isLoginSuccess true로======================================
          // FolderController folderController = Get.find<FolderController>();
          // folderController.makeExampleData();
          //====================================================================================================
          Get.put(TagController());
          return FluentApp(
            themeMode: controller.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: FluentThemeData(
              typography: const Typography.raw(body: TextStyle(color: Color(0xFF141212), fontWeight: FontWeight.bold)),
              scaffoldBackgroundColor: Colors.grey[10],
              accentColor: Colors.orange,
              brightness: Brightness.light,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            darkTheme: FluentThemeData(
                typography: const Typography.raw(body: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                fontFamily: GoogleFonts.poppins().fontFamily,
                scaffoldBackgroundColor: Colors.grey[160],
                accentColor: Colors.orange,
                brightness: Brightness.dark),
            debugShowCheckedModeBanner: false,
            home: const HomeTabView(),
          );
        } else {
          return material.MaterialApp(
            theme: material.ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              useMaterial3: true,
              colorScheme: material.ColorScheme.fromSeed(seedColor: material.Colors.red),
            ),
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        }
      },
    );
  }

  /*
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
  */
}
