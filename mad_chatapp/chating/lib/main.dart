import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/widget/theam_change.dart';

import 'const.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
return ThemeBuilder(
  builder: (context, _brightness) {
    return MaterialApp(
      title: 'Postman',
      theme: ThemeData(
          primarySwatch: Colors.blue, brightness: _brightness),
      home: LoginScreen(title: 'Postman'),
      debugShowCheckedModeBanner: false,
    );
  },
);


  }
}
