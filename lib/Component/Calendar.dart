import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({super.key});

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime focusedDay = DateTime.now();

  CalendarFormat format = CalendarFormat.month;
  Map<DateTime, List<CalendarEvent>> events = {};

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
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
      lastDay: DateTime.utc(2030, 12, 30),
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
    );
  }
}

class CalendarEvent {
  String text;
  CalendarEvent(this.text);
}
