import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

DateTime today = DateTime.now();

class DateConvertor extends StatefulWidget {
  const DateConvertor({super.key});

  @override
  State<DateConvertor> createState() => _DateConvertorState();
}

class _DateConvertorState extends State<DateConvertor> {
  DateTime firstDay = DateTime.utc(1900, 1, 1);
  DateTime lastDay = DateTime.utc(2040, 1, 1);

  String DateTest = DateFormat('dd-mm-yyy').format(today);
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    String gregorianDate = dateFormater();

    setState(() {
      today = day;
      displayHijriDate();
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
        Text(
            "Selected Date : ${today.toString().split(" ")[0]} ,In Hijri : $DateTest"),
      ])),
    );
  }

  displayHijriDate() async {
    String gregorianDate = dateFormater();
    if (gregorianDate.isNotEmpty) {
      // Call API to convert date
      String hijriDate = await convertDate(gregorianDate);
      setState(() {
        DateTest = hijriDate;
      });
    }
  }

  String getTodayDate() {
    return DateFormat('dd-mm-yyy').format(today);
  }

  Future<String> convertDate(String gregorianDate) async {
    final url = Uri.parse('http://api.aladhan.com/v1/gToH/$gregorianDate');
    final response = await http.get(url);
    // print("Method res : ${response.body}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data']['hijri']['date'];
    } else {
      throw Exception('Failed to convert date');
    }
  }

  String dateFormater() {
    String dateString = today.toString().split(" ")[0];
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateTime date = inputFormat.parse(dateString);
    var formate1 = "${date.day}-${date.month}-${date.year}";
    print(formate1);

    return formate1; // Output: Mon, May 9, 2023
  }
}
