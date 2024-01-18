import 'package:college_app/Screens/student/EventScreen.dart';
import 'package:college_app/Screens/student/PreviousEvent.dart';
import 'package:college_app/Screens/student/StudentNotification.dart';
import 'package:college_app/Screens/student/StudentProfile.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: customWhite,
          automaticallyImplyLeading: false,
          title: AppText(
              text: "Event",
              size: 18.sp,
              fontWeight: FontWeight.w500,
              color: customBlack),
          centerTitle: true,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        //goto profile......................................
                        builder: (context) => StudentProfile(),
                      ));
                },
                child: const Icon(Icons.person_2_outlined)),
            SizedBox(width: 10.w),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        //goto notification......................................
                        builder: (context) => StudentNotification(),
                      ));
                },
                child: const Icon(Icons.notifications_active_outlined)),
            SizedBox(width: 20.w),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20).r,
          child: Column(children: [
            const Expanded(
                child:
                    TabBarView(children: [SRequestScreen(), PreviousEvent()])),
            Container(
              // Tab bar.......................
              height: 60.h,
              decoration: BoxDecoration(
                  color: customWhite,
                  border: Border.all(color: maincolor),
                  borderRadius: BorderRadius.circular(50).r),
              child: Padding(
                padding: const EdgeInsets.all(4).r,
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: maincolor),
                  tabs: [
                    Text("Upcoming",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    Text("Previous",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600))
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: customWhite,
                  unselectedLabelColor: customBlack,
                  dividerColor: Colors.transparent,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
