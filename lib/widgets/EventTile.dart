import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.title,
     required this.click,
  });
  final String title;
  final void Function() click;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10).r,
      child: ListTile(
        tileColor: maincolor,
        title: AppText(
            text: title,
            size: 14,
            fontWeight: FontWeight.w500,
            color: customWhite),
        onTap: click,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6).r),
      ),
    );
  }
}
