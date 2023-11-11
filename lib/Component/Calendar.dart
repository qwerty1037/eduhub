import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_end/Component/Default/CalendarEvent.dart';
import 'package:front_end/Component/Default/Default_TextBox.dart';
import 'package:front_end/Controller/ScreenController/Home_Screen_Controller.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({
    super.key,
  });

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime focusedDay = DateTime.now();
  CalendarFormat format = CalendarFormat.month;

  //추후에는 서버에서 데이터 받아오기

  HomeScreenController homeScreenController = Get.find<HomeScreenController>();
  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return homeScreenController.events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeScreenController>(
      builder: ((controller) {
        return Column(
          children: [
            TableCalendar(
              pageJumpingEnabled: controller.temp_variable.value,
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
              focusedDay: focusedDay,
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
                          onPressed: () async {
                            TextEditingController titleController =
                                TextEditingController();
                            TextEditingController hourController =
                                TextEditingController();
                            TextEditingController minuteController =
                                TextEditingController();
                            await f.showDialog<String>(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) => f.ContentDialog(
                                title: Text(
                                    "${selectedDay.month}월 ${selectedDay.day}일 일정 추가"),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "내용",
                                        ),
                                        DefaultTextBox(
                                          placeholder: "필수",
                                          controller: titleController,
                                        ),
                                        const Text("시(24H)"),
                                        DefaultTextBox(
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly // 숫자만 입력되도록 필터링
                                          ],
                                          placeholder: "선택",
                                          controller: hourController,
                                        ),
                                        const Text("분"),
                                        DefaultTextBox(
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly // 숫자만 입력되도록 필터링
                                          ],
                                          placeholder: "선택",
                                          controller: minuteController,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  f.Button(
                                    child: const Text('추가'),
                                    onPressed: () {
                                      if (titleController.text != "") {
                                        setState(() {
                                          if (homeScreenController
                                                  .events[selectedDay] !=
                                              null) {
                                            homeScreenController
                                                .events[selectedDay]!
                                                .add(CalendarEvent(
                                                    text: titleController.text,
                                                    hour: int.parse(
                                                        hourController.text),
                                                    minute: int.parse(
                                                        minuteController
                                                            .text)));
                                          } else {
                                            homeScreenController
                                                .events[selectedDay] = [
                                              CalendarEvent(
                                                  text: titleController.text,
                                                  hour: int.parse(
                                                      hourController.text),
                                                  minute: int.parse(
                                                      minuteController.text))
                                            ];
                                          }
                                        });
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                        f.showSnackbar(
                                            context,
                                            const f.InfoBar(
                                              title: Text('일정 미입력:'),
                                              content: Text(
                                                '일정 내용이 입력되지 않았습니다',
                                              ),
                                              severity: f.InfoBarSeverity.info,
                                            ));
                                      }
                                    },
                                  ),
                                  f.FilledButton(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.add))
                    ],
                  ),
                  Obx(() {
                    return Column(
                      children: homeScreenController.events[selectedDay] == null
                          ? []
                          : homeScreenController.events[selectedDay]!
                              .map((e) => ListTile(
                                    leading: e.hour == null
                                        ? null
                                        : e.minute == 0
                                            ? Text("${e.hour}시")
                                            : Text("${e.hour}시 ${e.minute}분"),
                                    title: Text(
                                      e.text,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(f.FluentIcons.delete),
                                      onPressed: () {
                                        homeScreenController
                                            .events[selectedDay]!
                                            .remove(e);
                                        homeScreenController.events.refresh();
                                      },
                                    ),
                                  ))
                              .toList(),
                    );
                  })
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
