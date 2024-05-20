import 'package:flutter/material.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/loading_screen.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  // late Timer _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   _startTimer();
  // }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  // void _startTimer() {
  //   _timer = Timer(const Duration(seconds: 10), _showInactivityDialog);
  // }

  // void _resetTimer() {
  //   _timer.cancel();
  //   _startTimer();
  // }

  // void _showInactivityDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.symmetric(horizontal: 70, vertical: 140),
  //         title: Text("Inactivity Alert"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text("Do you want to continue scanning?"),
  //           ],
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               _resetTimer();
  //             },
  //             child: Text("Continue"),
  //           ),
  //         ],
  //       );
  //     },
  //   ).then((value) {
  //     if (value != null && !value) {
  //       Navigator.pop(context); // Navigate back to the previous page
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100), // Added space at the top
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'SCAN YOUR',
                  textAlign: TextAlign.center, // Center align the text
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 80, // Reduced font size for better alignment
                    color: const Color(0xFFF36F21),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/icity_super_app_logo.png',
                width: 200, // Adjust right position for the image
                height: 134,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'QR',
                  textAlign: TextAlign.center, // Center align the text
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 80, // Reduced font size for better alignment
                    color: const Color(0xFFF36F21),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Add some padding
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingScreen(),
                          ),
                        );
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Reload(),
                          ),
                        );
                      },
                      child: const Text('Reload Cheat'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 200), // Adjust height as needed
                    Transform.rotate(
                      angle: 5 * (math.pi / 180), // Convert degrees to radians
                      child: Image.asset(
                        'assets/images/curly_arrow.gif',
                        width: 800,
                        height: 800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/images/phone_qr.svg',
                      width: 600,
                      height: 600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// void fetcUser() async {
//   print('Fetching user data');
//   const url = 'http://randomuser.me/api/?results=100';
//   final uri = Uri.parse(url);
//   final response = await http.get(uri);
//   final body = response.body;
//   final json = jsonDecode(body);
//   setState(() {
//     users = json['results'];
//   });
//   // Fetch user data
// }
