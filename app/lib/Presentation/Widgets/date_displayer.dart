import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class buildDateDisplayer extends StatelessWidget {
  final bool isGregorianColor;
  DateTime date;

  buildDateDisplayer(
      {super.key, required this.isGregorianColor, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          isGregorianColor ? "Gregorian" : "Hijri",
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        Container(
          width: 120,
          height: 21,
          decoration: BoxDecoration(
              color: isGregorianColor
                  ? Color.fromARGB(255, 223, 41, 0)
                  : Color.fromARGB(255, 0, 115, 202),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              border: Border.all(color: Colors.black)),
          child: Center(
            child: Text(
              date.year.toString(),
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
        Container(
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: Color.fromARGB(255, 252, 252, 252),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              DateFormat.MMMM().format(date),
              style: TextStyle(fontSize: 20),
            ),
            Text(
              date.day.toString(),
              style: TextStyle(fontSize: 60),
            )
          ]),
        ),
      ],
    );
  }

  String convertMonthDate(int month) {
    DateTime date = DateTime(DateTime.now().year);
    DateFormat formatter = DateFormat('MMMM');
    return formatter.format(date);
  }
}
