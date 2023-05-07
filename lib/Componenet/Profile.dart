class Profile {
  String id;
  List<String> project;
  ColorMode mode;

  Profile(
      {required this.id, required this.project, this.mode = ColorMode.light});
}

enum ColorMode { dark, light }
