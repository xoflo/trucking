import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Driver {
  String? name;
  String? contact;
  String? address;
  double? regularRate;
  double? incentiveRate;

  Driver(this.name, this.contact, this.address, this.regularRate, this.incentiveRate);

  addToFirebase(DocumentReference<Map<String, dynamic>> userAccount) async {
    await userAccount.collection('drivers').add({
      'name': this.name,
      'contact': this.contact,
      'address': this.address,
      'regularRate': this.regularRate,
      'incentiveRate': this.incentiveRate,
    });

    return "1";
  }

  Driver.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    this.name = data.get('name');
    this.contact = data.get('contact');
    this.address = data.get('address');
    this.regularRate = data.get('regularRate');
    this.incentiveRate = data.get('incentiveRate');
  }

}