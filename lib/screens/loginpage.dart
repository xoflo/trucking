import 'package:flutter/material.dart';
import 'package:trucking/screens/mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool seePassword = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: 800,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  title(),
                  loginInfo(),
                  submission()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  passwordIcon() {
    if (seePassword == false) {
      return Icon(Icons.visibility);
    } else {
      return Icon(Icons.visibility_off);
    }
  }

  title() {
    return
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text("Trip Ticket Tracker", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45)),
      );
  }

  loginInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 250,
                child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Username'
                    ),
                    controller: username)),
            SizedBox(width: 40)
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 250,
                child: TextField(
                    obscureText: seePassword,
                    decoration: InputDecoration(
                        hintText: 'Password'
                    ),
                    controller: password)),
            IconButton(onPressed: () {
              seePassword = !seePassword;
              setState(() {

              });
            }, icon: passwordIcon())
          ],
        ),
      ],
    );
  }

  submission() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: ElevatedButton(
          onPressed: () async {
            final result = await verifyFirebase();

            if (result == true) {


              final users = FirebaseFirestore.instance.collection('users');

              final userAccount = await users.where('username', isEqualTo: username.text).where('password', isEqualTo: password.text).snapshots().first.then((value){
                final accountRef = users.doc(value.docs[0].id);
                return accountRef;
              });

              Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage(userAccount: userAccount)));
            }

            if (result == false) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Account")));
            }

            if (result == 1) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Went Wrong")));
            }

          }, child: Text("Sign-in")),
    );
  }

  verifyFirebase() async {

    try {

      final users = await firestore.collection('users').where('username', isEqualTo: username.text).where('password', isEqualTo: password.text).snapshots().first;
      final result = users.docs.length;

      if (result > 0) {
        return true;
      }

      if (result == 0) {
        return false;
      }

    } catch(e) {
      print(e);
    }

  }
}
