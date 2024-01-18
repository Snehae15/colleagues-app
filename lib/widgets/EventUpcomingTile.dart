import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventUpcomingTila extends StatelessWidget {
  const EventUpcomingTila({
    super.key,
    required this.title,
    required this.delete,
    required this.click,
  });

  final String title;
  final void Function() click;
  final void Function() delete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10).r,
      child: ListTile(
        title: AppText(
            text: title,
            size: 14.sp,
            fontWeight: FontWeight.w500,
            color: customWhite),
        trailing: InkWell(
          onTap: delete, // delete function..........
          child: const Icon(
            Icons.delete_outline_sharp,
            color: customWhite,
          ),
        ),
        onTap: click,
        tileColor: maincolor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6).r),
      ),
    );
  }
}
