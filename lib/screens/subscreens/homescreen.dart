import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        calendar(),
        ticketsViewHandler()
      ],
    );
  }

  calendar() {
    return Container(
      padding: EdgeInsets.all(15),
      child: CupertinoCalendar(
        onDateSelected: (date) {
          selectedDate = date;
          setState(() {

          });
        },
          mainColor: Colors.orange,
          minimumDateTime: DateTime(2024, 1, 1), maximumDateTime: DateTime(2030)
      ),
    );
  }

  ticketsViewHandler() {
    if (selectedDate != null) {
      return ticketsView();
    } else {
      return Container();
    }
  }

  ticketsView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 20, 40, 20),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(dateToString(selectedDate!), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
          ),
          ticketTiles()
        ],
      ),
    );
  }

  ticketTiles() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
      height: 300,
      child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, i) {
            return ListTile(
              onTap: () {

              },
              title: Text("Driver"),
            );
          }),
    );
  }

  dateToString(DateTime dateTime) {

    DateFormat dateFormat = DateFormat.yMMMMd();
    return dateFormat.format(dateTime);
  }
}
