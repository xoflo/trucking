import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Driver {
  String? name;
  String? contact;
  String? address;

  Driver(this.name, this.contact, this.address);

  addToFirebase(DocumentReference<Map<String, dynamic>> userAccount) async {
    await userAccount.collection('drivers').add({
      'name': this.name,
      'contact': this.contact,
      'address': this.address,
    });

    return "1";
  }

  Driver.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    this.name = data.get('name');
    this.contact = data.get('contact');
    this.address = data.get('address');
  }

}