import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Component/applifecycle_observer.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/total.controller.dart';
import 'package:front_end/screen/home_tabview.dart';
import 'package:front_end/screen/login_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appLifecycleObserver = AppLifecycleObserver();
  WidgetsBinding.instance.addObserver(appLifecycleObserver);
  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.aero,
    color: const Color.fromARGB(50, 0, 0, 0),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TotalController());
    Get.put(FolderController());
    return GetX<TotalController>(
      builder: (controller) {
        if (controller.cookieExist.isTrue) {
          FolderController folderController = Get.find<FolderController>();
          folderController.makeExampleData();
          return FluentApp(
            debugShowCheckedModeBanner: false,
            home: const HomeTabView(),
            themeMode:
                controller.isdark.isTrue ? ThemeMode.system : ThemeMode.light,
            theme: FluentThemeData(
                scaffoldBackgroundColor: DEFAULT_LIGHT_COLOR,
                iconTheme: const IconThemeData(size: 24)),
            darkTheme: FluentThemeData(
                scaffoldBackgroundColor: DEFAULT_DARK_COLOR,
                iconTheme: const IconThemeData(size: 24)),
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
