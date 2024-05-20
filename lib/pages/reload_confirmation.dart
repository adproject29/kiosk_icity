import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ReloadConfirmation extends StatelessWidget {
  const ReloadConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                child: SvgPicture.asset(
                  'assets/vectors/ferriswheel_4_x2.svg',
                  width: 1452,
                  height: 817,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 1080,
                padding: const EdgeInsets.symmetric(vertical: 228),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
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
                      width: 850,
                      padding:
                          const EdgeInsets.symmetric(vertical: 213, horizontal: 2.9),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 151),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'SCAN YOUR\nQR',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 100,
                                      color: const Color(0xFFF36F21),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: SvgPicture.asset(
                                  'assets/vectors/group_2_x2.svg',
                                  width: 305.1,
                                  height: 561,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            left: 131.1,
                            top: 147,
                            child: Image.asset(
                              'assets/images/icity_super_app_logo_cs_61.png',
                              width: 572,
                              height: 134,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 92,
                      child: Image.asset(
                        'assets/images/arrow_down_111.gif',
                        width: 678,
                        height: 763,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
