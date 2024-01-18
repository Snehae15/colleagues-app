import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  const AppText(
      {super.key,
      required this.text,
      required this.size,
      required this.fontWeight,
      required this.color});
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: size.sp, fontWeight: fontWeight, color: color),
    );
  }
}

class AppText2 extends StatelessWidget {
  const AppText2(
      {super.key,
      required this.text,
      required this.size,
      required this.fontWeight,
      required this.color});
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: size.sp, fontWeight: fontWeight, color: color),
           overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
