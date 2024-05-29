import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/home_screen.dart';
import 'package:flutter_app/pages/loading_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:dio/dio.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  Timer? _activityTimer;
  Timer? _countdownTimer;
  Timer? _textTimer;
  int _countdownSeconds = 10;
  bool _isDialogShowing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_resetActivityTimer);
    _controller.addListener(_startTextTimer);
    _setupInterceptor();
    _focusNode.requestFocus();
  }

  void _setupInterceptor() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.baseUrl = 'http://10.110.212.188/kioskAPI/api/kiosk';
      options.path += '\$text';
      return handler.next(options);
    }));
  }

  void showCountdownDialog() {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              startCountdown(setState);
              return Dialog(
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
                  width: 700,
                  height: 400,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40), // Extra space on top
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 50,
                            color: Color(0xFF000000),
                          ),
                          children: [
                            TextSpan(
                              text: '$_countdownSeconds',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 64,
                                height: 1.3,
                                color: Color(0xFFF36F21),
                              ),
                            ),
                            const TextSpan(
                              text: ' seconds \n',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 64,
                                height: 1.3,
                              ),
                            ),
                            const TextSpan(
                              text: 'Do you want to continue?',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 50,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: 40), // Space between text and buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: const Size(
                                  150, 60), // Set minimum size for button
                              padding: const EdgeInsets.symmetric(
                                vertical: 35,
                                horizontal: 50,
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 45,
                                color: Color(0xFFF2F3F4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ).then((_) {
        _isDialogShowing = false;
        _countdownTimer?.cancel();
      });
    }
  }

  void startCountdown(StateSetter setState) {
    const countdownInterval =
        Duration(seconds: 1); // Adjust this interval as needed
    _countdownTimer = Timer.periodic(countdownInterval, (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          timer.cancel();
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_resetActivityTimer);
    _controller.removeListener(_startTextTimer);
    _activityTimer?.cancel();
    _countdownTimer?.cancel();
    _textTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _resetActivityTimer() {
    if (_activityTimer != null && _activityTimer!.isActive) {
      _activityTimer!.cancel();
    }
  }

  void _startTextTimer() {
    if (_textTimer != null && _textTimer!.isActive) {
      _textTimer!.cancel();
    }
    _textTimer = Timer(const Duration(seconds: 1), () {
      if (_controller.text.isNotEmpty) {
        _handleInactivity(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .requestFocus(_focusNode); // Ensure the text field remains focused
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
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) {
          return LoadingScreen(username: '', balance: 0.0, qrData: text);
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
}
