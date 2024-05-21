import 'package:flutter/material.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/pages/reload.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/loading_screen.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  late Timer _inactivityTimer = Timer(Duration.zero, () {});
  final TextEditingController _controller = TextEditingController();
  String _userName = '';
  double? _balance;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_resetInactivityTimer);
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'SCAN YOUR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 80,
                    color: const Color(0xFFF36F21),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/icity_super_app_logo.png',
                width: 200,
                height: 134,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'QR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 80,
                    color: const Color(0xFFF36F21),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
                    const SizedBox(height: 200),
                    Transform.rotate(
                      angle: 5 * (math.pi / 180),
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

  @override
  void dispose() {
    _controller.removeListener(_resetInactivityTimer);
    _inactivityTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _resetInactivityTimer() {
    if (_inactivityTimer.isActive) {
      _inactivityTimer.cancel();
    }
    _inactivityTimer = Timer(const Duration(seconds: 2), _handleInactivity);
  }

  void _handleInactivity() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      _submitText(text);

      // Delay for 1 second and then clear the text field
      Future.delayed(const Duration(seconds: 1), () {
        _controller.clear();
      });
    }
  }

  Future<void> _submitText(String text) async {
    // Display loading screen
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoadingScreen(username: '', balance: 0.0)),
    );

    // Build the dynamic URL
    final url =
        'http://10.110.212.188/stagingAPI/api/account/SGetAccDtls?strData=$text';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print('API Success');
      final body = response.body;
      final json = jsonDecode(body);

      if (json['Content'] != null && json['Content'].isNotEmpty) {
        String userName = json['Content'][0]['UserName'];
        dynamic balanceData = json['Content'][0]['Balance'];

        double balance;

        if (balanceData is String) {
          balance = double.tryParse(balanceData) ?? 0.0;
        } else if (balanceData is int) {
          balance = balanceData.toDouble();
        } else {
          // Handle unexpected data type
          print('Error: Unexpected data type for balance');
          balance = 0.0; // or any default value you prefer
        }

        // Print username and balance
        print('Username: $userName');
        print('Balance: $balance');

        // Navigate to Reload page with the parsed data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingScreen(
              username: userName,
              balance: balance,
            ),
          ),
        );
      } else {
        // Handle empty or unexpected response content
        print('Error: Unexpected response content');
        Navigator.pop(context); // Pop the loading screen on error
      }
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
      Navigator.pop(context); // Pop the loading screen on error
    }
  }
}

void _navigateToLoadingScreen(BuildContext context) {
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
