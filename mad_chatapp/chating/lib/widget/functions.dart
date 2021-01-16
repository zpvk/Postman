import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: non_constant_identifier_names
Widget IAppBar(String name) {
  return new AppBar(
    backgroundColor: Colors.white,
    bottom: PreferredSize(
      preferredSize: Size(100.0, 100.0),
      child: Container(
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('$name',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 50,
                          color: Colors.black),
                    )),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}