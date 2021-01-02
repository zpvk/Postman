// import 'dart:async';
// import 'dart:ffi';

// import 'package:chating/screens/signup.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'chatRoomScreen.dart';

// class EmailVerify extends StatefulWidget {
//   @override
//   _EmailVerifyState createState() => _EmailVerifyState();
// }

// class _EmailVerifyState extends State<EmailVerify> {
//   final auth = FirebaseAuth.instance;
//   User user;
//   Timer timer;

//   @override
//   void initState() {
//     user = auth.currentUser;
//     user.sendEmailVerification();
//     Timer.periodic(Duration(seconds: 10), (timer) {
//       cheackEmailVerified();
//     });
//     super.initState();
//     timer.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Text('An email has been sent to ${user.email} please verify'),
//     ));
//   }

//   // ignore: missing_return
//   Future<Void> cheackEmailVerified() async {
//     user = auth.currentUser;
//     await user.reload();
//     if (user.emailVerified == true) {
//       timer.cancel();
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => ChatRoom()));
//     } else {
//       timer.cancel();
//       user.delete();
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => SignUp()));
//     }
//   }
// }
