import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
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
                          child: _buildContentWithConnectivityCheck(child),
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

  static Widget _buildContentWithConnectivityCheck(Widget child) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.hasData) {
          var connectivityResult = snapshot.data;
          if (connectivityResult == ConnectivityResult.none) {
            // Connection lost
            return _buildConnectionLostWidget();
          }
        }
        // Connection available or unknown status, return child widget
        return child;
      },
    );
  }

  static Widget _buildConnectionLostWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.signal_wifi_off,
            size: 100,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          Text(
            'Connection Lost',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Check internet connection',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () {
                // Trigger connectivity check
                Connectivity().checkConnectivity();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Set button color to orange
                minimumSize: const Size(200, 60), // Set the size of the button
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15), // Add padding
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Make button rounded
                ),
              ),
              child: Text(
                'Refresh',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
