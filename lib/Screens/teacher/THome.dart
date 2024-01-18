import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/teacher/TEvent.dart';
import 'package:college_app/Screens/teacher/TNotification.dart';
import 'package:college_app/Screens/teacher/TStudentDetails.dart';
import 'package:college_app/Screens/teacher/Tprofile.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/StudentTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class THome extends StatelessWidget {
  const THome({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20).r,
          child: Column(children: [
            const Expanded(
                child: TabBarView(children: [StudentList(), TEvent()])),
            Container(
              height: 60.h,
              decoration: BoxDecoration(
                  color: customWhite,
                  border: Border.all(color: maincolor),
                  borderRadius: BorderRadius.circular(50).r),
              child: Padding(
                padding: const EdgeInsets.all(4).r,
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: maincolor),
                  tabs: [
                    Text("Students",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    Text("Event",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600))
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: customWhite,
                  unselectedLabelColor: customBlack,
                  dividerColor: Colors.transparent,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class StudentList extends StatelessWidget {
  const StudentList({Key? key});

  Future<List<Map<String, dynamic>>> fetchStudentsData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> studentsQuery =
          await FirebaseFirestore.instance.collection('students').get();

      List<Map<String, dynamic>> studentsData = [];

      studentsQuery.docs.forEach((doc) {
        Map<String, dynamic> student = doc.data();
        student['id'] = doc.id; // Include the document ID in the student data
        studentsData.add(student);
      });

      return studentsData;
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customWhite,
        title: AppText(
          text: "Students List",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TProfile(),
                ),
              );
            },
            child: const Icon(Icons.person_2_outlined),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TNotification(),
                ),
              );
            },
            child: const Icon(Icons.notifications_active_outlined),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchStudentsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var studentData = snapshot.data![index];
                print('Student ID: ${studentData['id']}');
                return StudentTile(
                  // img: studentData['img'] ?? "assets/user.png",
                  name: studentData['name'] ?? "Name not available",
                  eventId: '',
                  studentId: '',
                  department:
                      studentData['department'] ?? "Department not available",
                  click: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TStudentDetails(
                            studentId: snapshot.data![index]['id']),
                      ),
                    );
                  },
                  img: '',
                );
              },
            );
          }
        },
      ),
    );
  }
}
