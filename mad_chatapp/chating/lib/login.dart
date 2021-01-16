import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/const.dart';
import 'package:flutter_chat_demo/home.dart';
import 'package:flutter_chat_demo/widget/loading.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        // Update data to server if new user
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoURL,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoURL);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0].data()['id']);
        await prefs.setString('nickname', documents[0].data()['nickname']);
        await prefs.setString('photoUrl', documents[0].data()['photoUrl']);
        await prefs.setString('aboutMe', documents[0].data()['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }
  var parser = EmojiParser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.asset("images/lg2.png"),
              heightFactor: 40,),
            // ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Text("DEVELOPED WITH $heart BY BORING CODE",style: TextStyle(color:Colors.black),),
            //
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 130.0),
                child: new RaisedButton(
                    padding: EdgeInsets.only(top: 3.0,bottom: 3.0,left: 3.0),
                    color: const Color(0xFF4285F4),
                    onPressed: handleSignIn,
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Image.asset(
                          'images/gg.png',
                          height: 48.0,
                        ),
                        new Container(
                            padding: EdgeInsets.only(left: 10.0,right: 10.0),
                            child: new Text("Sign in with Google",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)

                        ),
                      ],
                    )
                ),
                  ),

            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            ),
          ],
        ));
  }
}
