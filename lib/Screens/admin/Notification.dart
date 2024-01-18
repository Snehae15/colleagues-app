import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/admin/AddNotification.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key});

  void _deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .delete();

      // Perform any additional actions after deletion
      print('Notification deleted successfully!');
    } catch (error) {
      print('Error deleting notification: $error');
    }
  }

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
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
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
                      delete: () => _deleteNotification(notification?.id ?? ''),
                    );
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    DialogRoute(
                      context: context,
                      builder: (context) => AddNotification(),
                    ),
                  );
                },
                shape: const CircleBorder(),
                backgroundColor: maincolor,
                child: const Icon(
                  Icons.add,
                  color: customWhite,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String heading;
  final String contents;
  final VoidCallback delete;

  NotificationCard({
    required this.heading,
    required this.contents,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(heading),
        subtitle: Text(contents),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: delete,
        ),
      ),
    );
  }
}
