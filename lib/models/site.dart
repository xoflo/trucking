import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Site {
  String? name;
  String? address;
  String? type;

  Site(this.name, this.address, this.type);

  addToFirebase(DocumentReference<Map<String, dynamic>> userAccount) async {

    await userAccount
        .collection('sites')
        .add({'name': this.name, 'address': this.address, 'type': this.type});

    return 1;
  }


  Site.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    this.name = data.get('name');
    this.address = data.get('address');
    this.type = data.get('type');
  }
}
