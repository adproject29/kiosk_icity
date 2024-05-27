// import 'dart:async';
// import 'package:flutter/material.dart';

// void showActivityStatusAlert(BuildContext context, VoidCallback onContinue) {
//   Timer? countdownTimer;
//   int countdownSeconds = 10;

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//             setState(() {
//               if (countdownSeconds > 0) {
//                 countdownSeconds--;
//               } else {
//                 timer.cancel();
//                 Navigator.of(context).pop();
//               }
//             });
//           });

//           return AlertDialog(
//             title: Text('Inactivity Detected'),
//             content: Text(
//                 'You have been inactive for 30 seconds. Countdown: $countdownSeconds'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   countdownTimer?.cancel();
//                   Navigator.of(context).pop();
//                   onContinue();
//                 },
//                 child: Text('Continue'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   ).then((_) {
//     countdownTimer?.cancel();
//   });
// }
