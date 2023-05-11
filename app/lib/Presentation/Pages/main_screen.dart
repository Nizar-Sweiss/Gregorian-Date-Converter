import 'package:flutter/material.dart';
import '../date_convertor_class.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgetOptions = <Widget>[
    DateConvertor(),
    Text(
      'Index 1: Business',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.date_range),
          label: 'Calender',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 82, 42, 145),
      onTap: _onItemTapped,
    );
  }
}
