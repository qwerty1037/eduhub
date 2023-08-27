import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:front_end/Component/Applifecycle_Observer.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
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
  WindowOptions windowOptions = const WindowOptions(title: "바선생", minimumSize: Size(1000, 250), titleBarStyle: TitleBarStyle.normal);
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  Get.put(TotalController(), permanent: true);
  Get.put(FolderController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TotalController>(
      builder: (controller) {
        if (controller.isLoginSuccess) {
          //로직상 한번만 호출되서 괜찮음

          Get.put(TagController());
          Get.put(TabController());
          return FluentApp(
            themeMode: controller.isDark.value ? ThemeMode.dark : ThemeMode.light,
            theme: FluentThemeData(
              brightness: Brightness.light,
              typography: const Typography.raw(body: TextStyle(color: Color(0xFF141212), fontWeight: FontWeight.bold)),
              fontFamily: GoogleFonts.poppins().fontFamily,

              accentColor: Colors.orange,
              activeColor: Colors.blue, //?
              //inactiveColor: Colors.green, //탭 버튼에서 +위에 마우스를 올렸을 때(Hovering) 나오는 십자가 색깔
              //inactiveBackgroundColor: Colors.green, //메뉴창(우클릭했을 때 나오는) 테두리 색깔
              scaffoldBackgroundColor: Colors.grey[30],
              //acrylicBackgroundColor: Colors.red, //?
              micaBackgroundColor: Colors.black,
              //shadowColor: Colors.purple, //그림자 색깔
              //menuColor: Colors.red, //우클릭했을 때 나오는 메뉴 색깔을 결정
              cardColor: Colors.grey[30], //tag의 배경색이 이것으로 결정, fluent theme위에 있는 material.scaffold의 기본 색깔
              selectionColor: Colors.magenta, //?

              /// buttonTheme: 버튼의 테마 조절, tabView의 탭에서 x가 버튼이고 그 이외의 색을 조절하려 했었는데 이것은 buttonTheme이 아님
              ///
              /// 어지간하면 widget theme은 안건드리는 것이 좋아보임
              /*
              buttonTheme: ButtonThemeData.all(ButtonStyle().copyWith(
                foregroundColor: ButtonState.resolveWith((states) {
                  final res = FluentThemeData.light().resources;
                  if (states.isPressing) {
                    return res.textFillColorTertiary;
                  } else if (states.isHovering) {
                    return res.textFillColorSecondary;
                  } else if (states.isDisabled) {
                    return res.textFillColorDisabled;
                  }
                  return res.textFillColorPrimary;
                }),
                backgroundColor: ButtonState.resolveWith((states) {
                  final res = FluentThemeData.light().resources;
                  if (states.isPressing) {
                    return res.controlFillColorTertiary;
                  } else if (states.isHovering) {
                    return res.controlFillColorSecondary;
                  } else if (states.isDisabled) {
                    return res.controlFillColorDisabled;
                  }
                  //return Colors.red;
                  //return res.subtleFillColorTransparent;
                  //return res.controlFillColorDefault;
                }),
              )),
              */
              //scrollbarTheme: ScrollbarThemeData.standard(FluentThemeData.light()),

              //chipTheme: ChipThemeData.standard(FluentThemeData.light()), //

              resources: Get.find<TotalController>().customResourceLight,
            ),
            darkTheme: FluentThemeData(
              brightness: Brightness.dark,
              typography: const Typography.raw(body: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              fontFamily: GoogleFonts.poppins().fontFamily,

              accentColor: Colors.orange,
              activeColor: Colors.blue, //?
              //inactiveColor: Colors.green, //탭 버튼에서 +위에 마우스를 올렸을 때(Hovering) 나오는 십자가 색깔
              //inactiveBackgroundColor: Colors.green, //메뉴창(우클릭했을 때 나오는) 테두리 색깔
              scaffoldBackgroundColor: Colors.grey[160],
              //acrylicBackgroundColor: Colors.red, //?
              micaBackgroundColor: Colors.black,
              //shadowColor: Colors.purple, //그림자 색깔
              //menuColor: Colors.red, //우클릭했을 때 나오는 메뉴 색깔을 결정
              cardColor: Colors.grey[30], //tag의 배경색이 이것으로 결정, fluent theme위에 있는 material.scaffold의 기본 색깔
              selectionColor: Colors.magenta, //?

              resources: Get.find<TotalController>().customResourceDark,
            ),
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
