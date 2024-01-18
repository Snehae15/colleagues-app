import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/admin/Addevent.dart';
import 'package:college_app/Screens/admin/EventDetails.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/EventCard.dart';
import 'package:college_app/widgets/EventUpcomingTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(right: 150).r,
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
          const Expanded(
            child: TabBarView(
              children: [EventUpcomingList(), EventPreviousList()],
            ),
          )
        ]),
      ),
    );
  }
}

class EventUpcomingList extends StatelessWidget {
  const EventUpcomingList({Key? key});

  Future<void> deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!.docs;

          return Stack(
            children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  final event = events[index].data() as Map<String, dynamic>;
                  final eventId = events[index].id;
                  return EventUpcomingTila(
                    title: event['eventName'] ?? 'Event Name',
                    click: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(
                            eventId: eventId,
                            eventName: 'eventName',
                            hostId: 'hostId',
                            hostName: '',
                            date: '',
                            time: '',
                            location: '',
                          ),
                        ),
                      );
                    },
                    delete: () {
                      deleteEvent(eventId);
                    },
                  );
                },
                itemCount: events.length,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10).r,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEvent(),
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
        },
      ),
    );
  }
}

class EventPreviousList extends StatelessWidget {
  const EventPreviousList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs;

        return ListView.builder(
          itemBuilder: (context, index) {
            final event = events[index].data() as Map<String, dynamic>;
            return EventCard(
              heading: event['eventName'] ?? 'Event Name',
              date: event['date'] ?? 'Date',
              time: event['time'] ?? 'Time',
              location: event['location'] ?? 'Location',
              eventId: '',
            );
          },
          itemCount: events.length,
        );
      },
    );
  }
}
