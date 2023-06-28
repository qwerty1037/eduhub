import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';
import 'package:front_end/main_navigation_view.dart';

import 'package:front_end/tabview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      home: const MainNavigationView(),
      themeMode: ThemeMode.dark,
      theme: FluentThemeData(
          scaffoldBackgroundColor: DEFAULT_LIGHT_COLOR,
          accentColor: Colors.blue,
          iconTheme: const IconThemeData(size: 24)),
      darkTheme: FluentThemeData(
          scaffoldBackgroundColor: DEFAULT_DARK_COLOR,
          accentColor: Colors.blue,
          iconTheme: const IconThemeData(size: 24)),
    );
  }
}


//temp