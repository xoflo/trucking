import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: calendar()
    );
  }

  calendar() {
    return CupertinoCalendar(
      onDateSelected: (date) {
        print(date);
      },
        mainColor: Colors.orange,
        minimumDateTime: DateTime(2024, 1, 1), maximumDateTime: DateTime(2030)
    );
  }
}
