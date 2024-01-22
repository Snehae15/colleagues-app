import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/EventCard.dart';
import 'package:college_app/widgets/StudentTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TEventDetails extends StatelessWidget {
  const TEventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20).r,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: customBlack,
            ),
          ),
        ),
        title: AppText(
            text: "Details",
            size: 18.sp,
            fontWeight: FontWeight.w500,
            color: customBlack),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20).r,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const EventCard(
            heading: "food festival",
            date: "12-12-2023",
            time: "10.00 Am",
            location: 'College Hall',
            eventId: '',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20).r,
            child: const AppText(
                text: "participants",
                size: 15,
                fontWeight: FontWeight.w500,
                color: customBlack),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) => StudentTile(
              name: "Name",
              department: "department",
              studentId: '',
              mode: true,
              click: () {},
              eventId: '',
              status: '',
            ),
            itemCount: 2,
          )),
        ]),
      ),
    );
  }
}
