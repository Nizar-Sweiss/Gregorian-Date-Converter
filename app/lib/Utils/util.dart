import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text, bool isError) {
    if (text == null) return;
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: isError
          ? Color.fromARGB(255, 140, 0, 0)
          : Color.fromARGB(255, 0, 122, 4),
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
