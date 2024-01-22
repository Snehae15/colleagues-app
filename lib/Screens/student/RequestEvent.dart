import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/teacher/Tprofile.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/DetailsCard.dart';
import 'package:college_app/widgets/StudentTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestEvent extends StatefulWidget {
  final String eventId;
  final String requestId;

  const RequestEvent({Key? key, required this.eventId, required this.requestId})
      : super(key: key);

  @override
  State<RequestEvent> createState() => _RequestEventState();
}

class _RequestEventState extends State<RequestEvent> {
  String studentId = '';
  String studentName = '';
  String studentDepartment = '';

  @override
  void initState() {
    super.initState();
    fetchStudentDetails();
  }

  Future<void> fetchStudentDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    studentId = prefs.getString('studentId') ?? '';

    // Fetch student details based on studentId
    DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .get();

    if (studentSnapshot.exists) {
      setState(() {
        studentName = studentSnapshot['name'];
        studentDepartment = studentSnapshot['department'];
      });
    }
  }

  Future<Map<String, dynamic>> fetchEventData(String requestId) async {
    // Fetch event details based on requestId
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('EventRequests')
        .doc(requestId)
        .get();

    if (eventSnapshot.exists) {
      return {
        'eventName': eventSnapshot['eventName'],
        'date': eventSnapshot['date'],
        'time': eventSnapshot['time'],
        'location': eventSnapshot['location'],
        'description': eventSnapshot['description'],
      };
    }

    return {};
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
          text: "Details",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: SingleChildScrollView(
          child: Column(
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
                  text: studentName,
                  size: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 30, top: 30).r,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: fetchEventData(widget.requestId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      Map<String, dynamic> eventData = snapshot.data ?? {};

                      return DetailsCard(
                        event: eventData['eventName'] ?? 'Unknown',
                        date: eventData['date'] ?? 'Unknown',
                        time: eventData['time'] ?? 'Unknown',
                        place: eventData['location'] ?? 'Unknown',
                        department: '',
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: AppText(
                  text: "Host",
                  size: 15,
                  fontWeight: FontWeight.w500,
                  color: maincolor,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              StudentTile(
                name: 'Department',
                department: studentDepartment,
                click: () {},
                studentId: studentId,
                eventId: widget.eventId,
                status: '',
              ),
              SizedBox(
                height: 20.h,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: AppText(
                  text: "Description :",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: fetchEventData(widget.requestId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      Map<String, dynamic> eventData = snapshot.data ?? {};

                      return AppText(
                        text: eventData['description'] ?? 'Unknown',
                        size: 12,
                        fontWeight: FontWeight.w400,
                        color: customBlack,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
