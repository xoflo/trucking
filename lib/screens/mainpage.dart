import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trucking/screens/subscreens/driverscreen.dart';
import 'package:trucking/screens/subscreens/homescreen.dart';
import 'package:trucking/screens/subscreens/reportscreen.dart';
import 'package:trucking/screens/subscreens/sitescreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.userAccount});

  final DocumentReference<Map<String, dynamic>> userAccount;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int screenNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              titleBar(),
              Divider(),
              screenHandler(screenNumber)
            ],
          ),
        ),
      ),
    );
  }

  titleBar() {
    return Row(
      children: [
        Container(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(titleHandler(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30)),
          ),
        ),
        Spacer(),
        MediaQuery.of(context).size.width < 700 ? Container() : Text("Trip Ticket Tracker", style: TextStyle(fontSize: 20)),
        Spacer(),
        titleNavigator(),
      ],
    );
  }

  titleHandler() {
    if (screenNumber == 1) {
      return "Home";
    }

    if (screenNumber == 2) {
      return "Drivers";
    }

    if (screenNumber == 3) {
      return "Sites";
    }

    if (screenNumber == 4) {
      return "Reports";
    }
  }

  screenHandler(int type) {
    if (type == 1) {
      return HomeScreen(userAccount: widget.userAccount);
    }

    if (type == 2) {
      return DriverScreen(userAccount: widget.userAccount);
    }

    if (type == 3) {
      return SiteScreen(userAccount: widget.userAccount);
    }

    if (type == 4) {
      return ReportScreen(userAccount: widget.userAccount);
    }
  }

  titleNavigator() {
    return Row(
      children: [
        IconButton(onPressed: () => changeScreen(1), icon: Icon(Icons.house, color: titleIconColor(1))),
        IconButton(onPressed: () => changeScreen(2), icon: Icon(Icons.person, color: titleIconColor(2))),
        IconButton(onPressed: () => changeScreen(3), icon: Icon(Icons.place, color: titleIconColor(3))),
        IconButton(onPressed: () => changeScreen(4), icon: Icon(Icons.library_books_outlined, color: titleIconColor(4)))
      ],
    );
  }

  changeScreen(int type) {
    if (type == 1) {
      screenNumber = 1;
      // HomeScreen
      setState(() {});
    }

    if (type == 2) {
      screenNumber = 2;
      // DriverScreen
      setState(() {});
    }

    if (type == 3) {
      screenNumber = 3;
      // LocationScreen
      setState(() {});
    }

    if (type == 4) {
      screenNumber = 4;
      // LocationScreen
      setState(() {});
    }
  }

  titleIconColor(int type) {

    final selected = Colors.orange;
    final unselected = Colors.black87;

    if (type == 1) {
      if (screenNumber == 1) {
        return selected;
      } else {
        return unselected;
      }
    }

    if (type == 2) {
      if (screenNumber == 2) {
        return selected;
      } else {
        return unselected;
      }
    }

    if (type == 3) {
      if (screenNumber == 3) {
        return selected;
      } else {
        return unselected;
      }
    }

    if (type == 4) {
      if (screenNumber == 4) {
        return selected;
      } else {
        return unselected;
      }
    }

  }
}

loadWidget(double size) {
  return Center(
    child: Container(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: Colors.orange,
      ),
    ),
  );
}
