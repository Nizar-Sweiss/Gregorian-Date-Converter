import 'dart:convert';
import 'package:app/Config/Theme/colors_palets.dart';
import 'package:app/Data/DataSources/Local/firebase_maneger.dart';
import 'package:app/Models/EventData.dart';
import 'package:app/Presentation/Pages/display_events_screen.dart';
import 'package:app/Presentation/Widgets/date_displayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../../Utils/util.dart';

DateTime today = DateTime.now();
String hijriDate = today.toString();

class DateConvertor extends StatefulWidget {
  const DateConvertor({super.key});

  @override
  State<DateConvertor> createState() => _DateConvertorState();
}

class _DateConvertorState extends State<DateConvertor> {
  final DateTime firstDay = DateTime.utc(1900, 1, 1);
  final DateTime lastDay = DateTime.utc(2040, 1, 1);

  String theFormatedHijriDate = DateFormat('yyyy-MM-dd').format(today);

  TextEditingController eventData = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayHijriDate();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;

      displayHijriDate();
      formatHijriDate(theFormatedHijriDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark_purple,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
            Container(
              color: AppColors.dark_purple,
              child: buildTableCalendar(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BuildDateDisplayer(isGregorianColor: true, date: today),
                BuildDateDisplayer(
                    isGregorianColor: false,
                    date: DateTime.parse(theFormatedHijriDate)),
              ],
            ),
            Container(
              color: AppColors.light_purple,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                        height: 40,
                        color: AppColors.light_purple,
                        child: Center(
                            child: Text(
                          DateFormat('EEEE MMMM dd, yyyy').format(today),
                          style: TextStyle(
                            color: AppColors.white_Text,
                          ),
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.dark_purple,
                              AppColors.light_purple
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            buildBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Expanded(flex: 1, child: Icon(Icons.add)),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Add Event',
                                  style: TextStyle(
                                    color: AppColors.white_Text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ])),
    );
  }

  Future<dynamic> buildBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Column(
              children: [
                TextFormField(
                  controller: eventData,
                  decoration: const InputDecoration(
                    errorMaxLines: 2,
                    labelText: 'Enter text',
                    hintText: 'Enter your text here',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red), // Set the desired color here
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Set the desired color here
                        ),
                        onPressed: () {
                          FireBaseManeger.addDataToFirebase(
                              eventData.text, today);
                          // Utils.showSnackBar("Added Successfuly ", true);
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  TableCalendar<dynamic> buildTableCalendar() {
    return TableCalendar(
      calendarStyle: const CalendarStyle(
          defaultDecoration: BoxDecoration(shape: BoxShape.circle),
          defaultTextStyle: TextStyle(
            color: AppColors.white_Text,
            decorationColor: AppColors.white_Text,
          )),
      selectedDayPredicate: (day) => isSameDay(day, today),
      focusedDay: today,
      firstDay: firstDay,
      lastDay: lastDay,
      onDaySelected: _onDaySelected,
      headerStyle: const HeaderStyle(
          titleTextStyle: TextStyle(
        color: AppColors.white_Text,
      )),
      daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(
            color: AppColors.white_Text,
          ),
          weekdayStyle: TextStyle(
            color: AppColors.white_Text,
          )),
    );
  }

  displayHijriDate() async {
    String gregorianDate = dateFormater();
    hijriDate = gregorianDate;
    if (gregorianDate.isNotEmpty) {
      // Call API to convert date
      String hijriDate = await getHijriDate(gregorianDate);
      DateTime formatedHijriDate = formatHijriDate(hijriDate);
      setState(() {
        theFormatedHijriDate =
            DateFormat('yyyy-MM-dd').format(formatedHijriDate);
      });
    }
  }

  DateTime formatHijriDate(String hijridate) {
    List<String> dateParts = hijridate.split('-');

    int year = int.parse(dateParts[2]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[0]);
    DateTime formatedHijriDate = DateTime(year, month, day);
    return formatedHijriDate;
  }

  Future<String> getHijriDate(String gregorianDate) async {
    final url = Uri.parse('http://api.aladhan.com/v1/gToH/$gregorianDate');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      hijriDate = jsonResponse['data']['hijri']['date'];
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

    return formate1;
  }
}
