///pdf에서 문제를 저장할 때 직사각형 프레임 클래스

class Frame {
  final double minX;
  final double minY;
  double maxX;
  double maxY;
  int page;

  Frame({required this.page, required this.minX, required this.minY, required this.maxX, required this.maxY});
}
