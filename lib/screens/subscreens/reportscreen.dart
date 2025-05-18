import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trucking/screens/mainpage.dart';

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
  String displayType = "Select";

  List<DateTime> selectedDates = [DateTime(2025)];
  List<String> driversFilter = [];
  List<String> sitesFilter = [];
  List<String> typesFilter = [];

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            spacing: 10,
            children: [
              dateSelectButton(),
            driverSelectButton(),
            siteSelectButton(),
              filter()

            ]),
        ),

        resultsView()

      ],
    );
  }

  condition() {
    return displayDate != "Select" && displaySite != "Select" && displayDriver != "Select";
  }

  resultsView() {
    return Container(
      height: 400,
      child: condition() == true ? Container() : Center(
        child: Text("Complete Filter Values", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  dateSelectButton() {

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return ElevatedButton(onPressed: () async {

          List<DateTime> result = await showDialog(context: context, builder: (_) => AlertDialog(
            title: Text("Filter Date"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context, selectedDates);
                  displayDate = selectedDates.length == 1 ? "${DateFormat.yMMMMd().format(selectedDates[0]).toString()}" : "${DateFormat.yMMMMd().format(selectedDates[0]).toString()} - ${DateFormat.yMMMMd().format(selectedDates[1]).toString()}";
                  setState((){

                  });
                }, child: Text("Confirm"))
              ],
              content:  Container(
                height: 400,
                width: 400,
                child: CalendarDatePicker2(
                    onValueChanged: (values) {
                      print(values);
                      selectedDates = values;
                    },
                    config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.range
                    ), value: [
                  DateTime.now()
                ]),
              )
          ));


        }, child: Text("Filter Date: $displayDate"));
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
                  }

                  return AlertDialog(
                    title: Text("Filter Site"),
                    content: Container(
                      height: 550,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                            height: 50,
                            child: Row(
                              spacing: 10,
                              children: [
                                Container(
                                  width: 250,
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
                          displaySite = '${sitesFilter.length} Selected';
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

  filter() {
    return IconButton(
        tooltip: 'Filter Results',
        onPressed: () {
          setState(() {

          });
    }, icon: Icon(
        color: Colors.orange,
        Icons.content_paste_search_sharp));
  }


}
