import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.heading,
    required this.date,
    required this.time,
    required this.location,
    this.mode = false,
    this.host = "", required eventId,
  });
  final String heading;
  final String date;
  final String time;
  final String location;
  final String host;
  final bool mode; // if mode is true host is visible in the event card.....
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10).r,
      child: Card(
        color: Colors.blue.shade50,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6).r,
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10)
                    .r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppText(
                    text: heading,
                    size: 14,
                    fontWeight: FontWeight.w500,
                    color: maincolor),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                            text: "Date",
                            size: 12,
                            fontWeight: FontWeight.w400,
                            color: customBlack),
                        SizedBox(
                          height: 2.h,
                        ),
                        const AppText(
                            text: "Time",
                            size: 12,
                            fontWeight: FontWeight.w400,
                            color: customBlack),
                        SizedBox(
                          height: 2.h,
                        ),
                        const AppText(
                            text: "Location",
                            size: 12,
                            fontWeight: FontWeight.w400,
                            color: customBlack),
                        SizedBox(
                          height: 2.h,
                        ),
                        mode == true
                            ? const AppText(
                                text: "Host",
                                size: 12,
                                fontWeight: FontWeight.w400,
                                color: customBlack)
                            : SizedBox(),
                      ],
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText2(
                              text: " : ${date}",
                              size: 12,
                              fontWeight: FontWeight.w400,
                              color: customBlack),
                          SizedBox(
                            height: 2.h,
                          ),
                          AppText2(
                              text: " : ${time}",
                              size: 12,
                              fontWeight: FontWeight.w400,
                              color: customBlack),
                          SizedBox(
                            height: 2.h,
                          ),
                          AppText2(
                              text: " : ${location}",
                              size: 12,
                              fontWeight: FontWeight.w400,
                              color: customBlack),
                          SizedBox(
                            height: 2.h,
                          ),
                          mode == true
                              ? AppText2(
                                  text: " : ${host}",
                                  size: 12,
                                  fontWeight: FontWeight.w400,
                                  color: customBlack)
                              : SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
