import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:front_end/Component/window_event_listener.dart';
import 'package:front_end/Controller/group_treeview_controller.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:front_end/Controller/tag_controller.dart';

import 'package:front_end/Controller/user_data_controller.dart';
import 'package:front_end/Controller/user_desktop_controller.dart';
import 'package:front_end/Screen/home_tabview.dart';
import 'package:front_end/Screen/login_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  await initializeDateFormatting(); // 기억안남. 아마 달력 부분 일듯
  Get.put(UserDesktopController(), permanent: true);
  Get.put(UserDataController()); // 로그인 후 사용됌, 로그아웃시 소멸 및 초기화
  Get.put(GroupTreeViewController()); // 연동전 UserDataController로 이동 필요(기능 미완성이라 안 옮겨놓음)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with WindowListener {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDesktopController>(
      builder: (controller) {
        if (controller.isLogin) {
          //로그인 할때만 build
          Get.put(TagController());
          Get.put(FluentTabController());
          return FluentApp(
            themeMode: controller.isDark.value ? ThemeMode.dark : ThemeMode.light,
            theme: FluentThemeData(
              brightness: Brightness.light,
              typography: const Typography.raw(body: TextStyle(color: Color(0xFF141212), fontWeight: FontWeight.bold)),
              accentColor: Colors.blue,
              activeColor: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[30],
              micaBackgroundColor: Colors.black,
              cardColor: Colors.grey[30], //tag의 배경색이 이것으로 결정, fluent theme위에 있는 material.scaffold의 기본 색깔
              scrollbarTheme: ScrollbarThemeData.standard(FluentThemeData.light()),
              fontFamily: GoogleFonts.poppins().fontFamily,
              resources: Get.find<UserDesktopController>().customResourceLight,
            ),
            darkTheme: FluentThemeData(
                typography: const Typography.raw(body: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                fontFamily: GoogleFonts.poppins().fontFamily,
                scaffoldBackgroundColor: Colors.grey[160],
                selectionColor: Colors.green,
                accentColor: Colors.orange,
                brightness: Brightness.dark),
            debugShowCheckedModeBanner: false,
            home: const WindowEventListener(child: HomeTabView()),
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
}
