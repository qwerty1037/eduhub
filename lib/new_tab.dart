import 'package:fluent_ui/fluent_ui.dart';

class NewTabScreen extends StatefulWidget {
  const NewTabScreen({super.key});

  @override
  State<NewTabScreen> createState() => _NewTabScreenState();
}

class _NewTabScreenState extends State<NewTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: const Column(
        children: [
          Center(
            child: Text("New tab test"),
          ),
        ],
      ),
    );
  }
}
