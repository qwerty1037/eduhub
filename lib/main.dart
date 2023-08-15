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
          return const FluentApp(
            themeMode: ThemeMode.light,
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
