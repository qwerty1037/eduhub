import 'package:fluent_ui/fluent_ui.dart';

class NewTabScreen extends StatefulWidget {
  const NewTabScreen({super.key});

  @override
  State<NewTabScreen> createState() => _NewTabScreenState();
}

class _NewTabScreenState extends State<NewTabScreen> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text(
          'new tab app bar',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
