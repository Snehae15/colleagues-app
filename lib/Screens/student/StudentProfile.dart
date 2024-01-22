import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/student/studentedit%20profile.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfile extends StatefulWidget {
  StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late SharedPreferences _prefs;
  late String _studentId;

  final name = TextEditingController();
  final department = TextEditingController();
  final registerno = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchStudentId();
  }

  Future<void> _fetchStudentId() async {
    _prefs = await SharedPreferences.getInstance();
    _studentId = _prefs.getString('studentId') ?? '';
    _fetchStudentData(); // Call _fetchStudentData here
    setState(() {});
  }

  Future<void> _fetchStudentData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(_studentId)
              .get();

      if (studentSnapshot.exists) {
        print("Student data fetched successfully: ${studentSnapshot.data()}");
        setState(() {
          name.text = studentSnapshot['name'] ?? '';
          department.text = studentSnapshot['department'] ?? '';
          registerno.text = studentSnapshot['registerno'] ?? '';
          phone.text = studentSnapshot['phone'] ?? '';
          email.text = studentSnapshot['email'] ?? '';
        });
      } else {
        print("Student data does not exist for studentId: $_studentId");
      }
    } catch (e) {
      print('Error fetching student details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
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
          IconButton(
            icon: Icon(Icons.edit, color: customBlack),
            onPressed: () async {
              await _fetchStudentData();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentEditProfile(
                    studentId: _studentId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: customWhite,
                      backgroundImage: AssetImage("assets/user.png"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                AppText(
                  text: "Name",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: TextFormField(
                    controller: name,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                        borderSide: BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ),
                AppText(
                  text: "Department",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: TextFormField(
                    controller: department,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                        borderSide: BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ),
                AppText(
                  text: "Register No",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: TextFormField(
                    controller: registerno,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                        borderSide: BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ),
                AppText(
                  text: "Phone No",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: TextFormField(
                    controller: phone,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                        borderSide: BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ),
                AppText(
                  text: "Email",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: TextFormField(
                    controller: email,
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty || value == null)
                        return "Email is required";
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6).r,
                        borderSide: BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
