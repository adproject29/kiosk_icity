import 'package:flutter/material.dart';
import 'package:flutter_app/home_screen.dart';
import 'package:flutter_app/pages/loading_uuid.dart';
import 'package:flutter_app/pages/payment_success.dart';
import 'package:flutter_app/pages/terminal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: HomeScreen(),

      // home: Terminal(
      //     amount: 2,
      //     uuid: 'uuid',
      //     accID: 0,
      //     username: 'username',
      //     balance: 0.0,
      //     qrData: 'qrData')
      home: LoadingUUID(),
      // home: PaymentSuccess(
      //     amount: 2,
      //     uuid: 'uuid',
      //     accID: 0,
      //     username: 'username',
      //     balance: 0.0,
      //     qrData: 'qrData')
      //home: Example(),
    );
  }
}
