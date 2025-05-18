import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, required this.userAccount});

  final DocumentReference<Map<String, dynamic>> userAccount;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
        )


      ],
    );
  }

  dateSelectButton() {

    String displayDate = "Select";
    List<DateTime> selectedDates = [DateTime(2025)];


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
                height: 300,
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
    return StreamBuilder(
      stream: widget.userAccount.collection('drivers').snapshots(),
      builder: (context, snapshot) {

        String displayDriver = "Select";

        return snapshot.connectionState == ConnectionState.active ? StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return ElevatedButton(onPressed: () {

              final drivers = snapshot.data!.docs;

              showDialog(context: context, builder: (_) => AlertDialog(
                title: Text("Filter Driver"),
                content: Container(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                      itemCount: drivers.length,
                      itemBuilder: (context, i) {

                        final name = drivers[i].get('name');

                        return ListTile(
                          title: Text(name),
                          onTap: () {
                            displayDriver = name;
                            Navigator.pop(context, name);
                            setState((){
                            });
                          },
                        );
                      }),
                ),
              ));
            }, child: Text("Driver: ${displayDriver}"),

            );
          },
        ) : Container();
      },
    );
  }

  siteSelectButton() {
    return StreamBuilder(
      stream: widget.userAccount.collection('sites').snapshots(),
      builder: (context, snapshot) {

        String displaySite = "Select";

        return snapshot.connectionState == ConnectionState.active ? StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return ElevatedButton(onPressed: () {

              final sites = snapshot.data!.docs;

              showDialog(context: context, builder: (_) => AlertDialog(
                title: Text("Filter Site"),
                content: Container(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                      itemCount: sites.length,
                      itemBuilder: (context, i) {

                        final name = sites[i].get('name');
                        final type = sites[i].get('type');

                        return ListTile(
                          title: Text("$name ($type)"),
                          onTap: () {
                            displaySite = "$name ($type)";
                            Navigator.pop(context, name);
                            setState((){
                            });
                          },
                        );
                      }),
                ),
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

    }, icon: Icon(
        color: Colors.orange,
        Icons.content_paste_search_sharp));
  }

  graphs() {
    final sections = [
      PieChartSectionData(
          color: Colors.orange,
          value: 20),
      PieChartSectionData(
          color: Colors.orangeAccent,
          value: 80)
    ];

    return Container(
      height: 200,
      width: 200,
      child: PieChart(
          duration: Duration(seconds: 2),
          curve: Curves.bounceIn,
          PieChartData(
              pieTouchData: PieTouchData(
                  enabled: true
              ),
              sections: sections
          )
      ),
    );
  }
}
