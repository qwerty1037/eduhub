import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:front_end/Component/Event_Listener.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Group_TreeView_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart';
import 'package:front_end/Controller/Tag_Controller.dart';
import 'package:front_end/Controller/Desktop_Controller.dart';
import 'package:front_end/Screen/Home_Tabview.dart';
import 'package:front_end/Screen/Login_Screen.dart';
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
  WindowOptions windowOptions = const WindowOptions(
      title: "바선생",
      minimumSize: Size(1000, 250),
      titleBarStyle: TitleBarStyle.normal);
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  await initializeDateFormatting(); // 기억안남. 아마 달력 부분 일듯
  Get.put(DesktopController(), permanent: true);
  Get.put(FolderController());
  Get.put(GroupTreeViewController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with WindowListener {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DesktopController>(
      builder: (controller) {
        if (controller.isLogin) {
          //로직상 한번만 호출되서 괜찮음

          Get.put(TagController());
          Get.put(TabController());
          return FluentApp(
            themeMode:
                controller.isDark.value ? ThemeMode.dark : ThemeMode.light,
            theme: FluentThemeData(
              brightness: Brightness.light,
              typography: const Typography.raw(
                  body: TextStyle(
                      color: Color(0xFF141212), fontWeight: FontWeight.bold)),
              accentColor: Colors.blue,
              activeColor: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[30],
              micaBackgroundColor: Colors.black,
              cardColor: Colors.grey[
                  30], //tag의 배경색이 이것으로 결정, fluent theme위에 있는 material.scaffold의 기본 색깔
              scrollbarTheme:
                  ScrollbarThemeData.standard(FluentThemeData.light()),
              fontFamily: GoogleFonts.poppins().fontFamily,
              resources: Get.find<DesktopController>().customResourceLight,
            ),
            darkTheme: FluentThemeData(
                typography: const Typography.raw(
                    body: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                fontFamily: GoogleFonts.poppins().fontFamily,
                scaffoldBackgroundColor: Colors.grey[160],
                selectionColor: Colors.green,
                accentColor: Colors.orange,
                brightness: Brightness.dark),
            debugShowCheckedModeBanner: false,
            home: const eventListener(child: HomeTabView()),
          );
        } else {
          return material.MaterialApp(
            theme: material.ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              useMaterial3: true,
              colorScheme:
                  material.ColorScheme.fromSeed(seedColor: material.Colors.red),
            ),
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        }
      },
    );
  }
}
