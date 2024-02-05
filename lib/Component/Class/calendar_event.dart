///달력 일정 클래스로 local storage에 저장했다 불러오는 것을 위해 json 형태로 변환기능 지원

class CalendarEvent {
  String text;
  int? hour;
  int? minute;
  CalendarEvent({required this.text, this.hour, this.minute});
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      text: json['text'],
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'text': text,
      'hour': hour,
      'minute': minute,
    };
    return data;
  }
}
