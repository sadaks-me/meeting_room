import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/img_no_internet.png',
                height: 200,
              ),
              Text(
                "You’re Offline",
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                  color: Color(0xff222222),
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Connect to the internet and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffa7a7a7),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
