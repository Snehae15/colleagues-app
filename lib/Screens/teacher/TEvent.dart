import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/teacher/TAddEvent.dart';
import 'package:college_app/Screens/teacher/TEventPhoto.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/EventTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getEventsForTeacher() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String teacherId = prefs.getString('teacherId') ?? '';
  print(teacherId);

  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('events')
      .where('hostId', isEqualTo: teacherId)
      .get();

  List<Map<String, dynamic>> events = querySnapshot.docs.map((doc) {
    return doc.data();
  }).toList();
  print(events);
  return events;
}

Future<List<Map<String, dynamic>>> previousEvent() async {
  DateTime currentDate = DateTime.now();
  DateTime currentDateWithoutTime = DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day,
  ).toLocal();
  String formattedDate = currentDateWithoutTime.toIso8601String().split('T')[0];
  print('current date without time: $formattedDate');

  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('events')
      .where('date', isLessThan: formattedDate)
      .get();

  List<Map<String, dynamic>> events = querySnapshot.docs.map((doc) {
    Map<String, dynamic> eventData = doc.data() ?? {};
    eventData['eventId'] = doc.id;
    return eventData;
  }).toList();
  print('$events....previous events');
  return events;
}

//event tab------------------------------
class TEvent extends StatelessWidget {
  const TEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 150, top: 50).r,
              child: TabBar(
                tabs: [
                  Text(
                    "Upcoming",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
                  ),
                  Text(
                    "Previous",
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
            Expanded(
                child: TabBarView(children: [UpEventList(), PreviousList()])),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TAddEvent(),
              ),
            );
          }, // Event Add Function...........
          shape: const CircleBorder(),
          backgroundColor: maincolor,
          child: const Icon(
            Icons.add,
            color: customWhite,
            size: 50,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

// Upcoming Event List .................
class UpEventList extends StatelessWidget {
  const UpEventList({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getEventsForTeacher(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final eventId = events[index]['eventId'];
              return events[index]['eventName'] != null
                  ? Column(
                      children: [
                        ListTile(
                          tileColor: maincolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          title: Text(
                            events[index]['eventName'],
                            style: TextStyle(color: customWhite),
                          ),
                          onTap: () {
                            print('selected eventId: $eventId');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TEventPhoto(eventId: eventId)));
                          },
                        ),
                        SizedBox(height: 8), // Adjust the height as needed
                      ],
                    )
                  : SizedBox.shrink();
            },
          );
        } else {
          return Center(child: Text('No upcoming events.'));
        }
      },
    );
  }
}

//Previous EventList .................
class PreviousList extends StatelessWidget {
  const PreviousList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: previousEvent(), // Fetch previous events
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final events = snapshot.data!;
          print('$events....ds');

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final eventName =
                  events[index]['eventName'] ?? 'Event Name Missing';
              final eventId = events[index]['eventId'];
              print('__________$eventId'); // Extract eventId

              return EventTile(
                title: eventName ?? 'Event Name Missing',
                click: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TEventPhoto(eventId: eventId)));
                },
              );
            },
          );
        } else {
          return Center(child: Text('No previous events.'));
        }
      },
    );
  }
}
