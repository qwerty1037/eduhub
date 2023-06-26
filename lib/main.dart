import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/tabview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      home: TabViewScreen(),
    );
  }
}


//temp