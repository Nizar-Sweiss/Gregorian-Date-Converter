import 'package:flutter/material.dart';

class buildDateDisplayer extends StatelessWidget {
  final bool isGregorianColor;
  final String date;

  buildDateDisplayer(
      {super.key, required this.isGregorianColor, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          isGregorianColor ? "Gregorian" : "Hijri",
          style: TextStyle(color: Colors.white),
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
              date,
              style: TextStyle(color: Colors.white),
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
        ),
      ],
    );
  }
}
