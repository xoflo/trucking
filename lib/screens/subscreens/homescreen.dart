import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:intl/intl.dart';

import '../../models/driver.dart';
import '../../models/site.dart';

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
                  addTicketButton(dateToString(selectedDate!))
                ],
              )
          ),
          ticketListView()
        ],
      ),
    );
  }

  addTicketButton(String date) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20,0,0,0),
      child: ElevatedButton(onPressed: () {
        showDialog(context: context, builder: (_) => ticketDialog(date));
      }, child: Text("+ Trip Ticket")),
    );
  }

  ticketDialog(String date) {

    String loadTime = "";
    String driverName = "Select";
    String siteName = "Select";

    return AlertDialog(
      title: Text("Trip Ticket ($date)"),
      content: Container(
        height: 800,
        width: 400,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'ex: 24-124217', hintStyle: TextStyle(color: Colors.grey),
                labelText: 'EPDC TT#'
              ),
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: 29771', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'MMDC TT#'
              ),
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: 106', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Loaded By'
              ),
            ),

            ListTile(
              title: Row(
                children: [
                  Text('Time Loaded:'),
                  Spacer(),
                  Container(
                    height: 40,
                    width: 100,
                    child: CupertinoTimePickerButton(
                      mainColor: Colors.orange,
                      initialTime: TimeOfDay(hour: 08, minute: 0),
                      onCompleted: (timeOfDay) {
                        loadTime = timeOfDay!.toString();
                        print(loadTime);
                      },
                    ),
                  ),
                ],
              ),
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: Trugillo', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Load Operator'
              ),
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: 101-075', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Load Checker'
              ),
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: 1090', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Hauled By'
              ),
            ),

            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return ListTile(
                  title: Text('Driver: ${driverName}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    final result = showDialog(context: context, builder: (_) => PopScope(
                      onPopInvokedWithResult: (bool, value) {
                        driverName = value.toString();
                        setState((){

                        });
                      },
                      child: AlertDialog(
                        title: Text("Select Driver"),
                        content: StreamBuilder(
                          stream: widget.userAccount.collection('drivers').snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.connectionState == ConnectionState.active ?
                            snapshot.data!.docs.length != 0 ?
                            Container(
                              height: 400,
                              width: 400,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, i) {
                                    final driver = snapshot.data!.docs[i];

                                    return ListTile(
                                      title: Text(driver.get('name')),
                                      onTap: () {
                                        Navigator.pop(context, driver.get('name'));
                                      },
                                    );

                                  }),
                            ) : Center(
                              child: Text("No Drivers Found", style: TextStyle(color: Colors.grey)),
                            ) : Container(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),

                              ),
                            );
                          },
                        ),
                      ),
                    ));

                  },
                );
              },
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: 1080', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Received By'
              ),
            ),

            ListTile(
              title: Row(
                children: [
                  Text('Time Received:'),
                  Spacer(),
                  Container(
                    height: 40,
                    width: 100,
                    child: CupertinoTimePickerButton(
                      mainColor: Colors.orange,
                      initialTime: TimeOfDay(hour: 08, minute: 0),
                      onCompleted: (timeOfDay) {
                        loadTime = timeOfDay!.toString();
                        print(loadTime);
                      },
                    ),
                  ),
                ],
              ),
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: 1090', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Receive Operator'
              ),
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: 101028', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Receive Checker'
              ),
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: 490', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Material'
              ),
            ),

            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return ListTile(
                  title: Text('Site: ${siteName}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    final result = showDialog(context: context, builder: (_) => PopScope(
                      onPopInvokedWithResult: (bool, dynamic value) {
                        siteName = "${value.name} (${value.type})";
                        setState((){

                        });
                      },
                      child: AlertDialog(
                        title: Text("Select Site"),
                        content: StreamBuilder(
                          stream: widget.userAccount.collection('sites').snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.connectionState == ConnectionState.active ?
                            snapshot.data!.docs.length != 0 ?
                            Container(
                              height: 400,
                              width: 400,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, i) {
                                    final site = snapshot.data!.docs[i];

                                    return ListTile(
                                      title: Text(site.get('name')),
                                      onTap: () {
                                        Navigator.pop(context, Site.fromFirebase(site));
                                      },
                                    );

                                  }),
                            ) : Center(
                              child: Text("No Sites Found", style: TextStyle(color: Colors.grey)),
                            ) : Container(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),

                              ),
                            );
                          },
                        ),
                      ),
                    ));

                  },
                );
              },
            ),

            TextField(
              decoration: InputDecoration(
                  hintText: 'ex: CW', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Destination'
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: () {

        }, icon: Icon(
            color: Colors.orange,
            Icons.check_circle))
      ],
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
