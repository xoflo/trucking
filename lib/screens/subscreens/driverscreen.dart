import 'package:flutter/material.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

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
        children: [
          addDriverButton(),
          driverListView()
        ],
      ),
    );
    
  }

  addDriverButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
      child: Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (_) => addDriverDialog());
            }, child: Text("+ Driver"))),
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
                decoration: InputDecoration(
                  hintText: 'Driver Name'
                ),
              ),
              TextField(
                controller: driverContact,
                decoration: InputDecoration(
                    hintText: 'Contact'
                ),
              ),
              TextField(
                controller: driverAddress,
                decoration: InputDecoration(
                    hintText: 'Address'
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(
                color: Colors.orange,
                Icons.check_circle),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Driver Added")));

        })
      ],
    );
  }

  addDriverFirebase() {

  }
  
  driverListView() {
    int i = 1;
    
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
      height: 600,
      child: StreamBuilder(stream: null, builder: (context, snapshot) {
        return i == 1 ? Center(
          child: Text("No Drivers Found", style: TextStyle(color: Colors.grey)),
        ) : ListView.builder(
            itemCount: 2,
            itemBuilder: (context, i) {
              return ListTile(
                onTap: () {
      
                },
                title: Text("Driver"),
              );
            });
      }),
    );
  }
}
