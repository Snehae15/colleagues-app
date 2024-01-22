import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/student/photolist.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Event details view
class DetailsPhoto extends StatelessWidget {
  final String eventId;

  const DetailsPhoto({
    Key? key,
    required this.eventId,
    required String requestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchEventDetails(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic>? eventDetails = snapshot.data;
          if (eventDetails == null) {
            return Text('Event details not available');
          }

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20),
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
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 240, top: 20),
                    child: TabBar(
                      tabs: [
                        Text(
                          "Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "Photo",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                      labelColor: maincolor,
                      indicatorColor: maincolor,
                      unselectedLabelColor: customBlack,
                      dividerColor: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        PrevDetails(
                          eventId: eventId,
                          eventName: eventDetails['eventName'] ?? 'Untitled',
                          date: eventDetails['date'] ?? 'No date',
                          time: eventDetails['time'] ?? 'No time',
                          location: eventDetails['location'] ?? 'No location',
                          participants: List<String>.from(
                            eventDetails['participants'] ?? [],
                          ),
                          hostId: '',
                          teacherId: 'teacherId',
                          eventDetails: {},
                        ),
                        // Replace the placeholder below with your PhotoList widget
                        PhotoList(eventId: eventId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> fetchEventDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get();

      if (eventSnapshot.exists) {
        return eventSnapshot.data()!;
      } else {
        throw Exception('Event not found');
      }
    } catch (e) {
      throw Exception('Error fetching event details: $e');
    }
  }
}

//participant list
class StudentTile extends StatelessWidget {
  final String name;
  final String department;

  const StudentTile({
    Key? key,
    required this.name,
    required this.department,
    required Null Function() click,
    required status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color.fromARGB(255, 203, 221, 235),
        child: ListTile(
          title: Text("Name: $name"),
          subtitle: Text("Department: $department"),
        ));
  }
}

class PrevDetails extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String date;
  final String time;
  final String location;
  final List<String> participants;
  final String hostId;
  final String teacherId;
  final Map<String, dynamic> eventDetails;

  const PrevDetails({
    Key? key,
    required this.eventId,
    required this.eventName,
    required this.date,
    required this.time,
    required this.location,
    required this.participants,
    required this.hostId,
    required this.teacherId,
    required this.eventDetails,
  }) : super(key: key);

  @override
  _PrevDetailsState createState() => _PrevDetailsState();
}

class _PrevDetailsState extends State<PrevDetails> {
  String hostName = 'Host not assigned';

  @override
  void initState() {
    super.initState();
    fetchHostName();
  }

  Future<void> fetchHostName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(widget.eventId)
              .get();

      if (eventSnapshot.exists) {
        String teacherId = eventSnapshot['teacherId'] ?? '';
        if (teacherId.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> teacherSnapshot =
              await FirebaseFirestore.instance
                  .collection('teachers')
                  .doc(teacherId)
                  .get();

          if (teacherSnapshot.exists) {
            setState(() {
              hostName = teacherSnapshot['name'] ?? 'Host not assigned';
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching host name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventCard(
              heading: widget.eventName,
              date: widget.date,
              time: widget.time,
              location: widget.location,
              host: hostName, // Updated value based on fetchHostName
              mode: true,
              eventId: widget.eventId,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: AppText(
                text: 'participants',
                size: 15,
                fontWeight: FontWeight.w500,
                color: customBlack,
              ),
            ),
            FutureBuilder(
              future: getParticipants(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> participants = snapshot.data ?? [];

                  if (participants.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => StudentTile(
                          name: participants[index]['name'] ?? "Name",
                          department:
                              participants[index]['department'] ?? "Department",
                          click: () {},
                          status: null,
                        ),
                        itemCount: participants.length,
                      ),
                    );
                  } else {
                    return Text('No participants available.');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getParticipants() async {
    QuerySnapshot<Map<String, dynamic>> participantsSnapshot =
        await FirebaseFirestore.instance
            .collection('EventRegistration')
            .where('eventId', isEqualTo: widget.eventId)
            .get();

    List<Future<Map<String, dynamic>>> studentFutures =
        participantsSnapshot.docs.map((participantDoc) async {
      String studentId = participantDoc['studentId'].toString();
      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .get();

      Map<String, dynamic> studentData = studentSnapshot.data() ?? {};
      studentData['id'] = studentSnapshot.id;

      return studentData;
    }).toList();

    List<Map<String, dynamic>> participantsData =
        await Future.wait(studentFutures);

    return participantsData;
  }
}
