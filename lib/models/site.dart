import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Site {
  String? name;
  String? address;
  String? type;

  addToFirebase(DocumentReference<Map<String, dynamic>> userAccount) async {
    final users = FirebaseFirestore.instance.collection('users');

    await userAccount
        .collection('sites')
        .add({'name': this.name, 'address': this.address, 'type': this.type});

    return 1;
  }

  fromFirebase(dynamic data) {
    this.name = data['name'];
    this.address = data['address'];
    this.type = data['type'];
  }
}
