import 'package:flutter/material.dart';
import 'package:flutter_app/home_screen.dart';
import 'package:flutter_app/pages/loading_failed.dart';
import 'package:flutter_app/pages/payment_success.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:flutter_app/pages/scan_qr.dart';
import 'package:flutter_app/pages/terminal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: Terminal(),
      //home: PaymentError(),
      home: HomeScreen(),
      //home: ScanQr(),
      //home: TextFieldExample(),
      //home: LoadingFailed(),
      //home: Terminal(),
      //home: Terminal(),
    );
  }
}
