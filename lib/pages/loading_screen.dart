import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:flutter_app/pages/qr_error.dart';

class LoadingScreen extends StatelessWidget {
  final String username;
  final double balance;
  final String qrData;

  LoadingScreen({
    required this.username,
    required this.balance,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Call redirect function after a delay
    void redirectAfterDelay() {
      Future.delayed(const Duration(seconds: 2), () async {
        try {
          // Make API call
          final response = await http.get(Uri.parse(
              'http://10.110.212.188/kioskAPI/api/kiosk/GetAccDetails?strData=$qrData'));

          // Check if API call is successful or not
          if (response.statusCode == 200) {
            // Parse response data
            final jsonData = jsonDecode(response.body);
            if (jsonData['Content'] != null && jsonData['Content'].isNotEmpty) {
              // Extract username and balance
              String userName = jsonData['Content'][0]['UserName'];
              dynamic balanceData = jsonData['Content'][0]['Balance'];
              double balance;

              if (balanceData is String) {
                balance = double.tryParse(balanceData) ?? 0.0;
              } else if (balanceData is int) {
                balance = balanceData.toDouble();
              } else {
                balance = 0.0;
                // Handle unexpected data type
                print('Error: Unexpected data type for balance');
              }

              // Navigate to Reload page with the parsed data
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    Reload(username: userName, balance: balance),
              ));
            } else {
              // Navigate to QRError page if response is empty or unexpected
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => QRError(),
              ));
            }
          } else {
            // Navigate to QRError page on API call failure
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => QRError(),
            ));
          }
        } catch (error) {
          // Print the error
          print('API Error: $error');
          // Navigate to QRError page if an error occurs during API call
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => QRError(),
          ));
        }
      });
    }

    // Call redirect function
    redirectAfterDelay();

    return AppTheme.buildPage(
      context: context,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(100),
          width: screenSize.width - 200, // Adjusting width with margins
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(85, 88, 59, 117),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/ferris_wheel_loading.gif',
                          ),
                        ),
                      ),
                      child: const SizedBox(
                        width: 600,
                        height: 600,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 31, 0),
                      child: const Text(
                        'Verifying...',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 40,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
