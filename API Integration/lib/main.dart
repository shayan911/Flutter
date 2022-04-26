import 'package:flutter/material.dart';
import 'package:untitled/api.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLutter demo',
      home: Scaffold(
        body: API(),
      ),
    );
  }
}
