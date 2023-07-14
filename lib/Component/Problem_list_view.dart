import 'package:fluent_ui/fluent_ui.dart';

class ProblemList extends StatelessWidget {
  ProblemList(
      {super.key,
      required this.id,
      required this.folderName,
      required this.childFolder,
      required this.problems});
  String folderName;
  int id;
  List<TreeViewItem> childFolder;
  List<dynamic> problems;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              SizedBox(
                height: 40,
                child: Text(
                  folderName,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
