import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/pages/qr_error.dart';

class LoadingFailed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Function to redirect after delay
    void redirectAfterDelay() {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => QRError(),
        ));
      });
    }

    // Call redirect function
    redirectAfterDelay();

    return AppTheme.buildPage(
      context: context,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(100),
          width: screenSize.width - 200, // Adjusting width with margins
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(85, 100, 59, 117),
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
                        width: 700,
                        height: 700,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 31, 0),
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
