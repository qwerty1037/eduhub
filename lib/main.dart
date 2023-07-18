import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:front_end/Component/Applifecycle_Observer.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:front_end/Controller/Total_Controller.dart';
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
    Get.lazyPut(() => TotalController());
    Get.lazyPut(() => FolderController());
    return GetBuilder<TotalController>(
      builder: (controller) {
        if (controller.isLoginSuccess) {
          //서버 없을때 주석 풀기 + TotalController의 isLoginSuccess true로======================================
          // FolderController folderController = Get.find<FolderController>();
          // folderController.makeExampleData();
          //====================================================================================================
          return const FluentApp(
            debugShowCheckedModeBanner: false,
            home: HomeTabView(),
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
