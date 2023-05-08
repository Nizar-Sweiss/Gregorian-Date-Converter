import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateConvertor extends StatefulWidget {
  const DateConvertor({super.key});

  @override
  State<DateConvertor> createState() => _DateConvertorState();
}

class _DateConvertorState extends State<DateConvertor> {
  DateTime today = DateTime.now();
  DateTime firstDay = DateTime.utc(1900, 1, 1);
  DateTime lastDay = DateTime.utc(2040, 1, 1);
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Date Convertor"),
      ),
      body: Center(
          child: Column(children: [
        TableCalendar(
          selectedDayPredicate: (day) => isSameDay(day, today),
          focusedDay: today,
          firstDay: firstDay,
          lastDay: lastDay,
          onDaySelected: _onDaySelected,
        ),
        Text("Selected Date : ${today.toString().split(" ")[0]} ")
      ])),
    );
  }
}
