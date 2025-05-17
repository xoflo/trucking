import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trucking/models/site.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key, required this.userAccount});

  final DocumentReference<Map<String, dynamic>> userAccount;

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {


  TextEditingController siteName = TextEditingController();
  TextEditingController siteAddress = TextEditingController();
  TextEditingController siteDistance = TextEditingController();
  String siteTypeName = "Mining";


  TextEditingController siteTypeNameAdd = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addSiteButton(),
        siteListView()
      ],
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
                showDialog(context: context, builder: (_) => siteDialog(1));
              }, child: const Text("+ Site")),
              const SizedBox(width: 15),
              ElevatedButton(onPressed: () {
                showDialog(context: context, builder: (_) => siteTypeDialog());
              }, child: const Text("+ Site Type")),
            ],
          )),
    );
  }

  siteDialog(int i, {QueryDocumentSnapshot<Map<String, dynamic>>? site}) {
    
    int type = 1;
    
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return AlertDialog(
          title: Text("${i == 2? 'Edit' : 'Add'} Site"),
          content: Container(
            height: 365,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    controller: siteName,
                    decoration: const InputDecoration(
                        hintText: 'Site Name'
                    ),
                  ),
                  TextField(
                    controller: siteAddress,
                    decoration: const InputDecoration(
                        hintText: 'Address'
                    ),
                  ),

                  TextField(
                    controller: siteDistance,
                    decoration: const InputDecoration(
                        hintText: 'Distance'
                    ),
                  ),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Text("Site Type:"),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: 50,
                          width: 100,
                          child: GestureDetector(
                            onTap: () {
                              type = 1;
                              siteTypeName = 'Hustling';
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
                              siteTypeName = 'Mining';
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
                icon: Icon(
                    color: Colors.orange,
                    Icons.check_circle),
                onPressed: () {
                  if (i == 2) {

                  } else {
                    siteToFirebase();
                  }
                })
          ],
        );
      },
    );
  }

  siteToFirebase() async {
    final result = await Site(siteName.text, siteAddress.text, siteTypeName).addToFirebase(widget.userAccount);

    if (result == 1) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Site Added")));
      clearSiteFields();
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Went Wrong")));
      clearSiteFields();
    }

  }
  
  clearSiteFields() {
    siteName.clear();
    siteAddress.clear();
    siteTypeName = "";
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
                          controller: siteTypeNameAdd,
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
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: StreamBuilder(stream: null, builder: (context, snapshot) {
                    return i == 1 ? ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, i) {
                          return const ListTile(
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
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
      height: 600,
      child: StreamBuilder(stream: widget.userAccount.collection('sites').snapshots(), builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.active ?
            snapshot.data!.docs.length == 0 ?
        Center(
          child: Text("No Sites Found", style: TextStyle(color: Colors.grey)),
        ) : ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, i) {
              
              final site = snapshot.data!.docs[i];
              
              return ListTile(
                onTap: () {
                  siteDialog(2);
                },
                title: Text(site.get('name')),
                subtitle: Text("${site.get('type')} | ${site.get('address')}"),
                trailing: IconButton(onPressed: () async {
                  deletePrompt(site);
                }, icon: Icon(Icons.remove)),
              );
            }) : Center(
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


  deletePrompt(QueryDocumentSnapshot<Map<String, dynamic>> site) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Delete Site?"),
      content: Container(
        height: 20,
        width: 100,
        child: Text("Site will be lost forever."),
      ),
      actions: [
        TextButton(onPressed: () async {
          try {
            await site.reference.delete();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Site Deleted")));
          } catch(e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Went Wrong")));
          }
        }, child: Text("Confirm Delete", style: TextStyle(color: Colors.red)))
      ],
    ));
  }
}
