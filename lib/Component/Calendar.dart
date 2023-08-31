import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({super.key});

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime focusedDay = DateTime.now();

  CalendarFormat format = CalendarFormat.month;

  ///추후에는 서버에서 데이터 받아오기
  Map<DateTime, List<CalendarEvent>> events = {
    DateTime.utc(2023, 8, 31): [CalendarEvent(text: '개강 전날'), CalendarEvent(text: '마지막 방학')],
    DateTime.utc(2023, 9, 1): [CalendarEvent(text: '개강')]
  };

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          rangeSelectionMode: RangeSelectionMode.toggledOn,
          headerStyle: const HeaderStyle(titleCentered: true),
          calendarStyle: const CalendarStyle(
            canMarkersOverflow: false,
            markerSize: 10.0,
            markerSizeScale: 10.0,
            markerDecoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          locale: 'ko_KR',
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2024, 12, 30),
          daysOfWeekHeight: 20,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              this.selectedDay = selectedDay;
              this.focusedDay = focusedDay;
            });
          },
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          eventLoader: _getEventsForDay,
          onFormatChanged: (CalendarFormat format) {
            setState(() {
              this.format = format;
            });
          },
          calendarFormat: format,
          rowHeight: MediaQuery.of(context).size.width * 0.05,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${selectedDay.month}월 ${selectedDay.day}일 일정",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        OverlayState? overlayState = Overlay.of(context);
                        OverlayEntry? overlayEntry;
                        overlayEntry = OverlayEntry(
                          builder: (BuildContext context) {
                            return Positioned(
                                left: MediaQuery.of(context).size.width * 0.1,
                                top: MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.7,
                                child: Center(
                                  child: Column(
                                    children: [Text("${selectedDay.month}월 ${selectedDay.day}일 일정 추가")],
                                  ),
                                ));
                          },
                        );
                        // overlayState.insert(overlayEntry);
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
              Column(
                children: events[selectedDay] == null
                    ? []
                    : events[selectedDay]!
                        .map((e) => ListTile(
                              leading: e.minute == 0 ? Text("${e.hour}시") : Text("${e.hour}시 ${e.minute}분"),
                              title: Text(e.text),
                            ))
                        .toList(),
              )
            ],
          ),
        )
      ],
    );
  }
}

class CalendarEvent {
  String text;
  int? hour;
  int? minute;
  CalendarEvent({required this.text, this.hour, this.minute}) {
    hour ??= 9;
    minute ??= 0;
  }
}
