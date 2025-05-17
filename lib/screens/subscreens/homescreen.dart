import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:intl/intl.dart';
import 'package:trucking/models/ticket.dart';

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

  batchTicketColorHandler(bool i) {
    if (i == true) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  ticketDialog(String date) {

    bool batchTicket = false;

    DateTime? loadTime;
    DateTime? receiveTime;
    String driverName = "Select";
    String siteName = "Select";

    TextEditingController epdc = TextEditingController();
    TextEditingController mmdc = TextEditingController();
    TextEditingController loadedBy = TextEditingController();
    TextEditingController loadOperator = TextEditingController();
    TextEditingController loadChecker = TextEditingController();
    TextEditingController hauledBy = TextEditingController();
    TextEditingController receivedBy = TextEditingController();
    TextEditingController receiveOperator = TextEditingController();
    TextEditingController receiveChecker = TextEditingController();
    TextEditingController material = TextEditingController();
    TextEditingController activity = TextEditingController();
    TextEditingController destination = TextEditingController();


    return AlertDialog(
      title: Row(
        children: [
          Text("Trip Ticket ($date)"),
          Spacer(), StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return IconButton(
                  tooltip: 'Batch Ticket: ${batchTicket == false ? 'Off' : 'On'}',
                  onPressed: () {
                    batchTicket = !batchTicket;
                    setState((){

                    });
                  },
                  icon: Icon(
                      color: batchTicketColorHandler(batchTicket),
                      Icons.repeat));
            },
          )
        ],
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 800,
          width: 400,
          child: Column(
            children: [
              TextField(
                controller: epdc,
                decoration: InputDecoration(
                  hintText: 'ex: 24-124217', hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'EPDC TT#'
                ),
              ),

              TextField(
                controller: mmdc,
                decoration: InputDecoration(
                    hintText: 'ex: 29771', hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'MMDC TT#'
                ),
              ),

              TextField(
                controller: loadedBy,
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
                      height: 35,
                      width: 100,
                      child: CupertinoTimePickerButton(
                        mainColor: Colors.orange,
                        initialTime: TimeOfDay(hour: 08, minute: 0),
                        onCompleted: (timeOfDay) {
                          DateTime newDate = DateTime.parse(DateFormat.yMMMMd().parse(date).toString());
                          DateTime finalDate = DateTime(newDate.year, newDate.month, newDate.day, timeOfDay!.hour, timeOfDay.minute);
                          loadTime = finalDate;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              TextField(
                controller: loadOperator,
                decoration: InputDecoration(
                    hintText: 'ex: Trugillo', hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Load Operator'
                ),
              ),

              TextField(
                controller: loadChecker,
                decoration: InputDecoration(
                    hintText: 'ex: 101-075', hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Load Checker'
                ),
              ),

              TextField(
                controller: hauledBy,
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
                controller: receivedBy,
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
                      height: 35,
                      width: 100,
                      child: CupertinoTimePickerButton(
                        mainColor: Colors.orange,
                        initialTime: TimeOfDay(hour: 8, minute: 0),
                        onCompleted: (timeOfDay) {
                          DateTime newDate = DateTime.parse(DateFormat.yMMMMd().parse(date).toString());
                          DateTime finalDate = DateTime(newDate.year, newDate.month, newDate.day, timeOfDay!.hour, timeOfDay.minute);
                          receiveTime = finalDate;
                          print(receiveTime);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              TextField(
                controller: receiveOperator,
                decoration: InputDecoration(
                    hintText: 'ex: 1090', hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Receive Operator'
                ),
              ),

              TextField(
                controller: receiveChecker,
                decoration: InputDecoration(
                    hintText: 'ex: 101028', hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Receive Checker'
                ),
              ),

              TextField(
                controller: material,
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
                controller: destination,
                decoration: InputDecoration(
                    hintText: 'ex: CW', hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Destination'
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(onPressed: ()  async {
          final result = await Ticket(epdc.text, mmdc.text, date, loadedBy.text, loadTime, loadChecker.text, loadOperator.text,
              hauledBy.text, driverName, receivedBy.text, receiveTime, receiveOperator.text, receiveChecker.text,
              material.text, activity.text, siteName, destination.text).toFirebase(widget.userAccount);

          if (result == 1) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ticket Recorded")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Went Wrong")));
          }
          }, icon: Icon(
            color: Colors.orange,
            Icons.check_circle))
      ],
    );
  }

  driverList(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List<String> driverList = [];

    snapshot.data!.docs.forEach((e) {
      driverList.add(e.get('driver'));
    });

    return driverList.toSet().toList();
  }

  ticketListView() {

    final datedRef = widget.userAccount.collection('tickets').where('date', isEqualTo: dateToString(selectedDate!));


    return Container(
      padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
      height: 300,
      child: StreamBuilder(
        stream: datedRef.snapshots(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.active ? snapshot.data!.docs.isEmpty ? Center(
            child: Text("No Trip Tickets Found", style: TextStyle(color: Colors.grey)),
          ) : Builder(
            builder: (context) {
              List<String> drivers = driverList(snapshot);
              return ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      onTap: () {
                        showTicketReport(datedRef, drivers[i]);
                      },
                      title: Text(drivers[i]),
                    );
                  });
            }
          ) : Center(
            child: Container(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
          );
        },
      ),
    );
  }

  showTicketReport(Query<Map<String, dynamic>> query, String driver) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Trip Tickets: $driver"),
      content: StreamBuilder(
        stream: query.where('driver', isEqualTo: driver).snapshots(),
        builder: (context, snapshot) {
          return Container(
            height: 400,
            width: 400,
            child: Column(
              children: [
                TextButton(
                    child: Text("Trip Tickets: ${snapshot.data!.docs.length}"),
                    onPressed: () {  })
              ],
            ),
          );
        },

      ),
    ));
  }

  dateToString(DateTime dateTime) {

    DateFormat dateFormat = DateFormat.yMMMMd();
    return dateFormat.format(dateTime);
  }
}
