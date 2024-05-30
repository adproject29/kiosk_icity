import 'package:flutter/material.dart';
import 'package:flutter_app/pages/loading_uuid.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/app_theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class PaymentSuccess extends StatefulWidget {
  final double amount;
  final String username;
  final double balance;
  final String uuid;
  final int accID;
  final String qrData;

  const PaymentSuccess({
    super.key,
    required this.amount,
    required this.uuid,
    required this.accID,
    required this.username,
    required this.balance,
    required this.qrData,
  });

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  double _currentBalance = 0.0;
  late Timer _redirectTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _redirectTimer = Timer(
      const Duration(seconds: 20),
      () {
        if (!_isDisposed) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) {
                return const LoadingUUID();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(-1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _redirectTimer.cancel();
    super.dispose();
  }

  Future<void> _fetchBalance() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost/icitywebapi/api/kiosk/GetAccDetails?strData=${widget.qrData}',
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['Content'] != null && jsonData['Content'].isNotEmpty) {
          dynamic balanceData = jsonData['Content'][0]['Balance'];
          double balance;

          if (balanceData is double) {
            balance = balanceData;
          } else if (balanceData is int) {
            balance = balanceData.toDouble();
          } else {
            balance = 0;
            print('Error: Unexpected data type for balance');
          }

          setState(() {
            _currentBalance = balance;
          });
        } else {
          throw Exception('Empty or unexpected response');
        }
      } else {
        throw Exception('Failed to load balance');
      }
    } catch (error) {
      print('API Error: $error');
      print('${widget.accID}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: AppTheme.buildPage(
        context: context,
        child: Stack(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 17, 20),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/approve_1.gif',
                          ),
                        ),
                      ),
                      child: const SizedBox(
                        width: 513,
                        height: 513,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 13, 13),
                    child: Text(
                      'RM ${widget.amount.toStringAsFixed(0)}.00 ',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 64,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 19, 40),
                    child: Text(
                      'Reloaded',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w300,
                        fontSize: 32,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 19, 324),
                    child: Text(
                      'Receipt have been sent to your email',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w300,
                        fontSize: 32,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(130, 0, 21.2, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 19, 14.9, 5),
                          child: Text(
                            'Your New Credit Balance :',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 32,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ),
                        Text(
                          'RM $_currentBalance',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 48,
                            color: const Color(0xFFF36F21),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return Reload(
                                  username: widget.username,
                                  balance: widget.balance,
                                  uuid: widget.uuid,
                                  accID: widget.accID,
                                  qrData: widget.qrData,
                                );
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(-1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                          _redirectTimer.cancel(); // Stop timer
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(
                              color: Color(0xFF4CAF50), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 30, 10, 38),
                          child: Text(
                            'Reload More',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 40,
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () {
                          _redirectTimer.cancel(); // Stop timer
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return const LoadingUUID();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(-1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                          shadowColor: const Color(0x40000000),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(70, 30, 70, 38),
                          child: Text(
                            'Finish',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 40,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
