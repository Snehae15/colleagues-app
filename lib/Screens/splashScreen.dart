import 'dart:async';

import 'package:college_app/constants/colors.dart';
import 'package:college_app/landingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context as BuildContext,
          MaterialPageRoute(builder: (context) => LandingPage()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: Center(
        child: Text(
          "ColleagueApp",
          style: GoogleFonts.kadwa(
              fontSize: 40.sp, fontWeight: FontWeight.w700, color: customWhite),
        ),
      ),
    );
  }
}




// backgroundColor: maincolor,
// body: Center(
// child: Text(
// "ColleagueApp",
// style: GoogleFonts.kadwa(
// fontSize: 40.sp, fontWeight: FontWeight.w700, color: customWhite),
// ),
// ),
