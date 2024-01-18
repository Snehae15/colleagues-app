import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/teacher/TEditProfile.dart';
import 'package:college_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TProfile extends StatefulWidget {
  TProfile({super.key});

  @override
  State<TProfile> createState() => _TProfileState();
}

class _TProfileState extends State<TProfile> {
  final name = TextEditingController();
  final department = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTeacherDetails();
  }

  Future<void> fetchTeacherDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String teacherId = prefs.getString('teacherId') ?? '';
      DocumentSnapshot teacherSnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .get();

      if (teacherSnapshot.exists) {
        setState(() {
          name.text = teacherSnapshot['name'] ?? '';
          department.text = teacherSnapshot['department'] ?? '';
          phone.text = teacherSnapshot['phone'] ?? '';
          email.text = teacherSnapshot['email'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching teacher details: $e');
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
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: customBlack,
            ),
          ),
        ),
        title: AppText(
          text: "Profile",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20).r,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TEditProfile()),
                ).then((value) => fetchTeacherDetails());
              },
              child: const Icon(
                Icons.edit,
                color: customBlack,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20).r,
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundColor: customWhite,
                    backgroundImage: const AssetImage("assets/user.png"),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              const AppText(
                text: "Name",
                size: 14,
                fontWeight: FontWeight.w400,
                color: customBlack,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: name,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
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
                text: "Department",
                size: 14,
                fontWeight: FontWeight.w400,
                color: customBlack,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: department,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
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
                text: "Phone No",
                size: 14,
                fontWeight: FontWeight.w400,
                color: customBlack,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: phone,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
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
                text: "Email",
                size: 14,
                fontWeight: FontWeight.w400,
                color: customBlack,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: email,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
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
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String btnname;
  final Function() click;
  const CustomButton({Key? key, required this.btnname, required this.click})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: click,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6).r,
          color: maincolor,
        ),
        child: Center(
          child: AppText(
            text: btnname,
            size: 16,
            fontWeight: FontWeight.w500,
            color: customWhite,
          ),
        ),
      ),
    );
  }
}

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  const AppText({
    Key? key,
    required this.text,
    required this.size,
    required this.fontWeight,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
