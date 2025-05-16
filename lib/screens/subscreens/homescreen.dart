import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userAccount});

  final DocumentReference<Map<String, dynamic>> userAccount;

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
              child: Row(
                children: [
                  Text(dateToString(selectedDate!), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  addTicketButton()
                ],
              )
          ),
          ticketListView()
        ],
      ),
    );
  }

  addTicketButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20,0,0,0),
      child: ElevatedButton(onPressed: () {

      }, child: Text("+ Trip Ticket")),
    );
  }

  ticketListView() {
    int i = 1;

    return Container(
      padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
      height: 300,
      child: StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          return i == 1 ? Center(
            child: Text("No Trip Tickets Found", style: TextStyle(color: Colors.grey)),
          ) : ListView.builder(
              itemCount: 2,
              itemBuilder: (context, i) {
                return ListTile(
                  onTap: () {

                  },
                  title: Text("Driver"),
                );
              });
        },
      ),
    );
  }

  dateToString(DateTime dateTime) {

    DateFormat dateFormat = DateFormat.yMMMMd();
    return dateFormat.format(dateTime);
  }
}
