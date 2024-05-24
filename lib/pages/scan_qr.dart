import 'package:flutter/material.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/pages/loading_failed.dart';
import 'package:flutter_app/pages/qr_error.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/loading_screen.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  late Timer _inactivityTimer;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_resetInactivityTimer);
    _setupInterceptor();
    _inactivityTimer = Timer(Duration.zero, () {}); // Initialize the timer
    _focusNode.requestFocus();
  }

  void _setupInterceptor() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.baseUrl = 'http://10.110.212.188/stagingAPI/api/account/';
      options.path += '\$text';
      return handler.next(options);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
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
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (text) {
                    _handleInactivity(text);
                  },
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
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_resetInactivityTimer);
    if (_inactivityTimer.isActive) {
      _inactivityTimer.cancel();
    }
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _resetInactivityTimer() {
    if (_inactivityTimer.isActive) {
      _inactivityTimer.cancel();
    }
    _inactivityTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _handleInactivity(_controller.text);
      }
    });
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
      MaterialPageRoute(
        builder: (context) =>
            LoadingScreen(username: '', balance: 0.0, qrData: text),
      ),
    );
  }
}
