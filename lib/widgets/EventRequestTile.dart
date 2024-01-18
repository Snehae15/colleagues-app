import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventRequestTile extends StatelessWidget {
  const EventRequestTile({
    super.key,
    required this.image,
    required this.requestText,
    required this.click,
  });
  final String image;
  final String requestText;
  final void Function() click;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10).r,
      child: ListTile(
          leading: Image.asset(
            image,
            width: 35.w,
            height: 35.h,
            fit: BoxFit.fill,
          ),
          title: AppText(
            text: requestText,
            size: 14.sp,
            fontWeight: FontWeight.w500,
            color: customWhite,
          ),
          tileColor: maincolor,
          onTap: click,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6).r)),
    );
  }
}
