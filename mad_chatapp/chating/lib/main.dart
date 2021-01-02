import 'package:chating/helper/authenticate.dart';
import 'package:chating/helper/helperfunction.dart';
import 'package:chating/screens/chatRoomScreen.dart';
import 'package:chating/screens/signin.dart';
import 'package:chating/screens/signup.dart';
import 'package:chating/services/push_notification_service.dart';
import 'package:chating/widgets/MybottomBerDemo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    getLoggedInState();
    super.initState();
    void initState() {
      // TODO: implement initState
      super.initState();

      _firebaseMessaging.configure(
        onMessage: (message) async {
          setState(() {
            messageTitle = message["notification"]["title"];
            notificationAlert = "New Notification Alert";
          });
        },
        onResume: (message) async {
          setState(() {
            messageTitle = message["data"]["title"];
            notificationAlert = "Application opened from Notification";
          });
        },
      );
    }
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null
          ? /**/ userIsLoggedIn
              ? ChatRoom()
              : Authenticate() /**/ : Authenticate(),
    );
  }
}
