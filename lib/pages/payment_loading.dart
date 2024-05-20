import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentLoading extends StatelessWidget {
  const PaymentLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF2F3F4),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -279,
            top: 1266,
            child: Opacity(
              opacity: 0.3,
              child: SizedBox(
                width: 1452,
                height: 817,
                child: SvgPicture.asset(
                  'assets/vectors/ferriswheel_9_x2.svg',
                ),
              ),
            ),
          ),
          Positioned(
            top: 228,
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
              child: const SizedBox(
                width: 850,
                height: 1518,
              ),
            ),
          ),
    SizedBox(
            width: 1080,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 666, 0, 768),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/ferris_wheel_91.gif',
                          ),
                        ),
                      ),
                      child: const SizedBox(
                        width: 406,
                        height: 406,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 31, 0),
                    child: Text(
                      'Verifying...',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w300,
                        fontSize: 40,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}