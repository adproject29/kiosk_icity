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
  final String uuid;
  final int accID;

  const LoadingScreen({
    super.key,
    required this.username,
    required this.balance,
    required this.qrData,
    required this.uuid,
    required this.accID,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    void redirectAfterDelay() async {
      await Future.delayed(const Duration(seconds: 2));
      try {
        final response = await http.get(Uri.parse(
            'http://localhost/icitywebapi/api/kiosk/GetAccDetails?strData=$qrData'));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          print('Response JSON: $jsonData');

          if (jsonData['Content'] != null && jsonData['Content'].isNotEmpty) {
            String userName = jsonData['Content'][0]['UserName'];
            int accID = jsonData['Content'][0]['AccID'];
            dynamic balanceData = jsonData['Content'][0]['Balance'];
            double balance;

            if (balanceData is double) {
              balance = balanceData;
            } else {
              balance = 0;
              print('Error: Unexpected data type for balance');
            }

            Navigator.of(context).pushReplacement(PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) {
                return Reload(
                  username: userName,
                  balance: balance,
                  accID: accID,
                  uuid: uuid,
                  qrData: qrData,
                );
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ));
          } else {
            print('Empty or unexpected response: $jsonData');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => QRError(uuid: uuid),
            ));
          }
        } else {
          print('API call failed with status code: ${response.statusCode}');
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => QRError(uuid: uuid),
          ));
        }
      } catch (error) {
        print('API Error: $error');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => QRError(uuid: uuid),
        ));
      }
    }

    redirectAfterDelay();

    return AppTheme.buildPage(
      context: context,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(100),
          width: screenSize.width - 200,
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
