import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getThemeData() {
    return ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: const Color(0xFFF36F21), // Default text color
        displayColor: Colors.black, // Default display text color
      ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Colors.blue, // Default button color
      //     foregroundColor: Colors.white, // Text color
      //   ),
      // ),
      // textButtonTheme: TextButtonThemeData(
      //   style: TextButton.styleFrom(
      //     foregroundColor: Colors.blue, // Default text button color
      //   ),
      // ),
      // outlinedButtonTheme: OutlinedButtonThemeData(
      //   style: OutlinedButton.styleFrom(
      //     foregroundColor: Colors.blue, // Default outlined button color
      //   ),
      // ),
    );
  }

  static Widget buildPage(
      {required Widget child, required BuildContext context}) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/kiosk_potrait_expand_bg_v2.svg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(80),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double containerWidth = constraints.maxWidth;
                  double width = containerWidth > 1200 ? 1200 : containerWidth;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: 1600,
                          width: width,
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
