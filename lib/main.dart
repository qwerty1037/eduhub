import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/Controller/total.controller.dart';
import 'package:front_end/home_tabview.dart';
import 'package:front_end/login_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FluentApp(home: LoginScreen());
    //   Get.put(TotalController());
    //   return GetX<TotalController>(
    //     builder: (controller) {
    //       return FluentApp(
    //         home: const HomeTabView(),
    //         themeMode:
    //             controller.isdark.isTrue ? ThemeMode.system : ThemeMode.light,
    //         theme: FluentThemeData(
    //             scaffoldBackgroundColor: DEFAULT_LIGHT_COLOR,
    //             iconTheme: const IconThemeData(size: 24)),
    //         darkTheme: FluentThemeData(
    //             scaffoldBackgroundColor: DEFAULT_DARK_COLOR,
    //             iconTheme: const IconThemeData(size: 24)),
    //       );
    //     },
    //   );
  }
}
