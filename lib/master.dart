import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'OrderPayment.dart';
import 'TestPayment.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZaloPay Integration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TestPaymentPage(),
    );
  }
}
