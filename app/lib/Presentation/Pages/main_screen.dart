import 'package:app/Config/Theme/colors_palets.dart';
import 'package:app/Presentation/Pages/display_events_screen.dart';
import 'package:flutter/material.dart';
import 'date_convertor_class.dart';

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
    const DateConvertor(),
    const DisplayEventScreen()
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
          icon: Icon(Icons.star),
          label: 'Hijri Planner',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.date_range,
          ),
          label: 'Events',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.red_tint_1,
      backgroundColor: AppColors.dark_purple,
      unselectedItemColor: AppColors.white_Text,
      onTap: _onItemTapped,
    );
  }
}
