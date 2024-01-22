import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentTile extends StatelessWidget {
  StudentTile({
    super.key,
    required this.name,
    required this.status,
    required this.department,
    required this.click,
    this.mode = false,
    required this.eventId,
    required this.studentId,
  });

  String eventId;
  final String name;
  final String status;
  final String department;
  final String studentId;
  final void Function() click;
  final bool
      mode; // if mode is true cancel button will be shown in the List Tile.................

  void removeParticipant(String eventId, studentId) async {
    print('$eventId..........');
    print('$studentId..........');
    await FirebaseFirestore.instance
        .collection('EventRegistration')
        .where('eventId', isEqualTo: eventId)
        .where('studentId', isEqualTo: studentId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10).r,
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: Image.asset(
            'assets/stu.png',
            fit: BoxFit.fill,
          ),
        ),
        title: AppText(
            text: name,
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack),
        subtitle: AppText(
            text: department,
            size: 12,
            fontWeight: FontWeight.w400,
            color: customBlack),
        trailing: mode == true
            ? InkWell(
                onTap: () {
                  removeParticipant(eventId, studentId);
                },
                child: const Icon(
                  Icons.cancel,
                  color: maincolor,
                ),
              )
            : const SizedBox(),
        tileColor: tileColor,
        onTap: click,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6).r),
      ),
    );
  }
}
