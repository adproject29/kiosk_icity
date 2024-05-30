import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/pages/loading_screen.dart';
import 'package:flutter_app/pages/loading_uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:dio/dio.dart';

class ScanQr extends StatefulWidget {
  final String uuid;
  const ScanQr({Key? key, required this.uuid});

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Dio _dio = Dio();
  late Timer _redirectTimer;
  late Timer _textTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_startTextTimer);
    _setupInterceptor();
    _focusNode.requestFocus();
    _redirectTimer = Timer(
      const Duration(seconds: 20),
      _redirectToLoadingPage,
    ); // Timer
  }

  void _setupInterceptor() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.baseUrl = 'http://localhost/kioskAPI/api/kiosk';
      options.path += '\$text';
      return handler.next(options);
    }));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _redirectTimer.cancel();
    _textTimer.cancel();
    super.dispose();
  }

  void _startTextTimer() {
    _textTimer = Timer(const Duration(milliseconds: 500), () {
      if (_controller.text.isNotEmpty) {
        _handleInactivity(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: AppTheme.buildPage(
        context: context,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'SCAN YOUR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 90,
                      color: Color(0xFFF36F21),
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
                      fontSize: 90,
                      color: const Color(0xFFF36F21),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Opacity(
                    opacity: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        autofocus: true,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0),
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (text) {
                          _handleInactivity(text);
                        },
                      ),
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
                      Transform.rotate(
                        angle: 5 * (math.pi / 180),
                        child: Image.asset(
                          'assets/images/curly_arrow.gif',
                          width: 600,
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
                      Image.asset(
                        'assets/images/phone_icity_qr.gif',
                        width: 1000,
                        height: 800,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleInactivity(String text) {
    if (text.isNotEmpty) {
      _submitText(text);
    }
  }

  Future<void> _submitText(String text) async {
    if (!mounted) return;
    _redirectTimer.cancel();
    _textTimer.cancel();
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) {
          return LoadingScreen(
            username: '',
            balance: 0.0,
            qrData: text,
            uuid: widget.uuid,
            accID: 0,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _redirectToLoadingPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const LoadingUUID();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
