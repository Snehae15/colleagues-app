import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:college_app/widgets/EventCard.dart';
import 'package:college_app/widgets/StudentTile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventRegistration extends StatefulWidget {
  final String eventId;

  const EventRegistration({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventRegistrationState createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    checkRegistrationStatus();
  }

  Future<void> checkRegistrationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentId = prefs.getString('studentId') ?? '';
    String eventId = widget.eventId;

    DocumentSnapshot<Map<String, dynamic>>? registrationSnapshot =
        await FirebaseFirestore.instance
            .collection('EventRegistration')
            .where('studentId', isEqualTo: studentId)
            .where('eventId', isEqualTo: eventId)
            .get()
            .then((querySnapshot) => querySnapshot.docs.isNotEmpty
                ? querySnapshot.docs.first
                : null);

    setState(() {
      isRegistered = registrationSnapshot != null;
    });
  }

  Future<void> registerForEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentId = prefs.getString('studentId') ?? '';
    String eventId = widget.eventId;

    if (!isRegistered) {
      DateTime now = DateTime.now();
      await FirebaseFirestore.instance.collection('EventRegistration').add({
        'studentId': studentId,
        'eventId': eventId,
        'registrationDate': Timestamp.fromDate(now),
      });
      setState(() {
        isRegistered = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          text: 'Details',
          size: 18,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Event not found'));
          } else {
            final eventData = snapshot.data!.data() as Map<String, dynamic>;
            return buildEventDetails(eventData);
          }
        },
      ),
    );
  }

  Widget buildEventDetails(Map<String, dynamic> eventData) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventCard(
            heading: eventData['eventName'] ?? 'Event Name',
            date: eventData['date'] ?? 'Event Date',
            time: eventData['time'] ?? 'Event Time',
            location: eventData['location'] ?? 'Event Location',
            eventId: '',
          ),
          const SizedBox(height: 40),
          const AppText(
            text: 'Participants',
            size: 15,
            fontWeight: FontWeight.w500,
            color: customBlack,
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _fetchStudentData(widget.eventId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No participants in this event'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final studentData =
                          snapshot.data![index].data() as Map<String, dynamic>;
                      return StudentTile(
                        // img: studentData['profileImage'] ?? '',
                        name: studentData['name'] ?? "Name",
                        department: studentData['department'] ?? "Department",
                        studentId: '',
                        click: () {},
                        eventId: '', status: '',
                      );
                    },
                  );
                }
              },
            ),
          ),
          CustomButton(
            btnname: 'Register',
            click: () {
              registerForEvent();
            },
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchStudentData(String eventId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('EventRegistration')
        .where('eventId', isEqualTo: eventId)
        .get();
    List<String> studentIds =
        querySnapshot.docs.map((doc) => doc['studentId'].toString()).toList();

    final List<DocumentSnapshot<Map<String, dynamic>>> studentSnapshots =
        await FirebaseFirestore.instance
            .collection('students')
            .where(FieldPath.documentId, whereIn: studentIds)
            .get()
            .then((value) => value.docs);

    return studentSnapshots;
  }
}
