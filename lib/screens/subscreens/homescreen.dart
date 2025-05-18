import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:intl/intl.dart';
import 'package:trucking/models/ticket.dart';

import '../../models/driver.dart';
import '../../models/site.dart';
import '../mainpage.dart';

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
      children: [calendar(), ticketsViewHandler()],
    );
  }

  calendar() {
    return Container(
      padding: EdgeInsets.all(15),
      child: CupertinoCalendar(
          onDateSelected: (date) {
            selectedDate = date;
            setState(() {});
          },
          mainColor: Colors.orange,
          minimumDateTime: DateTime(2024, 1, 1),
          maximumDateTime: DateTime(2030)),
    );
  }

  ticketsViewHandler() {
    if (selectedDate != null) {
      return ticketsView();
    } else {
      return Container(
        height: 300,
        child: Center(
          child: Text("Tap a date to view tickets", style: TextStyle(color: Colors.grey)),
        ),
      );
    }
  }

  ticketsView() {
    final date = dateToString(selectedDate!);

    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 20, 40, 20),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text(date,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  addTicketButton(date)
                ],
              )),
          ticketListView(date)
        ],
      ),
    );
  }

  addTicketButton(String date) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: ElevatedButton(
          onPressed: () {
            showDialog(context: context, builder: (_) => ticketDialog(date));
          },
          child: Text("+ Trip Ticket")),
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
    String siteActivity = "";
    double siteDistance = 0;
    double driverIncentiveRate = 0;

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
    TextEditingController destination = TextEditingController();


    batchTicketClear() {
      epdc.clear();
      mmdc.clear();
      loadTime = null;
      receiveTime = null;
    }

    clearTicketFields() {
      loadTime = null;
      receiveTime = null;
      driverName = "Select";
      siteName = "Select";
      siteActivity = "";
      epdc.clear();
      mmdc.clear();
      loadedBy.clear();
      loadOperator.clear();
      loadChecker.clear();
      hauledBy.clear();
      receivedBy.clear();
      receiveOperator.clear();
      receiveChecker.clear();
      material.clear();
      destination.clear();
    }

    return AlertDialog(
      title: Row(
        children: [
          Text("Trip Ticket ($date)"),
          Spacer(),
          StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return IconButton(
                  tooltip:
                      'Batch Ticket: ${batchTicket == false ? 'Off' : 'On'}',
                  onPressed: () {
                    batchTicket = !batchTicket;
                    setState(() {});
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
                    hintText: 'ex: 24-124217',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'EPDC TT#'),
              ),
              TextField(
                controller: mmdc,
                decoration: InputDecoration(
                    hintText: 'ex: 29771',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'MMDC TT#'),
              ),
              TextField(
                controller: loadedBy,
                decoration: InputDecoration(
                    hintText: 'ex: 106',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Loaded By'),
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
                          DateTime newDate = DateTime.parse(
                              DateFormat.yMMMMd().parse(date).toString());
                          DateTime finalDate = DateTime(
                              newDate.year,
                              newDate.month,
                              newDate.day,
                              timeOfDay!.hour,
                              timeOfDay.minute);
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
                    hintText: 'ex: Trugillo',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Load Operator'),
              ),
              TextField(
                controller: loadChecker,
                decoration: InputDecoration(
                    hintText: 'ex: 101-075',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Load Checker'),
              ),
              TextField(
                controller: hauledBy,
                decoration: InputDecoration(
                    hintText: 'ex: 1090',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Hauled By'),
              ),
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return ListTile(
                    title: Text('Driver: ${driverName}'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      final result = showDialog(
                          context: context,
                          builder: (_) => PopScope(
                                onPopInvokedWithResult: (bool, dynamic value) {
                                  driverName = value.name;
                                  driverIncentiveRate = value.incentiveRate;
                                  setState(() {});
                                },
                                child: AlertDialog(
                                  title: Text("Select Driver"),
                                  content: StreamBuilder(
                                    stream: widget.userAccount
                                        .collection('drivers')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return snapshot.connectionState ==
                                              ConnectionState.active
                                          ? snapshot.data!.docs.length != 0
                                              ? Container(
                                                  height: 400,
                                                  width: 400,
                                                  child: ListView.builder(
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        final driver = snapshot
                                                            .data!.docs[i];

                                                        return ListTile(
                                                          title: Text(driver
                                                              .get('name')),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context,
                                                                Driver.fromFirebase(driver));
                                                          },
                                                        );
                                                      }),
                                                )
                                              : Center(
                                                  child: Text(
                                                      "No Drivers Found",
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                )
                                          : Container(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
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
                    hintText: 'ex: 1080',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Received By'),
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
                          DateTime newDate = DateTime.parse(
                              DateFormat.yMMMMd().parse(date).toString());
                          DateTime finalDate = DateTime(
                              newDate.year,
                              newDate.month,
                              newDate.day,
                              timeOfDay!.hour,
                              timeOfDay.minute);
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
                    hintText: 'ex: 1090',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Receive Operator'),
              ),
              TextField(
                controller: receiveChecker,
                decoration: InputDecoration(
                    hintText: 'ex: 101028',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Receive Checker'),
              ),
              TextField(
                controller: material,
                decoration: InputDecoration(
                    hintText: 'ex: 490',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Material'),
              ),
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return ListTile(
                    title: Text('Site: ${siteName} ${siteActivity == '' ? "" : "($siteActivity)"}'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      final result = showDialog(
                          context: context,
                          builder: (_) => PopScope(
                                onPopInvokedWithResult: (bool, dynamic value) {

                                  siteName = "${value.name}";
                                  siteActivity = "${value.type}";
                                  siteDistance = value.distance;
                                  setState(() {});
                                },
                                child: AlertDialog(
                                  title: Text("Select Site"),
                                  content: StreamBuilder(
                                    stream: widget.userAccount
                                        .collection('sites')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return snapshot.connectionState ==
                                              ConnectionState.active
                                          ? snapshot.data!.docs.length != 0
                                              ? Container(
                                                  height: 400,
                                                  width: 400,
                                                  child: ListView.builder(
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        final site = snapshot
                                                            .data!.docs[i];

                                                        return ListTile(
                                                          title: Text(
                                                              site.get('name')),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context,
                                                                Site.fromFirebase(
                                                                    site));
                                                          },
                                                        );
                                                      }),
                                                )
                                              : Center(
                                                  child: Text("No Sites Found",
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                )
                                          : Container(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
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
                    hintText: 'ex: CW',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Destination'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () async {

              final submitCondition = driverName != 'Select' && siteName != 'Select' && loadTime != null && receiveTime != null;

              if (submitCondition == true) {
                final result = await Ticket(
                    epdc.text,
                    mmdc.text,
                    date,
                    loadedBy.text,
                    loadTime,
                    loadChecker.text,
                    loadOperator.text,
                    hauledBy.text,
                    driverName,
                    receivedBy.text,
                    receiveTime,
                    receiveOperator.text,
                    receiveChecker.text,
                    material.text,
                    siteActivity,
                    siteName,
                    destination.text,
                    driverIncentiveRate: driverIncentiveRate,
                    siteDistance: siteDistance
                )
                    .toFirebase(widget.userAccount);

                if (result == 1) {
                  if (batchTicket == true) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Ticket Recorded")));
                    batchTicketClear();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Ticket Recorded")));
                    clearTicketFields();
                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Something Went Wrong")));
                }

              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Complete Fields")));
              }

            },
            icon: Icon(color: Colors.orange, Icons.check_circle))
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

  ticketListView(String date) {
    final datedRef = widget.userAccount
        .collection('tickets')
        .where('date', isEqualTo: dateToString(selectedDate!));

    return Container(
      padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
      height: 300,
      child: StreamBuilder(
        stream: datedRef.snapshots(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.active
              ? snapshot.data!.docs.isEmpty
                  ? Center(
                      child: Text("No Trip Tickets Found",
                          style: TextStyle(color: Colors.grey)),
                    )
                  : Builder(builder: (context) {
                      List<String> drivers = driverList(snapshot);
                      return ListView.builder(
                          itemCount: drivers.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              onTap: () {
                                showTicketReport(datedRef, drivers[i], date);
                              },
                              title: Text(drivers[i]),
                              subtitle: Text("Trip Tickets: ${snapshot.data!.docs.where((e) => e.get('driver') == drivers[i]).toList().length}"),
                            );
                          });
                    })
              : Center(
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

  showTicketReport(
      Query<Map<String, dynamic>> query, String driver, String date) async {


    final drivers = widget.userAccount.collection('drivers').where('name', isEqualTo: driver);
    final incentiveRate = await drivers.get().then((value) {
      return double.parse(value.docs[0].get('incentiveRate').toString());
    });


    final driverDocs = await query.where('driver', isEqualTo: driver).get().then((value) {
      return value.docs;
    });
    final double totalKM = await getTotalKM(driverDocs);



    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("$driver ($date)"),
              content: StreamBuilder(
                stream: query.where('driver', isEqualTo: driver).snapshots(),
                builder: (context, snapshot) {


                  return snapshot.connectionState == ConnectionState.active
                      ? Container(
                          height: 150,
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: TextButton(
                                    child: Text(
                                        "Trip Tickets: ${snapshot.data!.docs.length}"),
                                    onPressed: () {
                                      showTicketsByDriver(snapshot.data!.docs);
                                    }),
                              ),
                              SizedBox(height: 20),
                              Text("Total Kilometer: $totalKM km"),
                              Text("Incentive Rate: P$incentiveRate"),
                              Divider(),
                              Text("Total: P${totalKM * incentiveRate}")
                            ],
                          ),
                        )
                      : loadWidget(50);
                },
              ),
            ));
  }

  getTotalKM(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    List<String> sites = [];
    double totalKM = 0;

    print("docslength: ${docs.length}");

    docs.forEach((e) {
      sites.add(e.get('site'));
    });
    
    sites.toSet().toList();

    for (int i = 0; i < sites.length; i++){
      await widget.userAccount.collection('sites').where('name', isEqualTo: sites[i]).get().then((value) {
        value.docs.forEach((e) {
          totalKM = totalKM + (double.parse(e.get('distance').toString()));
        });
      });
    }

    print('totalKM: $totalKM');
    return totalKM;
  }

  showTicketsByDriver(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {

    List<Ticket> tickets = [];
    docs.forEach((e) {tickets.add(Ticket.fromFirebase(e));});

    int ticketCounter = 0;

    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Text("Trips (${ticketCounter + 1} / ${tickets.length})"),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        if (ticketCounter == 0) {
                        } else {
                          ticketCounter = ticketCounter - 1;
                          setState(() {

                          });
                        }
                      },
                      icon: Icon(
                          color:
                          ticketCounter == 0 ? Colors.grey : Colors.orange,
                          Icons.chevron_left)),
                  IconButton(
                      onPressed: () {
                        if (ticketCounter == tickets.length - 1) {
                        } else {
                          ticketCounter = ticketCounter + 1;
                          setState(() {

                          });
                        }
                      },
                      icon: Icon(
                          color: ticketCounter == tickets.length - 1
                              ? Colors.grey
                              : Colors.orange,
                          Icons.chevron_right))
                ],
              ),
              content: SizedBox(
                height: 380,
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("EPDC TT #: ${tickets[ticketCounter].epdc}"),
                    Text("MMDC TT #: ${tickets[ticketCounter].mmdc}"),
                    Text("Date: ${tickets[ticketCounter].date}"),
                    Text("Loaded By: ${tickets[ticketCounter].loadedBy}"),
                    Text("Time Loaded: ${DateFormat('hh:mm a').format(tickets[ticketCounter].timeLoaded!)}"),
                    Text("Load Checker: ${tickets[ticketCounter].loadChecker}"),
                    Text("Load Operator: ${tickets[ticketCounter].loadOperator}"),
                    Text("Hauled By: ${tickets[ticketCounter].hauledBy}"),
                    Text("Driver: ${tickets[ticketCounter].driver}"),
                    Text("Received By: ${tickets[ticketCounter].receivedBy}"),
                    Text("Time Received: ${DateFormat('hh:mm a').format(tickets[ticketCounter].timeReceived!)}"),
                    Text("Receive Operator: ${tickets[ticketCounter].receiveOperator}"),
                    Text("Receive Checker: ${tickets[ticketCounter].receiveChecker}"),
                    Text("Material: ${tickets[ticketCounter].material}"),
                    Text("Activity: ${tickets[ticketCounter].activity}"),
                    Text("Site: ${tickets[ticketCounter].site}"),
                    Text("Destination: ${tickets[ticketCounter].destination}"),
                  ],
                ),
              ),
            );
          },
        ));
  }

  dateToString(DateTime dateTime) {
    DateFormat dateFormat = DateFormat.yMMMMd();
    return dateFormat.format(dateTime);
  }
}
