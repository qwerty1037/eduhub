import 'package:fluent_ui/fluent_ui.dart';

class Folder {
  String name;
  int id;
  int? parentId;
  List<Folder> children = [];
  bool isExpanded;
  Folder(
      {required this.name,
      required this.id,
      required this.parentId,
      this.isExpanded = false});
}

//정보를 {아이디, name, 부모 아이디} 형태로 받은 list가 존재한다고 가정. 다음은 예시 데이터
List<dynamic> example = [
  {
    "id": 1,
    "name": "하이탑",
    "parent_id": null,
  },
  {
    "id": 2,
    "name": "고1",
    "parent_id": 1,
  },
  {
    "id": 3,
    "name": "고2",
    "parent_id": 1,
  },
  {
    "id": 4,
    "name": "중간대비",
    "parent_id": 3,
  },
  {
    "id": 5,
    "name": "기말대비",
    "parent_id": 3,
  },
  {
    "id": 6,
    "name": "고3",
    "parent_id": 1,
  },
];

///백엔드 데이터를 받고 폴더 정보를 담은 전체 폴더 리스트를 반환하는 함수(프로젝트 바로 아래 폴더만 isexpanded = true)
List<Folder> makeFolderListInfo(List<dynamic> data) {
  final List<Folder> folders = [];
  final List<int> stack = [];
  final List<Folder> firstFolders = [];
  for (int i = 0; i < data.length; i++) {
    final item = data[i];
    final id = item['id'];
    final name = item['name'];
    final parentId = item['parent_id'];

    while (stack.isNotEmpty && stack.last != parentId) {
      stack.removeLast();
    }

    final Folder folder = Folder(
        name: name,
        id: id,
        parentId: parentId,
        isExpanded: stack.isEmpty ? true : false);

    if (stack.isNotEmpty) {
      Folder parentFolder = folders.firstWhere((element) {
        return element.id == parentId;
      });
      parentFolder.children.add(folder);
    } else {
      firstFolders.add(folder);
    }
    stack.add(id);
    folders.add(folder);
  }
  return firstFolders;
}

///폴더가 렌더링되는 class로 makefolderinfo함수에서 받은 폴더 리스트 중 isexpanded가 true인 폴더만 초기화시켜주어야함.(나머진 따라서 생성됌)
class FolderList extends StatefulWidget {
  const FolderList({super.key, required this.folders});
  final List<Folder> folders;
  @override
  State<FolderList> createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.folders.length,
      itemBuilder: ((context, index) {
        return _buildFolder(widget.folders[index]);
      }),
    );
  }

  Widget _buildFolder(Folder folder) {
    return Column(
      children: [
        ListTile(
          onPressed: () {
            print("onpressed");
          },
          leading: IconButton(
            icon: Icon(folder.isExpanded
                ? FluentIcons.chevron_up
                : FluentIcons.chevron_down),
            onPressed: () {
              setState(() {
                folder.isExpanded = !folder.isExpanded;
              });
            },
          ),

          ///추가할 부분, 이벤트 처리 추가해야함
          title: GestureDetector(
            child: Text(folder.name),
            onTap: () {
              debugPrint("onTap");
              //오른쪽 스크린에 폴더 내부 보이게 하기, 추후 폴더내 드래그, 오른쪽 스크린에 드래그, 우클릭 구현 추가해야함
            },
          ),
        ),
        const Divider(),
        folder.isExpanded
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: FolderList(folders: folder.children),
              )
            : Container()
      ],
    );
  }
}
