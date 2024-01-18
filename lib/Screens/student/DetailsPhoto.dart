import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/student/AddPhoto.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/EventCard.dart';
import 'package:college_app/widgets/StudentTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsPhoto extends StatelessWidget {
  final String eventId;
  final String requestId;

  const DetailsPhoto({
    Key? key,
    required this.eventId,
    required this.requestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchEventDetails(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic>? eventDetails = snapshot.data;

          if (eventDetails == null) {
            // Handle case where eventDetails is null
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
                              eventDetails['participants'] ?? []),
                          hostId: '',
                        ),
                        PhotoList(),
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

class PrevDetails extends StatelessWidget {
  final String eventId;
  final String eventName;
  final String date;
  final String time;
  final String location;
  final String hostId; // Change to hostId
  final List<String> participants;

  const PrevDetails({
    Key? key,
    required this.eventId,
    required this.eventName,
    required this.date,
    required this.time,
    required this.location,
    required this.hostId,
    required this.participants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('HostId: $hostId');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventCard(
              heading: eventName,
              date: date,
              time: time,
              location: location,
              host: hostId, // Change to hostId
              mode: true,
              eventId: eventId,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: AppText(
                text: 'Participants',
                size: 15,
                fontWeight: FontWeight.w500,
                color: customBlack,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchHostDetails(), // Fetch host details
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String hostName = snapshot.data ?? 'No name';

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        String name = participants[index] ?? 'No name';

                        // Check if the hostId matches the teacherId
                        String teacherId = 'teacherId';
                        if (hostId == teacherId) {
                          print(
                              'Host is a teacher with the following name: $name');
                        }

                        return StudentTile(
                          name: name,
                          department: 'Department',
                          click: () {},
                          eventId: eventId,
                          img: '',
                          studentId: 'studentId',
                        );
                      },
                      itemCount: participants.length,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchHostDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> hostSnapshot =
          await FirebaseFirestore.instance
              .collection('teachers')
              .doc(hostId)
              .get();

      if (hostSnapshot.exists) {
        return hostSnapshot.data()?['name'] ?? 'No name';
      } else {
        throw Exception('Host not found');
      }
    } catch (e) {
      throw Exception('Error fetching host details: $e');
    }
  }
}

class PhotoList extends StatelessWidget {
  const PhotoList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Image.asset(
                  "assets/onam.png",
                  width: 95,
                  height: 95,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPhoto(),
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
      ),
    );
  }
}
