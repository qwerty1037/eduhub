import 'package:flutter/material.dart';

///잡다한 default 설정과 왼쪽 대시보드 타입 관련 데이터

const DEFAULT_DARK_COLOR = Color(0xFF000000);
const DEFAULT_TAB_COLOR = Colors.grey;
const DEFAULT_LIGHT_COLOR = Color(0xFFFFFFFF);
const DEFAULT_TEXT_COLOR = Colors.black;
const DEFAULT_TEXT_ALERT_COLOR = Colors.red;
const DEFAULT_BUTTON_COLOR = Colors.blueAccent;
const DEFAULT_UNABLE_COLOR = Colors.grey;
const double DEFAULT_HEAD_FONT_SIZE = 40;
const double DEFAULT_TEXT_FONT_SIZE = 25;
const double DEFAULT_BUTTON_FONT_SIZE = 30;

const String HOST = 'ec2-3-36-65-242.ap-northeast-2.compute.amazonaws.com';

enum DashBoardType {
  /// 파일 탐색
  explore,

  /// pdf 저장
  savePdf,

  /// 시험지 만들기
  exam,

  /// tag 추가
  tagManagement,

  /// 검색창
  search,

  ///아무것도 선택안되었을때
  none,

  /// 그룹
  group,

  /// 시험지 explore
  examExplore
}
