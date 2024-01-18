// Student Details model.............................................
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';

class StudDet extends StatelessWidget {
  const StudDet({
    super.key,
    required this.regno,
    required this.dipartment,
    required this.phone,
    required this.email,
    required this.status,
  });
  final String regno;
  final String dipartment;
  final String phone;
  final String email;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          const AppText(
              text: "Register No",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(":")),
          AppText(
              text: regno,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
        const TableRow(children: [
          SizedBox(height: 20), //SizeBox Widget
          SizedBox(height: 20),
          SizedBox(height: 20),
        ]),
        TableRow(children: [
          const AppText(
              text: "Department",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(':')),
          AppText(
              text: dipartment,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
        const TableRow(children: [
          SizedBox(height: 20), //SizeBox Widget
          SizedBox(height: 20),
          SizedBox(height: 20),
        ]),
        TableRow(children: [
          const AppText(
              text: "Phone No",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(':')),
          AppText(
              text: phone,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
        const TableRow(children: [
          SizedBox(height: 20), //SizeBox Widget
          SizedBox(height: 20),
          SizedBox(height: 20),
        ]),
        TableRow(children: [
          const AppText(
              text: "Email",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(':')),
          AppText(
              text: email,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
         const TableRow(children: [
          SizedBox(height: 20), //SizeBox Widget
          SizedBox(height: 20),
          SizedBox(height: 20),
        ]),
        TableRow(children: [
          const AppText(
              text: "Status",
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack),
          const Center(child: Text(':')),
          AppText(
              text: status,
              size: 14,
              fontWeight: FontWeight.w400,
              color: customBlack)
        ]),
      ],
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(5),
      },
    );
  }
}
