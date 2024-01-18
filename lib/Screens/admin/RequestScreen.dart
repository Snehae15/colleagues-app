import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/admin/StudentDetails.dart';
import 'package:college_app/Screens/admin/TeachersDetails.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/EventRequestTile.dart';
import 'package:college_app/widgets/TeacherTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(right: 180).r,
            child: TabBar(
              tabs: [
                Text(
                  "Teacher",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
                ),
                Text(
                  "Event",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
                )
              ],
              labelColor: maincolor,
              indicatorColor: maincolor,
              unselectedLabelColor: customBlack,
              dividerColor: Colors.transparent,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          const Expanded(
              child: TabBarView(children: [TeacherList(), EventList()]))
        ]),
      ),
    );
  }
}

//Teacher List.................
class TeacherList extends StatefulWidget {
  const TeacherList({Key? key});

  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  late Future<List<Map<String, dynamic>>> teacherDataFuture;

  @override
  void initState() {
    super.initState();
    teacherDataFuture = fetchTeacherdata();
  }

  Future<void> updateTeacherStatus(String teacherId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .update({'status': newStatus});

      // Fetch updated data after status update
      setState(() {
        teacherDataFuture = fetchTeacherdata();
      });
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchTeacherdata() async {
    try {
      QuerySnapshot<Map<String, dynamic>> teachersQuery =
          await FirebaseFirestore.instance.collection('teachers').get();

      List<Map<String, dynamic>> teacherData = [];

      teachersQuery.docs.forEach((doc) {
        Map<String, dynamic> teacher = doc.data();
        teacher['id'] = doc.id; // Include the document ID in the teacher data
        teacherData.add(teacher);
      });

      return teacherData;
    } catch (e) {
      print("Error fetching teachers: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: teacherDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No teachers available'));
        } else {
          // Display data fetched from Firestore
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> teacher = snapshot.data![index];
              return TeacherTile(
                image: teacher['image'] ?? "assets/teac.png",
                name: teacher['name'] ?? "Teacher Name",
                department: teacher['department'] ?? "department",
                status: teacher['status'] ?? "status",
                cancel: () {
                  updateTeacherStatus(teacher['id'], 'rejected');
                },
                accept: () {
                  updateTeacherStatus(teacher['id'], 'accepted');
                },
              );
            },
          );
        }
      },
    );
  }
}

//Event List.................
class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Container(
              height: 37.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6).r,
                color: Colors.blue.shade50,
              ),
              child: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(6).r, color: maincolor),
                tabs: [
                  Text("Students",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  Text("Teacher",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500))
                ],
                labelColor: customWhite,
                unselectedLabelColor: customBlack,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          const Expanded(
              child: TabBarView(
                  children: [StudentRequestList(), TeacherRequestList()]))
        ]),
      ),
    );
  }
}

//Student Event Request List................
class StudentRequestList extends StatelessWidget {
  const StudentRequestList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: fetchEventRequestsWithStudentId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No requests available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final request = snapshot.data!.docs[index];
                final requestId = request.id; // Get the requestId
                return EventRequestTile(
                  image: "assets/teac.png",
                  requestText: request['eventName'],
                  click: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentDetails(requestId: requestId),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future<QuerySnapshot> fetchEventRequestsWithStudentId() async {
  return FirebaseFirestore.instance
      .collection('EventRequests')
      .where('student', isEqualTo: true)
      // .orderBy('timestamp', descending: true)
      .get();
}

//Teacher Event Request List................
class TeacherRequestList extends StatelessWidget {
  const TeacherRequestList({Key? key});

  Future<QuerySnapshot> fetchEventRequestsWithTeacher() async {
    return FirebaseFirestore.instance
        .collection('EventRequests')
        .where('student', isEqualTo: false)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: fetchEventRequestsWithTeacher(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No requests available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final request = snapshot.data!.docs[index];
                final requestId = request.id;

                return EventRequestTile(
                  image: "assets/teac.png",
                  requestText: request['eventName'],
                  click: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TeacherDetails(requestId: requestId),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future<QuerySnapshot> fetchEventRequestsWithTeacher() async {
  return FirebaseFirestore.instance
      .collection('EventRequests')
      .where('student', isEqualTo: false)
      // .orderBy('timestamp', descending: true)
      // // .where('status', isNotEqualTo: 'accepted')
      .get();
}
