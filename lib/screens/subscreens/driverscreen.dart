import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trucking/models/driver.dart';

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
                showDialog(context: context, builder: (_) => addDriverDialog());
              },
              child: Text("+ Driver"))),
    );
  }

  addDriverDialog() {
    return AlertDialog(
      title: Text("Add Driver"),
      content: Container(
        height: 200,
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
        await Driver(driverName.text, driverContact.text, driverAddress.text)
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

                            },
                            title: Text(driver.get('name')),
                            subtitle: Text("${driver.get('contact')} | ${driver.get('address')}"),
                          );
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
          }),
    );
  }
}
