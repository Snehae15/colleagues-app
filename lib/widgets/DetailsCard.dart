import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    required this.department,
    required this.event,
    required this.date,
    required this.time,
    required this.place,
  });
  final String department;
  final String event;
  final String date;
  final String time;
  final String place;
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          const AppText(
              text: "Department",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(":")),
          AppText(
              text: department,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
        const TableRow(children: [
          SizedBox(height: 15), //SizeBox Widget
          SizedBox(height: 15),
          SizedBox(height: 15),
        ]),
        TableRow(children: [
          const AppText(
              text: "Request Event",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(':')),
          AppText(
              text: event,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
        const TableRow(children: [
          SizedBox(height: 15), //SizeBox Widget
          SizedBox(height: 15),
          SizedBox(height: 15),
        ]),
        TableRow(children: [
          const AppText(
              text: "Date",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(':')),
          AppText(
              text: date,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
        const TableRow(children: [
          SizedBox(height: 15), //SizeBox Widget
          SizedBox(height: 15),
          SizedBox(height: 15),
        ]),
        TableRow(children: [
          const AppText(
              text: "Time",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(':')),
          AppText(
              text: time,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
        const TableRow(children: [
          SizedBox(height: 15), //SizeBox Widget
          SizedBox(height: 15),
          SizedBox(height: 15),
        ]),
        TableRow(
          children: [
            const AppText(
                text: "Location",
                size: 14,
                fontWeight: FontWeight.w400,
                color: customBlack),
            const Center(child: Text(':')),
            AppText(
                text: place,
                size: 14,
                fontWeight: FontWeight.w400,
                color: customBlack)
          ],
        )
      ],
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(5),
      },
    );
  }
}
