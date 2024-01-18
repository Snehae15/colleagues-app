import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherTile extends StatelessWidget {
  const TeacherTile({
    super.key,
    required this.image,
    required this.name,
    required this.department,
    required this.cancel,
    required this.accept,
    required this.status,
  });

  final String image;
  final String name;
  final String department;
  final String status;
  final void Function() cancel;
  final void Function() accept;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10).r,
      child: ListTile(
        leading: Image.asset(
          image,
          width: 40,
          height: 40,
          fit: BoxFit.fill,
        ),
        title: AppText(
          text: name,
          size: 15,
          fontWeight: FontWeight.w400,
          color: customBlack,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: department,
              size: 13,
              fontWeight: FontWeight.w400,
              color: customBlack,
            ),
            AppText(
              text: 'Status: $status',
              size: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ],
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          InkWell(
            //Reject Button............
            onTap: cancel,
            child: const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          InkWell(
            //accept Button..........
            onTap: accept,
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          )
        ]),
        tileColor: tileColor,
      ),
    );
  }
}
