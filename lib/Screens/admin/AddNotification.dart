import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNotification extends StatelessWidget {
  AddNotification({Key? key});

  final eventname = TextEditingController();
  final description = TextEditingController();

  void _sendNotification(BuildContext context) async {
    try {
      // Validate that both event name and description are not empty
      if (eventname.text.trim().isEmpty || description.text.trim().isEmpty) {
        // Show an error message or return early
        return;
      }

      // Add the notification to Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'event_name': eventname.text.trim(),
        'description': description.text.trim(),
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      });

      // Clear the text fields after sending the notification
      eventname.clear();
      description.clear();

      // Show a success message using ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification sent successfully!'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (error) {
      print('Error sending notification: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customWhite,
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
          text: "Add Notification",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25).r,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Event Name",
                    size: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: customBlack,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    controller: eventname,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 15.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                        borderSide: const BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AppText(
                    text: "Description",
                    size: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: customBlack,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    controller: description,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                        borderSide: const BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                btnname: "Send",
                click: () => _sendNotification(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
