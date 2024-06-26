import 'package:flutter/material.dart';
import 'package:flutter_app/pages/scan_qr.dart';
import 'package:flutter_app/pages/terminal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/app_theme.dart';

class Reload extends StatefulWidget {
  final String username;
  final double balance;
  final String uuid;
  final int accID;
  final String qrData;

  const Reload(
      {super.key,
      required this.username,
      required this.balance,
      required this.uuid,
      required this.accID,
      required this.qrData});

  @override
  _ReloadState createState() => _ReloadState();
}

class _ReloadState extends State<Reload> {
  int amount = 0;
  bool isValidAmount = false;
  bool isContinueDisabled = false;
  double minReloadOpacity = 0.0;
  double maxReloadOpacity = 0.0;
  String pressedButton = '';

  void onNumberPressed(String number) {
    setState(() {
      int num = int.parse(number);
      if (amount == 500) return;
      if (amount == 0) {
        amount = num;
      } else {
        amount = amount * 10 + num;
      }
      _validateAmount();
    });
  }

  void onClearPressed() {
    setState(() {
      amount = 0;
      _validateAmount();
    });
  }

  void onDeletePressed() {
    setState(() {
      if (amount >= 10) {
        amount = amount ~/ 10;
      } else {
        amount = 0;
      }
      _validateAmount();
    });
  }

  void _validateAmount() {
    isValidAmount = amount >= 1 && amount <= 500; // Set the lower limit to 1
    isContinueDisabled = !isValidAmount;

    if (amount == 0 || amount < 1) {
      // Change this condition to check for lower limit
      minReloadOpacity = 1.0;
      maxReloadOpacity = 0.0;
    } else if (amount > 500) {
      minReloadOpacity = 0.0;
      maxReloadOpacity = 1.0;
    } else {
      minReloadOpacity = 0.0;
      maxReloadOpacity = 0.0;
    }
  }

  Widget _buildButton(String button) {
    bool isDisabled = amount > 500 && button != 'C' && button != 'D';
    bool isPressed = pressedButton == button;

    return GestureDetector(
      onTapDown: (_) {
        if (!isDisabled) {
          setState(() {
            pressedButton = button;
            if (button == 'C') {
              onClearPressed();
            } else if (button == 'D') {
              onDeletePressed();
            } else {
              onNumberPressed(button);
            }
          });
        }
      },
      onTapUp: (_) {
        setState(() {
          pressedButton = '';
        });
      },
      onTapCancel: () {
        setState(() {
          pressedButton = '';
        });
      },
      child: MouseRegion(
        onEnter: (_) {
          if (!isDisabled) {
            setState(() {});
          }
        },
        onExit: (_) {
          if (!isDisabled) {
            setState(() {});
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 250,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: isPressed
                ? Colors.orange
                : button == 'C'
                    ? Colors.red
                    : Colors.grey[300],
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: button == 'C'
                ? Text(
                    'Clear',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 55,
                      color: Colors.white,
                    ),
                  )
                : button == 'D'
                    ? SizedBox(
                        width: 64,
                        height: 80,
                        child: SvgPicture.asset(
                          'assets/vectors/delete.svg',
                        ),
                      )
                    : Text(
                        button,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 55,
                          color: isDisabled ? Colors.grey : Colors.black,
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: SizedBox(
        width: 900,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buttons.map((button) => _buildButton(button)).toList(),
        ),
      ),
    );
  }

  void _showReloadConfirmationDialog(BuildContext context, String username,
      double balance, int amount, String uuid, int accID, String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
            height: 460,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Extra space on top
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 50,
                      color: Color(0xFF000000),
                    ),
                    children: [
                      const TextSpan(
                        text: 'Reload\n',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 70,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: 'RM $amount ?',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 70,
                          height: 1.3,
                          color: Color(0xFFF36F21),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40), // Space between text and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFC3239),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize:
                            const Size(150, 60), // Set minimum size for button
                        padding: const EdgeInsets.symmetric(
                          vertical: 35,
                          horizontal: 50,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 45,
                          color: Color(0xFFF2F3F4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Space between buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(seconds: 1),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return Terminal(
                                username: username,
                                balance: balance,
                                amount: amount.toDouble(),
                                uuid: widget.uuid,
                                accID: widget.accID,
                                qrData: qrData,
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize:
                            const Size(150, 60), // Set minimum size for button
                        padding: const EdgeInsets.symmetric(
                          vertical: 35,
                          horizontal: 50,
                        ),
                      ),
                      child: const Text(
                        'Confirm',
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
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
      context: context,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const ScanQr(uuid: '');
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(-1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(50, 50, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.fromLTRB(20, 35, 33, 34),
                      child: SizedBox(
                        width: 43,
                        height: 81,
                        child: SvgPicture.asset(
                          'assets/vectors/arrow_back.svg',
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 100, 0, 0),
                      child: Text(
                        'Hi,',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 19),
                      child: Text(
                        '${widget.username}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(310, 0, 0, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 26, 10.3, 9),
                    child: Text(
                      'Current Balance :',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'RM${widget.balance.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 55,
                      color: const Color(0xFFF36F21),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 13.6, 0),
              child: SizedBox(
                width: 1000,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 20, 0, 0),
                      child: Text(
                        'Enter reload amount',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,
                          fontSize: 48,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(17, 0, 0, 19),
                      child: Text(
                        'RM $amount',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 64,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(7, 0, 0, 7),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: const SizedBox(
                          width: 700,
                          height: 3,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: minReloadOpacity,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(102, 5, 0, 30),
                            child: Text(
                              '*Min reload: RM20',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 32,
                                color: const Color(0xFFEB001B),
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: maxReloadOpacity,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 100, 30),
                            child: Text(
                              '*Max reload: RM500',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 32,
                                color: const Color(0xFFEB001B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildRow(['1', '2', '3']),
                    _buildRow(['4', '5', '6']),
                    _buildRow(['7', '8', '9']),
                    _buildRow(['C', '0', 'D']),
                    const SizedBox(height: 20), // Added space before the button
                    GestureDetector(
                      onTap: () {
                        if (isValidAmount) {
                          _showReloadConfirmationDialog(
                            context,
                            widget.username,
                            widget.balance,
                            amount,
                            widget.uuid,
                            widget.accID,
                            widget.qrData,
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 20, bottom: 20), // Adjusted margin
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: isContinueDisabled
                              ? Colors.grey
                              : isValidAmount
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              offset: Offset(0, 4),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        width: 820,
                        height: 130,
                        padding: const EdgeInsets.symmetric(
                            vertical: 22), // Adjusted padding
                        alignment: Alignment.center,
                        child: Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 55,
                            color: Colors.white,
                          ),
                        ),
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
