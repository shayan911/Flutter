import 'package:flutter/material.dart';
import 'package:untitled/Home.dart';
import 'package:untitled/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/register.dart';
import 'package:untitled/register.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter demo",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: login(),
      routes: {
        "/login": (context) => login(),
        "/register": (context) => register(),
        "/home": (context) => Home()
      },
    );
  }
}
