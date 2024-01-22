import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/teacher/TEvent.dart';
import 'package:college_app/Screens/teacher/TNotification.dart';
import 'package:college_app/Screens/teacher/TStudentDetails.dart';
import 'package:college_app/Screens/teacher/Tprofile.dart';
import 'package:college_app/constants/colors.dart';
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

//students tab-----------------------

class StudentList extends StatelessWidget {
  const StudentList({Key? key});

  Future<List<Map<String, dynamic>>> fetchStudentsData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> studentsQuery =
          await FirebaseFirestore.instance.collection('students').get();

      List<Map<String, dynamic>> studentsData = [];

      studentsQuery.docs.forEach((doc) {
        Map<String, dynamic> student = doc.data();
        student['id'] = doc.id;
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
                  name: studentData['name'] ?? "Name not available",
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
                  status: studentData['status'] ?? "Status not available",
                );
              },
            );
          }
        },
      ),
    );
  }
}

// StudentTile.dart
class StudentTile extends StatelessWidget {
  final String name;
  final String department;
  final String studentId;
  final String status;
  final void Function() click;

  StudentTile({
    required this.name,
    required this.department,
    required this.studentId,
    required this.status,
    required this.click,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10).r,
      child: ListTile(
        tileColor: Color.fromARGB(255, 208, 219, 238),
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 20,
          child: Image.asset(
            'assets/stu.png',
            fit: BoxFit.fill,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: name,
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
                AppText(
                  text: department,
                  size: 12,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
              ],
            ),
            Text(
              "$status",
              style: TextStyle(color: getStatusColor(status)),
            ),
          ],
        ),
        onTap: click,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6).r),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
