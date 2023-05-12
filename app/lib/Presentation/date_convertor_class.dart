import 'dart:convert';
import 'package:app/Presentation/Widgets/date_displayer.dart';
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

  TextEditingController eventData = TextEditingController();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
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
        BuildTableCalendar(),
        Text(
            "Selected Date : ${today.toString().split(" ")[0]} ,In Hijri : $DateTest"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildDateDisplayer(isGregorianColor: true, date: "date"),
            buildDateDisplayer(isGregorianColor: false, date: "date"),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  useSafeArea: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
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
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(Colors
                                            .red), // Set the desired color here
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 100,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(Colors
                                            .green), // Set the desired color here
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    //Add the data to the Data Base .
                                  },
                                  child: Text('Add'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Text("Add Event")),
      ])),
    );
  }

  TableCalendar<dynamic> BuildTableCalendar() {
    return TableCalendar(
      selectedDayPredicate: (day) => isSameDay(day, today),
      focusedDay: today,
      firstDay: firstDay,
      lastDay: lastDay,
      onDaySelected: _onDaySelected,
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
