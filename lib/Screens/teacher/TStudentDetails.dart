import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:college_app/widgets/DetailsCard2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TStudentDetails extends StatefulWidget {
  final String studentId;

  const TStudentDetails({Key? key, required this.studentId}) : super(key: key);

  @override
  _TStudentDetailsState createState() => _TStudentDetailsState();
}

class _TStudentDetailsState extends State<TStudentDetails> {
  late Future<Map<String, dynamic>> _studentDataFuture;

  @override
  void initState() {
    super.initState();
    _studentDataFuture = fetchStudentData();
  }
 Future<void> updateStudentStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.studentId)
          .update({'status': status});
      
      // After updating, refresh the displayed data
      setState(() {
        _studentDataFuture = fetchStudentData();
      });
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<Map<String, dynamic>> fetchStudentData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await FirebaseFirestore.instance.collection('students').doc(widget.studentId).get();

      return studentSnapshot.data() ?? {};
    } catch (e) {
      print("Error fetching student data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Your app bar code remains unchanged...
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _studentDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              Map<String, dynamic> studentData = snapshot.data ?? {};

              // Use the studentData to display details in your design
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30).r,
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundColor: customWhite,
                            backgroundImage: const AssetImage("assets/user.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20).r,
                          child: AppText(
                            text: studentData['name'] ?? '',
                            size: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: customBlack,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                                  left: 50, right: 30, top: 40, bottom: 80)
                              .r,
                          child: StudDet(
                            regno: studentData['registerno'] ?? '',
                            dipartment: studentData['department'] ?? '',
                            phone: studentData['phone'] ?? '',
                            email: studentData['email'] ?? '',
                            status: studentData['status'] ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(btnname: "Accept", click: () {updateStudentStatus('accepted');}),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: CustomButton(btnname: "Reject", click: () {updateStudentStatus('rejected');}),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}