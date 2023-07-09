import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Component/Folder_List.dart';

class ProjectTabScreen extends StatelessWidget {
  List<Folder> folderList = makeFolderListInfo(example);

  ProjectTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
                height: double.infinity,
                child: Expanded(child: FolderList(folders: folderList))),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.teal,
            ),
          )
        ],
      ),
    );
  }
}
