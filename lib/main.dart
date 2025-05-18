import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trucking/screens/loginpage.dart';
import 'firebase_options.dart';


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch
      }),
      debugShowCheckedModeBanner: false,
      title: 'trucking',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
