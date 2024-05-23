import 'package:flutter/material.dart';
import 'package:flutter_app/pages/scan_qr.dart';
import 'package:flutter_app/pages/terminal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/app_theme.dart';

class Reload extends StatefulWidget {
  final String username;
  final double balance;

  Reload({
    required this.username,
    required this.balance,
  });

  @override
  _ReloadState createState() => _ReloadState();
}

class _ReloadState extends State<Reload> {
  int amount = 0;
  bool isValidAmount = false;
  bool isContinueDisabled = false;
  double minReloadOpacity = 0.0;
  double maxReloadOpacity = 0.0;

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
    isValidAmount = amount >= 20 && amount <= 500;
    isContinueDisabled = !isValidAmount;

    if (amount == 0 || amount < 20) {
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

    return GestureDetector(
      onTapDown: (_) {
        if (!isDisabled) {
          setState(() {
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
      child: Container(
        width: 250,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: button == 'C' ? Colors.red : Colors.grey[300],
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

  void _showReloadConfirmationDialog(
      BuildContext context, String username, double balance, int amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0, 4),
                  blurRadius: 2,
                ),
              ],
            ),
            width: 700,
            height: 400,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20), // Extra space on top
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 50,
                      color: Color(0xFF000000),
                    ),
                    children: [
                      TextSpan(
                        text: 'Reload ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 64,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: 'RM $amount ?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 64,
                          height: 1.3,
                          color: Color(0xFFF36F21),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40), // Space between text and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFC3239),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize:
                            Size(150, 60), // Set minimum size for button
                        padding: EdgeInsets.symmetric(
                          vertical: 35,
                          horizontal: 50,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 45,
                          color: Color(0xFFF2F3F4),
                        ),
                      ),
                    ),
                    SizedBox(width: 40), // Space between buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Terminal(
                              username: username,
                              balance: balance,
                              amount: amount.toDouble(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize:
                            Size(150, 60), // Set minimum size for button
                        padding: EdgeInsets.symmetric(
                          vertical: 35,
                          horizontal: 50,
                        ),
                      ),
                      child: Text(
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
      child: Column(
        children: [
          Align(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Reload(
                                username: widget.username,
                                balance: 0.0,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          padding: const EdgeInsets.fromLTRB(20, 35, 33, 34),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScanQr(),
                                ),
                              );
                            },
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
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 130, 0, 19),
                      child: Text(
                        widget.username,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 220,
                  top: 85,
                  child: SizedBox(
                    height: 60,
                    child: Text(
                      'Hi,',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
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
                  GestureDetector(
                    onTap: () {
                      if (isValidAmount) {
                        _showReloadConfirmationDialog(
                          context,
                          widget.username,
                          widget.balance,
                          amount,
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 820,
                        height: 130,
                        padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
