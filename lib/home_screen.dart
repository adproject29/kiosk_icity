import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/pages/scan_qr.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
      context: context,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 200,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    _navigateToScanQr(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(75, 88, 59, 117),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(7, 0, 0, 14),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/images/icity_super_app_logo.png',
                              ),
                            ),
                          ),
                          width: 500,
                          height: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                          width: 800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                margin:
                                    const EdgeInsets.fromLTRB(0, 13.5, 0, 13.5),
                                width: 122,
                                height: 122,
                                child: SvgPicture.asset(
                                  'assets/vectors/mastercard.svg',
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(44, 0, 0, 0.5),
                                width: 122,
                                height: 122,
                                child: SvgPicture.asset(
                                  'assets/images/contactless_icon.svg',
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _navigateToScanQr(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFF107F00),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  offset: Offset(0, 4),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            padding:
                                const EdgeInsets.fromLTRB(67, 120, 67, 500),
                            child: const Text(
                              'Reload i-City SuperApp Credit',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 80,
                                color: Color(0xFFF2F3F4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: 300,
                child: GestureDetector(
                  onTap: () {
                    _navigateToScanQr(context);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/doble_click.gif',
                        ),
                      ),
                    ),
                    width: 475,
                    height: 475,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToScanQr(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ScanQr(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
