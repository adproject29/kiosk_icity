import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/loading_uuid.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/app_theme.dart';

class PaymentError extends StatefulWidget {
  final double amount;
  final String username;
  final double balance;
  final String uuid;
  final int accID;
  final String qrData;

  const PaymentError({
    super.key,
    required this.amount,
    required this.username,
    required this.balance,
    required this.uuid,
    required this.accID,
    required this.qrData,
  });

  @override
  _PaymentErrorState createState() => _PaymentErrorState();
}

class _PaymentErrorState extends State<PaymentError> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 10),
      () {
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

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: AppTheme.buildPage(
        context: context,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/cross_mark.gif',
                      ),
                    ),
                  ),
                  child: const SizedBox(
                    width: 522,
                    height: 535,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 383),
                child: Text(
                  'Payment Error',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 48,
                    color: const Color(0xFFFC3239),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoadingUUID(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFC3239)),
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFFFFFFF),
                      ),
                      width: 742,
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 37),
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                          color: const Color(0xFFFC3239),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Reload(
                        username: widget.username,
                        balance: widget.balance,
                        uuid: widget.uuid,
                        accID: widget.accID,
                        qrData: widget.qrData,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFFC3239),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40000000),
                            offset: Offset(0, 4),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      width: 742,
                      padding: const EdgeInsets.fromLTRB(2, 30, 0, 38),
                      child: Text(
                        'Try again',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
