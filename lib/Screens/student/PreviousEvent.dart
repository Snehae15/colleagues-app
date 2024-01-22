import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/student/DetailsPhoto.dart';
import 'package:college_app/widgets/EventTile.dart';
import 'package:flutter/material.dart';

class PreviousEvent extends StatelessWidget {
  const PreviousEvent({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: fetchEventRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while data is being fetched
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No events available'));
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              final eventRequest = snapshot.data!.docs[index];
              final requestId = eventRequest.id;
              final eventId = eventRequest['eventId'];

              return EventTile(
                title: eventRequest['eventName'] ?? 'Untitled',
                click: () {
                  print('Selected requestId: $requestId');
                  print('Corresponding eventId: $eventId');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPhoto(
                        requestId: requestId,
                        eventId: eventId,
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        }
      },
    );
  }

  Future<QuerySnapshot> fetchEventRequests() async {
    DateTime currentDate = DateTime.now();
    DateTime currentDateTime = DateTime.now();
    return FirebaseFirestore.instance
        .collection('EventRequests')
        .where('date', isLessThan: currentDate.toString())
        // .where('time', isLessThan: currentDateTime.toString())
        // // .where('student', isEqualTo: true)
        // .where('status', isEqualTo: 'accept')
        .get();
  }
}
