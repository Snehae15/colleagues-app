// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:college_app/constants/colors.dart';
// import 'package:college_app/widgets/AppText.dart';
// import 'package:college_app/widgets/EventCard.dart';
// import 'package:college_app/widgets/StudentTile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class TEventPhoto extends StatelessWidget {
//   final String eventId;

//   const TEventPhoto({Key? key, required this.eventId}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//           appBar: AppBar(
//             leading: Padding(
//               padding: const EdgeInsets.only(left: 20).r,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context); // back arrow Function...........
//                 },
//                 child: const Icon(
//                   Icons.arrow_back_ios,
//                   color: customBlack,
//                 ),
//               ),
//             ),
//             title: AppText(
//                 text: "Details",
//                 size: 18.sp,
//                 fontWeight: FontWeight.w500,
//                 color: customBlack),
//             centerTitle: true,
//           ),
//           body: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 240, top: 20).r,
//                 child: TabBar(
//                   tabs: [
//                     Text(
//                       "Details",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500, fontSize: 16.sp),
//                     ),
//                     Text(
//                       "Photo",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500, fontSize: 16.sp),
//                     )
//                   ],
//                   labelColor: maincolor,
//                   indicatorColor: maincolor,
//                   unselectedLabelColor: customBlack,
//                   dividerColor: Colors.transparent,
//                 ),
//               ),
//               Expanded(
//                   child: TabBarView(children: [
//                 PrevDetails(
//                   eventId: eventId,
//                 ),
//                 PhotoList()
//               ])),
//             ],
//           )),
//     );
//   }
// }

// //Details tab Screen..............................
// class PrevDetails extends StatelessWidget {
//   final String eventId;

//   PrevDetails(Set<dynamic> set, {Key? key, required this.eventId})
//       : super(key: key);

//   Future<Map<String, dynamic>> getEventDetails() async {
//     DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
//         await FirebaseFirestore.instance
//             .collection('events')
//             .doc(eventId)
//             .get();

//     return eventSnapshot.data() ?? {};
//   }

//   Future<List<Map<String, dynamic>>> getParticipants() async {
//     QuerySnapshot<Map<String, dynamic>> participantsSnapshot =
//         await FirebaseFirestore.instance
//             .collection('EventRegistration')
//             .where('eventId', isEqualTo: eventId)
//             .get();

//     List<Future<Map<String, dynamic>>> studentFutures =
//         participantsSnapshot.docs.map((participantDoc) async {
//       String studentId = participantDoc['studentId'].toString();
//       DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
//           await FirebaseFirestore.instance
//               .collection('students')
//               .doc(studentId)
//               .get();

//       Map<String, dynamic> studentData = studentSnapshot.data() ?? {};
//       studentData['id'] =
//           studentSnapshot.id; // Add student document ID to the data

//       return studentData;
//     }).toList();

//     List<Map<String, dynamic>> participantsData =
//         await Future.wait(studentFutures);

//     return participantsData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(25).r,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FutureBuilder<Map<String, dynamic>>(
//               future: getEventDetails(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                   final eventDetails = snapshot.data!;

//                   return EventCard(
//                     heading: eventDetails['eventName'] ?? 'Heading Missing',
//                     date: eventDetails['date'] ?? 'Date Missing',
//                     time: eventDetails['time'] ?? 'Time Missing',
//                     location: eventDetails['location'] ?? 'Location Missing',
//                     eventId: '',
//                   );
//                 } else {
//                   return Text('Event details not available.');
//                 }
//               },
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 20.h),
//               child: const AppText(
//                 text: 'Participants',
//                 size: 15,
//                 fontWeight: FontWeight.w500,
//                 color: customBlack,
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: FutureBuilder<List<Map<String, dynamic>>>(
//                   future: getParticipants(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                       final participants = snapshot.data!;
//                       print(participants);

//                       return ListView.builder(
//                         itemBuilder: (context, index) => StudentTile(
//                           // img: participants[index]['profilePic'] ?? "assets/teac.png",
//                           name: participants[index]['name'] ?? "Name",
//                           department:
//                               participants[index]['department'] ?? "Department",
//                           eventId: eventId,
//                           studentId: participants[index]['id'],
//                           mode:
//                               true, // if mode true cancel button will be shown.....
//                           click: () {}, img: '',
//                         ),
//                         itemCount: participants.length,
//                       );
//                     } else {
//                       return Text('No participants available.');
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // photo list screen...............................
// class PhotoList extends StatelessWidget {
//   const PhotoList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Padding(
//       padding: const EdgeInsets.only(top: 20).r,
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4, crossAxisSpacing: 1, mainAxisSpacing: 1),
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Image.asset(
//             "assets/onam.png",
//             width: 95,
//             height: 95,
//           );
//         },
//       ),
//     ));
//   }
// }
