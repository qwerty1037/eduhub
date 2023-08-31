import 'package:flutter/material.dart';

const DEFAULT_DARK_COLOR = Color(0xFF000000);
const DEFAULT_TAB_COLOR = Colors.grey;
// Color(0xFF363943);

const DEFAULT_LIGHT_COLOR = Color(0xFFFFFFFF);
const DEFAULT_TEXT_COLOR = Colors.black;
const DEFAULT_TEXT_ALERT_COLOR = Colors.red;
const DEFAULT_BUTTON_COLOR = Colors.blueAccent;
const DEFAULT_UNABLE_COLOR = Colors.grey;
const double DEFAULT_HEAD_FONT_SIZE = 40;
const double DEFAULT_TEXT_FONT_SIZE = 25;
const double DEFAULT_BUTTON_FONT_SIZE = 30;
const String HOST = '175.124.93.223:3000';

//118.36.177.117 스터디라운지
//175.124.93.223 원격연결

enum DashBoardType {
  /// 파일 탐색
  explore,

  /// pdf 저장
  savePdf,

  /// tag 추가
  tagManagement,

  /// 검색창
  search,
  ///아무것도 선택안되었을때
  none
}
