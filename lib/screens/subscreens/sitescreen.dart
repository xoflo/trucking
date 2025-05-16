import 'package:flutter/material.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key});

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {


  TextEditingController siteName = TextEditingController();
  TextEditingController siteAddress = TextEditingController();

  TextEditingController siteTypeName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          addSiteButton(),
          siteListView()
        ],
      ),
    );
  }

  addSiteButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              ElevatedButton(onPressed: () {
                showDialog(context: context, builder: (_) => addSiteDialog());
              }, child: Text("+ Site")),
              SizedBox(width: 15),
              ElevatedButton(onPressed: () {
                showDialog(context: context, builder: (_) => siteTypeDialog());
              }, child: Text("+ Site Type")),
            ],
          )),
    );
  }

  addSiteDialog() {
    
    int type = 1;
    
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return AlertDialog(
          title: Text("Add Site"),
          content: Container(
            height: 320,
            width: 400,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    controller: siteName,
                    decoration: InputDecoration(
                        hintText: 'Site Name'
                    ),
                  ),
                  TextField(
                    controller: siteAddress,
                    decoration: InputDecoration(
                        hintText: 'Address'
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Text("Site Type:"),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                          height: 50,
                          width: 100,
                          child: GestureDetector(
                            onTap: () {
                              type = 1;
                              setState(() {

                              });
                            },
                            child: Card(
                              child: Center(child: Text("Hustling", style: TextStyle(color: Colors.white))),
                              color: siteTypeColorHandler(1, type),
                            ),
                          )),
                      Container(
                          height: 50,
                          width: 100,
                          child: GestureDetector(
                            onTap: () {
                              type = 2;
                              setState(() {

                              });
                            },
                            child: Card(
                              child: Center(child: Text("Mining", style: TextStyle(color: Colors.white))),
                              color: siteTypeColorHandler(2, type),
                            ),
                          )),

                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Text("Added Site Types:"),
                    ),
                  ),

                  StreamBuilder(stream: null, builder: (context, snapshot) {

                    int i = 2;

                    return Container(
                      height: 50,
                      width: 250,
                      child: i == 1 ? ListView.builder(itemBuilder: (context, i) {
                        return  Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            height: 50,
                            width: 100,
                            child: GestureDetector(
                              onTap: () {

                              },
                              child: Card(
                                child: Center(child: Text("Hustling", style: TextStyle(color: Colors.white))),
                                color: siteTypeColorHandler(1, type),
                              ),
                            ));
                      }) : Center(
                        child: Text("No Added Types"),
                      ),
                    );
                  }),


                ],
              ),
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.check_circle),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Site Added")));

                })
          ],
        );
      },
    );
  }

  siteTypeDialog() {
    int i = 2;

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return AlertDialog(
          title: Text("Site Types"),
          content: Container(
            height: 400,
            width: 400,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        height: 60,
                        width: 350,
                        child: TextField(
                          controller: siteTypeName,
                          decoration: InputDecoration(
                              hintText: 'Type Name to Add'
                          ),
                        )),
                    IconButton(onPressed: () {

                      setState(() {

                      });
                    }, icon: Icon(
                        color: Colors.orange,
                        Icons.add_circle_outlined))
                  ],
                ),

                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Site Types:")),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: StreamBuilder(stream: null, builder: (context, snapshot) {
                    return i == 1 ? ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text("test"),
                          );
                        }) : Center(
                      child: Text("No Added Site Types", style: TextStyle(color: Colors.grey)),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  
  siteTypeColorHandler(int index, int type) {
    if (index == 1) {
      if (type == 1) {
        return Colors.orange;
      } else {
        return Colors.grey;
      }
    }

    if (index == 2) {
      if (type == 2) {
        return Colors.orange;
      } else {
        return Colors.grey;
      }
    }
  }

  siteListView() {
    int i = 1;

    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
      height: 600,
      child: StreamBuilder(stream: null, builder: (context, snapshot) {
        return i == 1 ? Center(
          child: Text("No Sites Found", style: TextStyle(color: Colors.grey)),
        ) : ListView.builder(
            itemCount: 2,
            itemBuilder: (context, i) {
              return ListTile(
                onTap: () {

                },
                title: Text("Site"),
              );
            });
      }),
    );
  }
}
