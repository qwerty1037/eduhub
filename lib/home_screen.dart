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
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text('프로필자리'),
              ),
              Expanded(
                flex: 9,
                child: Text('검색창자리'),
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
        Expanded(
            child: Row(
          children: const [],
        )),
      ],
    );
  }
}
