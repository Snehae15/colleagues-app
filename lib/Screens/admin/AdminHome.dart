import 'package:college_app/Screens/admin/EventScreen.dart';
import 'package:college_app/Screens/admin/Notification.dart';
import 'package:college_app/Screens/admin/RequestScreen.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AppText(
              text: "Request",
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
                        builder: (context) => const NotificationScreen(),
                      ));
                },
                child: const Icon(Icons.notifications_active_outlined)),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20).r,
          child: Column(children: [
            const Expanded(
                child: TabBarView(children: [RequestScreen(), EventScreen()])),
            Container(
              // Tab bar.......................
              height: 60.h,
              decoration: BoxDecoration(
                  border: Border.all(color: maincolor),
                  borderRadius: BorderRadius.circular(50).r),
              child: Padding(
                padding: const EdgeInsets.all(4).r,
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: maincolor), //Change background color from here
                  tabs: [
                    Text("Request",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    Text("Event",
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
