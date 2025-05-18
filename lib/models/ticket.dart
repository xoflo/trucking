
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucking/models/driver.dart';
import 'package:trucking/models/site.dart';

class Ticket {
  String? epdc;
  String? mmdc;
  String? date;
  String? loadedBy;
  DateTime? timeLoaded;
  String? loadChecker;
  String? loadOperator;
  String? hauledBy;
  String? driver;
  String? receivedBy;
  DateTime? timeReceived;
  String? receiveOperator;
  String? receiveChecker;
  String? material;
  String? activity;
  String? site;
  String? destination;

  double? driverIncentiveRate;
  double? siteDistance;

  Ticket(this.epdc, this.mmdc, this.date, this.loadedBy, this.timeLoaded, this.loadChecker, this.loadOperator, this.hauledBy,
      this.driver, this.receivedBy, this.timeReceived, this.receiveOperator, this.receiveChecker,
      this.material, this.activity, this.site, this.destination, {this.driverIncentiveRate, this.siteDistance});

  toFirebase(DocumentReference<Map<String, dynamic>> userAccount) async {
    await userAccount.collection('tickets').add({
      'epdc': this.epdc,
      'mmdc': this.mmdc,
      'date': this.date,
      'loadedBy': this.loadedBy,
      'timeLoaded': this.timeLoaded,
      'loadChecker': this.loadChecker,
      'loadOperator': this.loadOperator,
      'hauledBy': this.hauledBy,
      'driver': this.driver,
      'receivedBy': this.receivedBy,
      'timeReceived': this.timeReceived,
      'receiveOperator': this.receiveOperator,
      'receiveChecker': this.receiveChecker,
      'material': this.material,
      'activity': this.activity,
      'site': this.site,
      'destination': this.destination,
      'driverIncentiveRate': this.driverIncentiveRate,
      'siteDistance': this.siteDistance,
    });

    return 1;
  }

  Ticket.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    this.epdc = data.get('epdc');
    this.mmdc = data.get('mmdc');
    this.date = data.get('date');
    this.loadedBy = data.get('loadedBy');
    this.timeLoaded = data.get('timeLoaded').toDate();
    this.loadChecker = data.get('loadChecker');
    this.loadOperator = data.get('loadOperator');
    this.hauledBy = data.get('hauledBy');
    this.driver = data.get('driver');
    this.receivedBy = data.get('receivedBy');
    this.timeReceived= data.get('timeReceived').toDate();
    this.receiveOperator = data.get('receiveOperator');
    this.receiveChecker = data.get('receiveChecker');
    this.material = data.get('material');
    this.activity= data.get('activity');
    this.site = data.get('site');
    this.destination = data.get('destination');
  }
}