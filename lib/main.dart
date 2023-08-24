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
              typography: const Typography.raw(
                  body: TextStyle(
                      color: Color(0xFF141212), fontWeight: FontWeight.bold)),
              scaffoldBackgroundColor: controller.mainColor,
              accentColor: controller.activeColor,
              brightness: Brightness.light,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            darkTheme: FluentThemeData(
                typography: const Typography.raw(
                    body: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                fontFamily: GoogleFonts.poppins().fontFamily,
                scaffoldBackgroundColor: controller.mainColor,
                accentColor: controller.activeColor,
                brightness: Brightness.dark),
            debugShowCheckedModeBanner: false,
            home: const HomeTabView(),
          );
        } else {
          return material.MaterialApp(
            theme: material.ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        }
      },
    );
  }
}
