import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:college_app/widgets/StudentTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventDetails extends StatefulWidget {
  final String eventId;
  const EventDetails({
    Key? key,
    required this.eventId,
    required String eventName,
    required String hostId,
    required String hostName,
    required String date,
    required String time,
    required String location,
  }) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<Map<String, dynamic>> droplist = [];
  String? selectedvalue;
  Map<String, dynamic>? eventData;
  bool isLoading = true;
  String teacherName = '';
  String teacherDepartment = '';

  @override
  void initState() {
    super.initState();
    fetchEventDetails();
    fetchTeachersData();
  }

  Future<void> fetchTeachersData() async {
    try {
      QuerySnapshot teachersSnapshot =
          await FirebaseFirestore.instance.collection('teachers').get();

      if (teachersSnapshot.docs.isNotEmpty) {
        setState(() {
          droplist = teachersSnapshot.docs
              .map((doc) => {
                    'name': doc['name'] as String,
                    'id': doc.id,
                  })
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching teachers data: $e');
    }
  }

  Future<void> fetchTeacherData() async {
    try {
      String hostId = eventData!['hostId'];
      QuerySnapshot teachersSnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .where(FieldPath.documentId, isEqualTo: hostId)
          .get();

      if (teachersSnapshot.docs.isNotEmpty) {
        DocumentSnapshot teacherSnapshot = teachersSnapshot.docs.first;
        setState(() {
          teacherName = teacherSnapshot['name'];
          teacherDepartment = teacherSnapshot['department'];
        });
      } else {
        print('No teacher found with the given hostId: $hostId');
      }
    } catch (e) {
      print('Error fetching teacher data: $e');
    }
  }

  Future<void> fetchEventDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .get();

      if (eventSnapshot.exists) {
        setState(() {
          eventData = eventSnapshot.data() as Map<String, dynamic>;
          isLoading = false;
          fetchTeacherData();
          print(eventData);
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching event details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addHostToEvent() async {
    if (selectedvalue != null) {
      try {
        await FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventId)
            .update({
          'hostId': selectedvalue,
        });

        Fluttertoast.showToast(
          msg: 'Host added successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.pop(context);
      } catch (e) {
        print('Error adding host to event: $e');
      }
    } else {
      print('Please select a host');
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
          text: "Event details",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: AppText(
                        text: "EVENTS",
                        size: 15,
                        fontWeight: FontWeight.w500,
                        color: maincolor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.w, vertical: 40.h),
                      child: EventDet(
                        name: eventData!['eventName'],
                        description: eventData!['description'],
                        date: eventData!['date'],
                        time: eventData!['time'],
                        status: eventData!['status'],
                        location: eventData!['location'],
                      ),
                    ),
                    const AppText(
                      text: "Description",
                      size: 15,
                      fontWeight: FontWeight.w400,
                      color: customBlack,
                    ),
                    SizedBox(height: 20.h),
                    AppText(
                      text: eventData!['description'],
                      size: 12,
                      fontWeight: FontWeight.w400,
                      color: customBlack,
                    ),
                    SizedBox(height: 20.h),
                    const AppText(
                      text: "Host",
                      size: 15,
                      fontWeight: FontWeight.w500,
                      color: maincolor,
                    ),
                    SizedBox(height: 10.h),
                    StudentTile(
                      name: teacherName,
                      department: teacherDepartment,
                      click: () {},
                      eventId: '',
                      studentId: '',
                      status: '',
                    ),
                    SizedBox(height: 20.h),
                    const AppText(
                      text: "Add Host",
                      size: 15,
                      fontWeight: FontWeight.w500,
                      color: maincolor,
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 50.h,
                      color: Colors.grey[200],
                      child: DropdownButton<String>(
                        isExpanded: true,
                        elevation: 0,
                        underline: const SizedBox(),
                        value: selectedvalue,
                        items: droplist.map<DropdownMenuItem<String>>(
                          (teacher) {
                            return DropdownMenuItem<String>(
                              value: teacher['id'] as String,
                              child: Text(teacher['name'] as String),
                            );
                          },
                        ).toList(),
                        onChanged: (newvalue) {
                          setState(() {
                            selectedvalue = newvalue;
                          });
                        },
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(height: 15.h),
                    CustomButton(
                      btnname: "Confirm",
                      click: addHostToEvent,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
      ),
    );
  }
}

class EventDet extends StatelessWidget {
  const EventDet({
    Key? key,
    required this.date,
    required this.time,
    required this.location,
    required this.name,
    required this.description,
    required this.status,
  }) : super(key: key);

  final String date;
  final String name;
  final String time;
  final String location;
  final String description;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          const AppText(
            text: "Name",
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          ),
          const Text(":"),
          AppText(
            text: name,
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          )
        ]),
        const TableRow(children: [
          SizedBox(height: 15), // SizedBox Widget
          SizedBox(height: 15),
          SizedBox(height: 15),
        ]),
        TableRow(children: [
          const AppText(
            text: "Date",
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          ),
          const Text(":"),
          AppText(
            text: date,
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          )
        ]),
        const TableRow(children: [
          SizedBox(height: 15), // SizedBox Widget
          SizedBox(height: 15),
          SizedBox(height: 15),
        ]),
        TableRow(children: [
          const AppText(
            text: "Time",
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          ),
          const Text(':'),
          AppText(
            text: time,
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          )
        ]),
        const TableRow(children: [
          SizedBox(height: 15), // SizedBox Widget
          SizedBox(height: 15),
          SizedBox(height: 15),
        ]),
        TableRow(children: [
          const AppText(
            text: "Status",
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          ),
          const Text(':'),
          AppText(
            text: status,
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          )
        ]),
        const TableRow(children: [
          SizedBox(height: 15), // SizedBox Widget
          SizedBox(height: 15),
          SizedBox(height: 15),
        ]),
        TableRow(children: [
          const AppText(
            text: "Location",
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          ),
          const Text(':'),
          AppText(
            text: location,
            size: 14,
            fontWeight: FontWeight.w400,
            color: customBlack,
          )
        ]),
      ],
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(5),
      },
    );
  }
}
