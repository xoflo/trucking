
import 'package:trucking/models/driver.dart';
import 'package:trucking/models/site.dart';

class Ticket {
  String? epdc;
  String? mmdc;
  String? date;
  String? loadedBy;
  String? timeLoaded;
  String? loadOperator;
  String? hauledBy;
  Driver? driver;
  String? receivedBy;
  String? timeReceived;
  String? receiveOperator;
  String? checker;
  String? material;
  String? activity;
  Site? site;
  String? destination;

  Ticket(this.epdc, this.mmdc, this.date, this.loadedBy, this.timeLoaded, this.loadOperator, this.hauledBy,
      this.driver, this.receivedBy, this.timeReceived, this.receiveOperator, this.checker,
      this.material, this.activity, this.site, this.destination);
}