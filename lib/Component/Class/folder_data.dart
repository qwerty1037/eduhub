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
