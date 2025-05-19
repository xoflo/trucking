import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trucking/screens/mainpage.dart';
import 'package:async/async.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, required this.userAccount});

  final DocumentReference<Map<String, dynamic>> userAccount;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {


  String displayDate = "Select";
  String displayDriver = "Select";
  String displaySite = "Select";
  String displayType = "All";


  List<DateTime> datesFilterAsDate = [DateTime(2025)];
  List<String> datesFilter = [];
  List<String> driversFilter = [];
  List<String> sitesFilter = [];
  List<String> typesFilter = [];

  List<String> displaySortBy = ["Driver", "Site", "Date"];
  int displaySortByIndex = 0;

  Timestamp? timestampLoad;
  Timestamp? timestampReceive;

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.centerLeft,
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setStateAll) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      spacing: 10,
                      children: [
                        dateSelectButton(),
                        driverSelectButton(),
                        siteSelectButton(),

                        StatefulBuilder(
                          builder: (context, setState) {
                            return TextButton(onPressed: () {
                              if (displaySortByIndex == displaySortBy.length - 1) {
                                displaySortByIndex = 0;
                              } else {
                                displaySortByIndex += 1;
                              }
                              setState((){});
                            }, child: Text("Sort by: ${displaySortBy[displaySortByIndex]}"));
                          },
                        ),
                        IconButton(
                            tooltip: 'Filter Results',
                            onPressed: () {
                              setStateAll(() {

                              });
                            }, icon: Icon(
                            color: Colors.orange,
                            Icons.content_paste_search_sharp))

                      ]),
                ),
              ),

              resultsView()

            ],
          );
        },
      ),
    );
  }

  sortResults(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {

    final realDocs = docs;
    List<QueryDocumentSnapshot<dynamic>> newResultDrive = [];
    List<QueryDocumentSnapshot<dynamic>> newResultSite = [];

    for (int i = 0; i < driversFilter.length; i++) {
      newResultDrive.addAll(docs.where((e) => e.get('driver') == driversFilter[i]).toList());
    }

    for (int i = 0; i < sitesFilter.length; i++) {
      newResultSite.addAll(newResultDrive.where((e) => e.get('site') == sitesFilter[i]).toList());
    }

    return newResultSite.toSet().toList();;

  }

  resultsView() {
    try {
      return Container(
        height: 400,
        child: condition() == true ? StreamBuilder(
          stream: widget.userAccount.collection('tickets')
              .where('timeLoaded', isGreaterThan: timestampLoad)
              .where('timeLoaded', isLessThan: timestampReceive).snapshots(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.active ?  FutureBuilder(
              future: sortResults(snapshot.data!.docs),
              builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                return snapshot.connectionState == ConnectionState.done ? ListView.builder(
                    itemCount:  snapshot.data!.length,
                    itemBuilder: (context, i) {
                      final ticket =  snapshot.data![i];

                      return ListTile(
                        title: Text(ticket.get(displaySortBy[displaySortByIndex].toLowerCase())),
                        onTap: () {
                          showDialog(context: context, builder: (_) => AlertDialog(
                            content: Container(
                              height: 400,
                              width: 400,
                            ),
                          ));
                        },
                      );
                    }): loadWidget(100);
              },
            ) : Center(
              child: Text("No results found", style: TextStyle(color: Colors.grey)),
            );
          }
        ) : Center(
          child: Text("Complete Filter Values", style: TextStyle(color: Colors.grey)),
        ),
      );
    } catch(e) {
      print(e);
    }

  }



  condition() {
    return displayDate != "Select" && displaySite != "Select" && displayDriver != "Select";
  }

  dateSelectButton() {

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return ElevatedButton(onPressed: () async {

          List<DateTime> result = await showDialog(context: context, builder: (_) => AlertDialog(
            title: Text("Filter Date"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context, datesFilter);
                  displayDate = datesFilter.length == 1 ? datesFilter[0] : "${datesFilter[0]} - ${datesFilter[1]}";
                  setState((){

                  });
                }, child: Text("Confirm"))
              ],
              content:  Container(
                height: 400,
                width: 400,
                child: CalendarDatePicker2(
                    onValueChanged: (values) {
                      List<DateTime> newDates = values;
                      datesFilter = newDates.map((e) => DateFormat.yMMMMd().format(e).toString()).toList();
                      datesFilterAsDate = values;

                      timestampLoad = Timestamp.fromDate(datesFilterAsDate.first);

                      if (values.length == 2) {
                        timestampReceive = Timestamp.fromDate(datesFilterAsDate.last.add(Duration(days: 1)));
                      } else {
                        timestampReceive = Timestamp.fromDate(datesFilterAsDate.first.add(Duration(days: 1)));
                      }

                    },
                    config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.range
                    ), value: [
                  DateTime.now()
                ]),
              )
          ));


        }, child: Text("${MediaQuery.of(context).size.width < 700 ? "$displayDate" : "Filter Date: $displayDate"} "));
      },



    );


  }

  driverSelectButton() {

    bool multipleSelectDriver = false;

    final driverSearch = TextEditingController();

    return StreamBuilder(
      stream: widget.userAccount.collection('drivers').snapshots(),
      builder: (context, snapshot) {

        return snapshot.connectionState == ConnectionState.active ? StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setStateButton) {
            return ElevatedButton(onPressed: () {

              List<QueryDocumentSnapshot<Map<String, dynamic>>> drivers = snapshot.data!.docs;

              showDialog(context: context, builder: (_) => StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return AlertDialog(
                    title: Text("Filter Driver"),
                    content: Container(
                      height: 550,
                      width: 400,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                            height: 50,
                            child: TextField(
                              controller: driverSearch,
                              decoration: InputDecoration(
                                  hintText: 'Search Driver'
                              ),
                              onChanged: (value) {
                                print(value);
                                drivers = snapshot.data!.docs.where((e) => e.get('name').toString().toUpperCase().contains(value.toUpperCase())).toList();

                                print(drivers.length);
                                setState((){

                                });
                              },
                            ),
                          ),
                          Container(
                            height: 400,
                            width: 400,
                            child: ListView.builder(
                                itemCount: drivers.length,
                                itemBuilder: (context, i) {

                                  final name = drivers[i].get('name');

                                  return StatefulBuilder(
                                    builder: (BuildContext context, void Function(void Function()) setState) {
                                      return CheckboxListTile(
                                        title: Text(name),
                                        value: driversFilter.contains(name),
                                        onChanged: (bool? newValue) {
                                          if (newValue == true) {
                                            driversFilter.add(name);
                                          } else {
                                            driversFilter.remove(name);
                                          }
                                          setState((){});
                                        },
                                      );
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    actions: [

                      TextButton(onPressed: () {
                        displayDriver = 'All';
                        Navigator.pop(context);
                        setStateButton((){

                        });

                      }, child: Text("Select All")),
                      TextButton(onPressed: () {
                        if (driversFilter.isNotEmpty) {
                          displayDriver = '${driversFilter.length == 1 ? driversFilter[0] : "${driversFilter.length} Selected"}';
                          Navigator.pop(context);
                          setStateButton((){
                          });
                        }
                      }, child: Text("Confirm Selected"))
                    ],
                  );
                },
              ));
            }, child: Text("Driver: ${displayDriver}"),

            );
          },
        ) : Container();
      },
    );
  }

  siteSelectButton() {

    final siteSearch = TextEditingController();

    return StreamBuilder(
      stream: widget.userAccount.collection('sites').snapshots(),
      builder: (context, snapshot) {

        return snapshot.connectionState == ConnectionState.active ? StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setStateButton) {
            return ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (_) => StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setStateDialog) {

                  List<QueryDocumentSnapshot<Map<String, dynamic>>> sites = snapshot.data!.docs;

                  if (typesFilter.isNotEmpty) {
                    sites.clear();
                    typesFilter.forEach((e) {
                      sites.addAll(snapshot.data!.docs.where((x) => x.get('type').toString().toUpperCase() == e.toString().toUpperCase()));
                    });
                  } else {
                    sites = snapshot.data!.docs;
                  }

                  return AlertDialog(
                    title: Text("Filter Site"),
                    content: Container(
                      height: 550,
                      width: 400,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                            height: 50,
                            child: Row(
                              spacing: 10,
                              children: [
                                Container(
                                  width: 180,
                                  child: TextField(
                                    controller: siteSearch,
                                    decoration: InputDecoration(
                                        hintText: 'Search Site'
                                    ),
                                    onChanged: (value) {
                                      print(value);
                                      sites = snapshot.data!.docs.where((e) => e.get('name').toString().toUpperCase().contains(value.toUpperCase())).toList();
                                      setStateDialog((){

                                      });
                                    },
                                  ),
                                ),
                                StatefulBuilder(
                                  builder: (BuildContext context, void Function(void Function()) setStateType) {

                                    return TextButton(onPressed: () async {
                                      showDialog(context: context, builder: (_) => AlertDialog(
                                        content: StreamBuilder(
                                          stream: widget.userAccount.collection('sitetypes').snapshots(),
                                          builder: (context, snapshot) {
                                            return Container(
                                              height: 300,
                                              width: 300,
                                              child: snapshot.connectionState == ConnectionState.active ? ListView.builder(
                                                  itemCount: snapshot.data!.docs.length,
                                                  itemBuilder: (context, i) {
                                                    final type = snapshot.data!.docs[i];
                                                    final name = type.get('name');

                                                    return StatefulBuilder(
                                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                                        return CheckboxListTile(
                                                          title: Text(name),
                                                          value: typesFilter.contains(name), onChanged: (bool? value) {
                                                          if (value == true) {
                                                            typesFilter.add(name);
                                                          } else {
                                                            typesFilter.remove(name);
                                                          }
                                                          setState((){

                                                          });
                                                        },
                                                        );
                                                      },
                                                    );
                                                  }) : loadWidget(50),
                                            );
                                          },
                                        ),
                                        actions: [

                                          TextButton(onPressed: () {
                                          if (typesFilter.isNotEmpty) {
                                            displayType = "${typesFilter.length == 1 ? typesFilter[0] : "${typesFilter.length} Selected"}";
                                            Navigator.pop(context);
                                            setStateDialog((){

                                            });
                                          } else {
                                            displayType = "All";
                                            Navigator.pop(context);
                                            setStateDialog((){

                                            });

                                          }
                                        }, child: Text("Confirm"))],
                                      ));

                                    }, child: Text("Type: $displayType"));
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 400,
                            width: 400,
                            child: ListView.builder(
                                itemCount: sites.length,
                                itemBuilder: (context, i) {

                                  final name = sites[i].get('name');
                                  final type = sites[i].get('type');

                                  return StatefulBuilder(
                                    builder: (BuildContext context, void Function(void Function()) setState) {
                                      return CheckboxListTile(
                                        title: Text("$name ($type)"),
                                        value: sitesFilter.contains(name),
                                        onChanged: (bool? newValue) {
                                          if (newValue == true) {
                                            sitesFilter.add(name);
                                          } else {
                                            sitesFilter.remove(name);
                                          }
                                          setState((){});
                                        },
                                      );
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    actions: [

                      TextButton(onPressed: () {
                        displaySite = 'All';
                        Navigator.pop(context);
                        setStateButton((){

                        });

                      }, child: Text("Select All")),
                      TextButton(onPressed: () {
                        if (sitesFilter.isNotEmpty) {
                          displaySite = '${sitesFilter.length == 1 ? sitesFilter[0] : "${sitesFilter.length} Selected"}';
                          Navigator.pop(context);
                          setStateButton((){
                          });
                        }
                      }, child: Text("Confirm Selected"))
                    ],
                  );
                },
              ));
            }, child: Text("Site: ${displaySite}"),

            );
          },
        ) : Container();
      },
    );
  }

}
