import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/payment_error.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/pages/payment_success.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:flutter_app/app_theme.dart';

class Terminal extends StatefulWidget {
  final String username;
  final double balance;
  final double amount;
  final String uuid;
  final int accID;
  final String qrData;

  const Terminal({
    super.key,
    required this.username,
    required this.balance,
    required this.amount,
    required this.uuid,
    required this.accID,
    required this.qrData,
  });

  @override
  _TerminalState createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _navigateToPaymentError();
        }
      });

    _animationController.forward();

    sendcmdtoCC();
  }

  Future<void> sendcmdtoCC() async {
    try {
      String fullUUID = widget.uuid;
      print('Total :${widget.amount}');
      print('UUID: ${widget.uuid}');
      print('Acc ID :${widget.accID}');
      print('QR ID :${widget.qrData}');
// Construct the URL
      String url =
          'http://localhost/iCityWebAPI/api/kiosk/sendCmdToCC?total=${widget.amount}&accID=${widget.accID}&uuid=${widget.uuid}';

      // Print the URL to debug
      print('URL: $url');
      final dio = Dio();
      final response = await dio.get(
          'http://localhost/iCityWebAPI/api/kiosk/sendCmdToCC?total=${widget.amount}&accID=${widget.accID}&uuid=$fullUUID');

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        // Navigate to PaymentSuccess page upon successful response
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccess(
              amount: widget.amount,
              username: widget.username,
              balance: widget.balance,
              uuid: widget.uuid,
              accID: widget.accID,
              qrData: widget.qrData,
            ),
          ),
        );
        _animationController.stop();
      } else {
        print(
            'Failed to fetch data from remote service. Status code: ${response.statusCode}');
        // Navigate to PaymentError page upon unsuccessful response
        _navigateToPaymentError();
      }
    } catch (e) {
      print('Error fetching data from remote service: $e');
      print('${widget.uuid}');
      // Navigate to PaymentError page in case of any error
      _navigateToPaymentError();
    }
  }

  void _navigateToPaymentError() {
    _animationController.stop(); // Stop the animation controller
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentError(
          amount: widget.amount,
          username: widget.username,
          balance: widget.balance,
          uuid: widget.uuid,
          accID: widget.accID,
          qrData: widget.qrData,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
      context: context,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(seconds: 1),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Reload(
                        username: widget.username,
                        balance: widget.balance,
                        uuid: widget.uuid,
                        accID: widget.accID,
                        qrData: widget.qrData,
                      );
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
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(55, 200, 55, 746),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 44, 0),
                          width: 149,
                          height: 149,
                          child: SvgPicture.asset(
                            'assets/vectors/visa.svg',
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 13.5, 0, 13.5),
                          width: 122,
                          height: 122,
                          child: SvgPicture.asset(
                            'assets/vectors/mastercard.svg',
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(44, 0, 0, 0.5),
                          width: 122,
                          height: 122,
                          child: SvgPicture.asset(
                            'assets/images/contactless_icon.svg',
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'WAVE YOUR CARD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 100,
                        color: Color(0xFFF36F21),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 40, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20),
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              int secondsLeft = 50 -
                                  (_animationController.value * 50).floor();
                              return Text(
                                '  $secondsLeft s',
                                style: TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 100,
            bottom: -200,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/arrow_down_1.gif',
                  ),
                ),
              ),
              child: const SizedBox(
                width: 822,
                height: 854,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
