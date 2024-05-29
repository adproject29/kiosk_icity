import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/home_screen.dart';
import 'package:flutter_app/pages/uuid_error.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/app_theme.dart';

class LoadingUUID extends StatefulWidget {
  const LoadingUUID({super.key});

  @override
  _LoadingUUIDState createState() => _LoadingUUIDState();
}

class _LoadingUUIDState extends State<LoadingUUID> {
  String? _uuid;

  @override
  void initState() {
    super.initState();
    _fetchUuidFromLocalService();
  }

  Future<void> _fetchUuidFromLocalService() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8000/service/getuuid'));

      if (response.statusCode == 200) {
        final uuid = response.body.trim();
        setState(() {
          _uuid = uuid; // Set the UUID
        });
        _fetchUuidFromRemoteService(uuid);
      } else {
        print('Failed to fetch UUID from local service');
        _navigateToErrorUUIDPage(context); // Navigate to ErrorUUID page
      }
    } catch (e) {
      print('Error fetching UUID from local service: $e');
      _navigateToErrorUUIDPage(context); // Navigate to ErrorUUID page
    }
  }

  Future<void> _fetchUuidFromRemoteService(String uuid) async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.110.212.188/kioskAPI/api/kiosk/GetTerminal?UUID=$uuid'));

      if (response.statusCode == 200) {
        print('UUID from remote service: ${response.body}');
        _navigateToHomeScreen(context); // Navigate to HomeScreen
      } else {
        print('Failed to fetch UUID from remote service');
        _navigateToErrorUUIDPage(context); // Navigate to ErrorUUID page
      }
    } catch (e) {
      print('Error fetching UUID from remote service: $e');
      _navigateToErrorUUIDPage(context); // Navigate to ErrorUUID page
    }
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) {
          return HomeScreen(); // Navigate to the HomeScreen
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

  void _navigateToErrorUUIDPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) {
          return UUIDError(uuid: _uuid); // Navigate to ErrorUUID with UUID
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

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
      context: context,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(100),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(85, 88, 59, 117),
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
                        width: 600,
                        height: 600,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 31, 0),
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
