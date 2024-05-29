import 'package:flutter/material.dart';
import 'package:flutter_app/pages/payment_success.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/app_theme.dart';
import 'payment_error.dart';

class Terminal extends StatelessWidget {
  final String username;
  final double balance;
  final double amount;

  const Terminal({
    super.key,
    required this.username,
    required this.balance,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
      context: context, // Include inactivity timer
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
                        username: username,
                        balance: balance,
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
                padding: const EdgeInsets.fromLTRB(55, 45, 55, 746),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 57),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFFFFFFFF),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40000000),
                                offset: Offset(0, 4),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return Reload(
                                      username: username,
                                      balance: balance,
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
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              padding:
                                  const EdgeInsets.fromLTRB(20, 35, 33, 34),
                              child: SizedBox(
                                width: 43,
                                height: 81,
                                child: SvgPicture.asset(
                                  'assets/vectors/arrow_back.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentSuccess(
                                    amount: amount,
                                    username: username,
                                    balance: balance,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Success Cheat'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentError(
                                    amount: amount,
                                    username: username,
                                    balance: balance,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Fail Cheat'),
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
