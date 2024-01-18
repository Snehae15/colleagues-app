import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/teacher/Tprofile.dart';
import 'package:college_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventRequest extends StatefulWidget {
  const EventRequest({super.key});

  @override
  State<EventRequest> createState() => _EventRequestState();
}

class _EventRequestState extends State<EventRequest> {
  final eventname = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final place = TextEditingController();
  final description = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      // Date is selected
      setState(() {
        date.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Time is selected
      setState(() {
        time.text = pickedTime.format(context);
      });
    }
  }

  Future<void> addEventDataToFirestore(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String studentId = prefs.getString('studentId') ?? '';

      await FirebaseFirestore.instance.collection('EventRequests').add({
        'eventName': eventname.text,
        'date': date.text,
        'time': time.text,
        'location': place.text,
        'description': description.text,
        'StudentId': studentId,
        'status': 'pending',
        'student': true // Set the default status as 'accepted'
      });

      Navigator.pop(
          context); // Go back to the previous screen after adding data
    } catch (e) {
      print('Error adding event data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20).r,
          child: InkWell(
            onTap: () {
              Navigator.pop(context); // back arrow Function...........
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: customBlack,
            ),
          ),
        ),
        title: AppText(
          text: "Add Event",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25).r,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: "Event Name",
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: customBlack,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                    child: TextFormField(
                      controller: eventname,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 15.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor),
                        ),
                      ),
                    ),
                  ),
                  const AppText(
                    text: "Date",
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: customBlack,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: date,
                            onTap: () {
                              _selectDate(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: 15.w,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6).r,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6).r,
                                borderSide: const BorderSide(color: maincolor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppText(
                    text: "Time",
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: customBlack,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: time,
                            onTap: () {
                              _selectTime(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: 15.w,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6).r,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6).r,
                                borderSide: const BorderSide(color: maincolor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppText(
                    text: "Location",
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: customBlack,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                    child: TextFormField(
                      controller: place,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 15.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor),
                        ),
                      ),
                    ),
                  ),
                  const AppText(
                    text: "Description",
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: customBlack,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5).r,
                    child: TextFormField(
                      controller: description,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                btnname: "Submit",
                click: () {
                  addEventDataToFirestore(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
