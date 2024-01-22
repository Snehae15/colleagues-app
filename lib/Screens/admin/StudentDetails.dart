import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:college_app/widgets/DetailsCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentDetails extends StatefulWidget {
  final String? requestId;

  const StudentDetails({Key? key, this.requestId}) : super(key: key);

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = '';
  }

  Future<Map<String, dynamic>> fetchStudentAndEventData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> requestSnapshot =
          await FirebaseFirestore.instance
              .collection('EventRequests')
              .doc(widget.requestId)
              .get();

      if (!requestSnapshot.exists) {
        throw Exception('Request data not found');
      }

      String? studentId = requestSnapshot.data()?['StudentId'];

      if (studentId == null) {
        throw Exception('Student ID not found');
      }

      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .get();

      if (!studentSnapshot.exists) {
        throw Exception('Student data not found');
      }

      Map<String, dynamic> eventData = requestSnapshot.data()!;
      Map<String, dynamic> studentData = studentSnapshot.data()!;

      // Combining both data into a single map
      Map<String, dynamic> combinedData = {
        ...eventData,
        'studentData': studentData,
      };

      return combinedData;
    } catch (e) {
      print('Error fetching student and event data: $e');
      throw e;
    }
  }

  Future<void> acceptEventRequest() async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference eventRequestRef = FirebaseFirestore.instance
            .collection('EventRequests')
            .doc(widget.requestId);

        DocumentSnapshot<Map<String, dynamic>> eventRequestSnapshot =
            await eventRequestRef.get()
                as DocumentSnapshot<Map<String, dynamic>>;

        if (!eventRequestSnapshot.exists) {
          throw Exception('Request data not found');
        }

        DocumentReference eventRef =
            FirebaseFirestore.instance.collection('events').doc();

        Map<String, dynamic> eventData = eventRequestSnapshot.data()!;
        eventData['status'] = 'accepted';

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          transaction.set(eventRef, eventData);
          transaction.update(eventRequestRef, {
            'status': 'accepted',
            'eventId': eventRef.id,
          });

          // Set the status to 'accepted'
          setState(() {
            status = 'accepted';
          });
        }
      });
    } catch (e) {
      print('Error accepting event request: $e');
      throw e;
    }
  }

  Future<void> rejectEventRequest() async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference eventRequestRef = FirebaseFirestore.instance
            .collection('EventRequests')
            .doc(widget.requestId);

        DocumentSnapshot<Map<String, dynamic>> eventRequestSnapshot =
            await eventRequestRef.get()
                as DocumentSnapshot<Map<String, dynamic>>;

        if (!eventRequestSnapshot.exists) {
          throw Exception('Request data not found');
        }

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          transaction.update(eventRequestRef, {
            'status': 'rejected',
          });

          // Set the status to 'rejected'
          setState(() {
            status = 'rejected';
          });
        }
      });
    } catch (e) {
      print('Error rejecting event request: $e');
      throw e;
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
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: customBlack,
            ),
          ),
        ),
        title: AppText(
          text: "Student details",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).r,
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchStudentAndEventData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final combinedData = snapshot.data!;
              final eventData = combinedData;
              final studentData = combinedData['studentData'];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Center(
                      child: Image.asset(
                        "assets/stu.png",
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: AppText(
                        text: studentData['name'] ?? '',
                        size: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: customBlack,
                      ),
                    ),
                    SizedBox(height: 50.h),
                    DetailsCard(
                      department: studentData['department'] ?? '',
                      event: eventData['eventName'] ?? '',
                      date: eventData['date'] ?? '',
                      time: eventData['time'] ?? '',
                      place: eventData['location'] ?? '',
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: AppText(
                          text: "Description :",
                          size: 14,
                          fontWeight: FontWeight.w400,
                          color: customBlack),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(height: 10.h),
                    AppText(
                      text: studentData['description'] ?? '',
                      size: 12,
                      fontWeight: FontWeight.w400,
                      color: customBlack,
                    ),
                    SizedBox(height: 100.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomButton(
                            btnname: "Accept",
                            click: () {
                              acceptEventRequest();
                            },
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: CustomButton(
                            btnname: "Reject",
                            click: () {
                              rejectEventRequest();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: status.isNotEmpty
                          ? AppText(
                              text: 'Status: $status',
                              size: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: status == 'accepted'
                                  ? Colors.green
                                  : Colors.red,
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
