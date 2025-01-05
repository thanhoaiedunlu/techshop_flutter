import 'package:flutter/material.dart';
import 'PaymentTest.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZaloPay Integration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PaymentTestPage(),
    );
  }
}
