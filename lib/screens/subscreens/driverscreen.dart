import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trucking/models/driver.dart';
import 'package:trucking/screens/mainpage.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key, required this.userAccount});

  final DocumentReference<Map<String, dynamic>> userAccount;

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  TextEditingController driverName = TextEditingController();
  TextEditingController driverContact = TextEditingController();
  TextEditingController driverAddress = TextEditingController();
  TextEditingController regularRate = TextEditingController();
  TextEditingController incentiveRate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [addDriverButton(), driverListView()],
      ),
    );
  }

  addDriverButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
      child: Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (_) => driverDialog(1));
              },
              child: Text("+ Driver"))),
    );
  }

  driverDialog(int i) {
    return AlertDialog(
      title: Text("Add Driver"),
      content: Container(
        height: 300,
        width: 400,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: driverName,
                decoration: InputDecoration(hintText: 'Driver Name'),
              ),
              TextField(
                controller: driverContact,
                decoration: InputDecoration(hintText: 'Contact'),
              ),
              TextField(
                controller: driverAddress,
                decoration: InputDecoration(hintText: 'Address'),
              ),

              TextField(
                keyboardType: TextInputType.numberWithOptions(),
                controller: regularRate,
                decoration: InputDecoration(hintText: 'Regular Rate'),
              ),

              TextField(
                keyboardType: TextInputType.numberWithOptions(),
                controller: incentiveRate,
                decoration: InputDecoration(hintText: 'Incentive Rate (PHP per KM)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(color: Colors.orange, Icons.check_circle),
            onPressed: () async {
              await addDriverFirebase();
            })
      ],
    );
  }

  clearDriverFields() {
    driverAddress.clear();
    driverContact.clear();
    driverName.clear();
  }

  addDriverFirebase() async {
    final result =
        await Driver(driverName.text, driverContact.text, driverAddress.text, double.parse(regularRate.text), double.parse(incentiveRate.text))
            .addToFirebase(widget.userAccount);

    if (result == "1") {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Driver Added")));
      clearDriverFields();
    }

    if (result != "1") {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong")));
      clearDriverFields();
    }
  }

  driverListView() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
      height: 600,
      child: StreamBuilder(
          stream: widget.userAccount.collection('drivers').snapshots(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.active
                ? snapshot.data!.docs.length == 0
                    ? Center(
                        child: Text("No Drivers Found",
                            style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {

                          final driver = snapshot.data!.docs[i];

                          return ListTile(
                            onTap: () {
                              showDialog(context: context, builder: (_) => driverDialog(2));
                            },
                            title: Text(driver.get('name')),
                            subtitle: Text("${driver.get('contact')} | ${driver.get('address')}"),
                            trailing: IconButton(
                                tooltip: 'Delete',
                                onPressed: () {
                              deletePrompt(driver);
                            }, icon: Icon(Icons.remove)),
                          );
                        })
                : loadWidget(100);
          }),
    );
  }


  deletePrompt(QueryDocumentSnapshot<Map<String, dynamic>> driver) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Delete Driver?"),
      content: Container(
        height: 20,
        width: 100,
        child: Text("Driver will be lost forever. Tickets with this driver will not be affected."),
      ),
      actions: [
        TextButton(onPressed: () async {
          try {
            await driver.reference.delete();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Driver Deleted")));
          } catch(e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Went Wrong")));
          }
        }, child: Text("Confirm Delete", style: TextStyle(color: Colors.red)))
      ],
    ));
  }
}
