import 'package:flutter/material.dart';
import 'package:trucking/screens/subscreens/homescreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
        child: Column(
          children: <Widget>[
            titleBar(),
            Divider(),
            screenHandler(screenNumber)
          ],
        ),
      ),
    );
  }

  titleBar() {
    return Row(
      children: [
        Container(
          width: 130,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(titleHandler(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30)),
          ),
        ),
        Spacer(),
        Text("Trip Ticket Tracker", style: TextStyle(fontSize: 20)),
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
  }

  screenHandler(int type) {
    if (type == 1) {
      return HomeScreen();
    }

    if (type == 2) {
      return Container();
    }

    if (type == 3) {
      return Container();
    }
  }

  titleNavigator() {
    return Row(
      children: [
        IconButton(onPressed: () => changeScreen(1), icon: Icon(Icons.house, color: titleIconColor(1))),
        IconButton(onPressed: () => changeScreen(2), icon: Icon(Icons.person, color: titleIconColor(2))),
        IconButton(onPressed: () => changeScreen(3), icon: Icon(Icons.place, color: titleIconColor(3)))
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


  }
}
