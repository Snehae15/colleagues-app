import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotifiactionCard extends StatelessWidget {
  const NotifiactionCard({
    super.key,
    required this.heading,
    required this.contents, required this.delete,
  });
  final String heading;
  final String contents;
  final void Function() delete;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                  text: heading,
                  size: 13,
                  fontWeight: FontWeight.w500,
                  color: maincolor),
              InkWell(
                onTap: delete, // delete function.........
                child: Icon(Icons.delete_outline_outlined))
            ],
          ),
          AppText(
              text: contents,
              size: 12,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
      ),
    );
  }
}
