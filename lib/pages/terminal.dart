import 'package:flutter/material.dart';
import 'package:flutter_app/pages/payment_success.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/app_theme.dart';
import 'payment_error.dart';

class Terminal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
      // Use instance of AppTheme
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Reload page (push current page again)
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Reload()));
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
                              // Reload page (push current page again)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Reload()));
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
                    // Adding new children list here
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
                          margin: const EdgeInsets.fromLTRB(13.5, 0, 0, 0.5),
                          width: 122,
                          height: 122,
                          child: SvgPicture.asset(
                            'assets/images/wave_icon.svg',
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
                              // Navigate to success screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentSuccess()));
                            },
                            child: const Text('Success Cheat'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to PaymentError screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentError()));
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
