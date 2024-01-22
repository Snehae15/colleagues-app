import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/student/EventRegistration.dart';
import 'package:college_app/Screens/student/EventRequest.dart';
import 'package:college_app/Screens/student/RequestEvent.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/EventTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SRequestScreen extends StatelessWidget {
  const SRequestScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 180).r,
              child: TabBar(
                tabs: [
                  Text(
                    "Event",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    "Request",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
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
              child: TabBarView(
                children: [EventList(), RequstList()],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Upcoming EventList .................
class EventList extends StatelessWidget {
  const EventList({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No events available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final event = snapshot.data!.docs[index];
              return EventTile(
                title: event['eventName'] ?? 'Untitled',
                click: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventRegistration(
                        eventId: event.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Future<QuerySnapshot> fetchEvents() async {
    return FirebaseFirestore.instance.collection('events').get();
  }
}

// Upcoming Request List .................
class RequstList extends StatelessWidget {
  const RequstList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: FutureBuilder<QuerySnapshot>(
            future: fetchEventRequests(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No event requests available'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final request = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10).r,
                      child: ListTile(
                        title: Text(
                          request['eventName'] ?? 'Untitled',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: customWhite,
                          ),
                        ),
                        tileColor: maincolor,
                        trailing: AppText(
                          text: request['status'],
                          size: 12,
                          fontWeight: FontWeight.w500,
                          color: customWhite,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestEvent(
                                requestId: request.id,
                                eventId: 'eventId',
                              ),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6).r,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 0.0,
          left: 0.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventRequest(),
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
        ),
      ],
    );
  }

  Future<QuerySnapshot> fetchEventRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentId = prefs.getString('studentId') ?? '';

    return FirebaseFirestore.instance
        .collection('EventRequests')
        .where('StudentId', isEqualTo: studentId)
        .where('student', isEqualTo: true)
        .get();
  }
}
