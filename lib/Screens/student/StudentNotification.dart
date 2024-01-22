import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/landingpage.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentNotification extends StatelessWidget {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(
                Icons.logout,
                color: customBlack,
              ),
              onPressed: () {
                _logout(context); // Call _logout function on tap
              },
            ),
          ),
        ],
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
                  );
                },
              );
            },
          ),
        ]),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Navigate to LandingPage on logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
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
        title: Text(heading),
        subtitle: Text(contents),
      ),
    );
  }
}
