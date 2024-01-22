import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:college_app/widgets/DetailsCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherDetails extends StatefulWidget {
  final String requestId;

  const TeacherDetails({Key? key, required this.requestId}) : super(key: key);

  @override
  _TeacherDetailsState createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = '';
  }

  // bool isActionCompleted = false;

  Future<Map<String, dynamic>> fetchTeacherAndEventData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> requestSnapshot =
          await FirebaseFirestore.instance
              .collection('EventRequests')
              .doc(widget.requestId)
              .get();

      if (!requestSnapshot.exists) {
        throw Exception('Request data not found');
      }

      String? teacherId = requestSnapshot.data()?['teacherId'];

      if (teacherId == null) {
        throw Exception('Teacher ID not found');
      }

      DocumentSnapshot<Map<String, dynamic>> teacherSnapshot =
          await FirebaseFirestore.instance
              .collection('teachers')
              .doc(teacherId)
              .get();

      if (!teacherSnapshot.exists) {
        throw Exception('Teacher data not found');
      }

      Map<String, dynamic> eventData = requestSnapshot.data()!;
      Map<String, dynamic> teacherData = teacherSnapshot.data()!;

      // Combining both data into a single map
      Map<String, dynamic> combinedData = {
        ...eventData,
        'teacherData': teacherData,
      };

      return combinedData;
    } catch (e) {
      print('Error fetching student and event data: $e');
      throw e;
    }
  }

  Future<void> acceptEventRequest(BuildContext context) async {
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
        transaction.set(eventRef, eventData);
        transaction.update(eventRequestRef, {
          'status': 'accepted',
          'eventId': eventRef.id,
        });

        // Update the status variable
        setState(() {
          status = 'accepted';
        });
      });
    } catch (e) {
      print('Error accepting event request: $e');
      throw e;
    }
  }

  Future<void> rejectEventRequest(BuildContext context) async {
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

        transaction.update(eventRequestRef, {
          'status': 'rejected',
        });

        // Update the status variable
        setState(() {
          status = 'rejected';
        });
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
            text: "Teachers details",
            size: 18.sp,
            fontWeight: FontWeight.w500,
            color: customBlack),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchTeacherAndEventData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final teacherData = snapshot.data?['teacherData'];
              final eventData = snapshot.data;

              final descriptionText = eventData?['description'] ?? '';

              return Stack(children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30).r,
                        child: Image.asset(
                          "assets/stu.png",
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: AppText(
                            text: teacherData?['name'] ?? '',
                            size: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: customBlack),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 50, right: 30, top: 50)
                                .r,
                        child: DetailsCard(
                            department: teacherData?['department'] ?? '',
                            event: eventData?['eventName'] ?? '',
                            date: eventData?['date'] ?? '',
                            time: eventData?['time'] ?? '',
                            place: eventData?['location'] ?? ''),
                      ),
                      SizedBox(
                        height: 40.h,
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
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: AppText(
                            text: descriptionText,
                            size: 12,
                            fontWeight: FontWeight.w400,
                            color: customBlack),
                      ),
                      SizedBox(
                        height: 90.h,
                      ),
                      SizedBox(height: 90.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomButton(
                              btnname: "Accept",
                              click: () {
                                acceptEventRequest(context);
                              },
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: CustomButton(
                              btnname: "Reject",
                              click: () {
                                rejectEventRequest(context);
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
                ),
              ]);
            }
          },
        ),
      ),
    );
  }
}
