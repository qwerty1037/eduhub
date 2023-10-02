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
