import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.btnname,
    required this.click,
  });
  final String btnname;
  final void Function() click;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: click,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6).r, color: maincolor),
        child: Center(
          child: AppText(
              text: btnname,
              color: customWhite,
              size: 14,
              fontWeight: FontWeight.w600),
      
        ),
      ),
    );
  }
}
