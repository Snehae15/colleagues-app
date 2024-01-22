import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20).r,
          child: InkWell(
            onTap: () {
              Navigator.pop(context); // back arrow Function...........
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: customBlack,
            ),
          ),
        ),
        title: AppText(
          text: "Notification",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
        child: Stack(children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              var notifications = snapshot.data?.docs;

              return ListView.builder(
                itemCount: notifications?.length ?? 0,
                itemBuilder: (context, index) {
                  var notification = notifications?[index];
                  return NotificationCard(
                    heading: notification?['event_name'] ?? '',
                    contents: notification?['description'] ?? '',
                    // delete: () => _deleteNotification(notification?.id ?? ''),
                  );
                },
              );
            },
          ),
        ]),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String heading;
  final String contents;

  NotificationCard({
    required this.heading,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Color.fromARGB(255, 210, 228, 240),
        title: Text(heading),
        subtitle: Text(contents),
      ),
    );
  }
}
