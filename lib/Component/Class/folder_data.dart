///폴더 데이터. 폴더 아이디와 이름이 같으면 같은 instance로 인식하기 위해 override함

class FolderData {
  FolderData({required this.parent, required this.id, required this.name});
  int? parent;
  int id;
  String name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FolderData && runtimeType == other.runtimeType && id == other.id && name == other.name);
}
