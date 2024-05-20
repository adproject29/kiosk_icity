import 'package:flutter/material.dart';
import 'package:flutter_app/pages/scan_qr.dart';
import 'package:flutter_app/pages/terminal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/app_theme.dart'; // Importing AppTheme

class Reload extends StatefulWidget {
  @override
  _ReloadState createState() => _ReloadState();
}

class _ReloadState extends State<Reload> {
  String amount = "0";
  bool isValidAmount = false;

  void onNumberPressed(String number) {
    if (amount == "500") return;
    setState(() {
      if (amount == "0") {
        amount = number;
      } else {
        amount += number;
      }
      _validateAmount();
    });
  }

  void onClearPressed() {
    setState(() {
      amount = "0";
      _validateAmount();
    });
  }

  void onDeletePressed() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = "0";
      }
      _validateAmount();
    });
  }

  void _validateAmount() {
    double value = double.tryParse(amount) ?? 0;
    isValidAmount = value >= 20 && value <= 500;
  }

  Widget _buildButton(String button) {
    bool isDisabled = amount == "500" && button != 'C' && button != 'D';
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
        child: Container(
          width: 250,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
          alignment: Alignment.center,
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

  void _showReloadConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Reload'),
          content: Text('Are you sure you want to reload RM $amount?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add logic to proceed with reload
                Navigator.of(context).pop();
                // Navigate to the terminal page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Terminal()),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildPage(
        // Wrap with AppTheme widget
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
              child: Align(
                alignment: Alignment.topCenter,
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
                                  builder: (context) => Reload(),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              padding:
                                  const EdgeInsets.fromLTRB(20, 35, 33, 34),
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
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 130, 0, 19),
                          child: Text(
                            'test',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 48,
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
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                          'RM00.00',
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
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 17, 0, 124),
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
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(102, 5, 0, 30),
                                  child: Text(
                                    '*Min reload: RM20',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 32,
                                      color: const Color(0xFFEB001B),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 5, 100, 30),
                                  child: Text(
                                    '*Max reload: RM500',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 32,
                                      color: const Color(0xFFEB001B),
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
                                  _showReloadConfirmationDialog(context);
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: isValidAmount
                                      ? Color(0xFFF36F21)
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
                                  height: 120,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 22, 0, 22),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}