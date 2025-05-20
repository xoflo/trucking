
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trucking/models/site.dart';
import 'package:trucking/screens/mainpage.dart';

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

    int type = 0;
    String displayType = "Select";
    final siteTypes = widget.userAccount.collection('sitetypes');
    
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return AlertDialog(
          title: Text("${i == 2? 'Edit' : 'Add'} Site"),
          content: Container(
            height: 300,
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
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: siteDistance,
                    decoration: const InputDecoration(
                        hintText: 'Distance in KM'
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Text("Site Type: $displayType"),
                    ),
                  ),

                  StreamBuilder(stream: siteTypes.snapshots(), builder: (context, snapshot) {
                    final siteTypesRef = snapshot.data!.docs;
                    final length = siteTypesRef.length;

                    return Container(
                      height: 50,
                      width: 365,
                      child: snapshot.connectionState == ConnectionState.active ?  length != 0 ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                          itemCount: length,
                          itemBuilder: (context, i) {
                        final typeName = siteTypesRef[i].get('name');

                        return  Container(
                            height: 50,
                            width: 100,
                            child: GestureDetector(
                              onTap: () {
                                type = i;
                                displayType = typeName;
                                siteTypeName = typeName;
                                setState((){

                                });
                              },
                              child: Card(
                                child: Center(child: Text(typeName, style: TextStyle(color: Colors.white))),
                                color: siteTypeColorHandler(i, type),
                              ),
                            ));
                      }) : Center(
                        child: Text("No Site types", style: TextStyle(color: Colors.grey)),
                      ) : loadWidget(20),
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
                  try {
                    double.parse(siteDistance.text);
                    siteToFirebase();
                  } catch(e) {
                    print(e);
                  }
                })
          ],
        );
      },
    );
  }

  siteToFirebase() async {
    final result = await Site(siteName.text, siteAddress.text, siteTypeName, double.parse(siteDistance.text)).addToFirebase(widget.userAccount);

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

    final siteTypes = widget.userAccount.collection('sitetypes');

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
                              hintText: 'Site Type to Add'
                          ),
                        )),
                    IconButton(onPressed: () async {
                      if (siteTypeNameAdd.text != "") {
                        await siteTypes.add({
                          'name': siteTypeNameAdd.text
                        }).then((value) {
                          siteTypeNameAdd.clear();
                          setState(() {});
                        });
                      }
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
                  child: Container(
                    height: 250,
                    child: StreamBuilder(stream: siteTypes.snapshots(), builder: (context, snapshot) {
                      final siteTypesRef = snapshot.data!.docs;

                      return snapshot.connectionState == ConnectionState.active ? siteTypesRef.length != 0 ? ListView.builder(
                          itemCount: siteTypesRef.length,
                          itemBuilder: (context, i) {
                            final type = siteTypesRef[i];

                            return ListTile(
                              trailing: IconButton(onPressed: () async {
                                await type.reference.delete();
                                setState((){

                                });
                              }, icon: Icon(Icons.remove)),
                              title: Text(type.get("name")),
                            );
                          }) : Center(
                        child: Text("No Added Site Types", style: TextStyle(color: Colors.grey)),
                      ) : loadWidget(30);
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  
  siteTypeColorHandler(int index, int type) {

    if (index == type) {
      return Colors.orange;
    } else {
      return Colors.grey;
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
            }) : loadWidget(100);
      }),
    );
  }


  deletePrompt(QueryDocumentSnapshot<Map<String, dynamic>> site) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Delete Site?"),
      content: Container(
        height: 20,
        width: 100,
        child: Text("Site will be lost forever. Tickets with this site will not be affected."),
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
