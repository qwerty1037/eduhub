import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: DEFAULT_DARK_COLOR,
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: const Row(
            children: [
              Expanded(
                flex: 2,
                child: Icon(
                  FluentIcons.questionnaire,
                  color: DEFAULT_LIGHT_COLOR,
                ),
              ),
              Expanded(
                flex: 9,
                child: Icon(
                  FluentIcons.questionnaire,
                  color: DEFAULT_LIGHT_COLOR,
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  FluentIcons.questionnaire,
                  color: DEFAULT_LIGHT_COLOR,
                ),
              ),
            ],
          ),
        ),
        const Expanded(
            child: Row(
          children: [],
        )),
      ],
    );
  }
}
