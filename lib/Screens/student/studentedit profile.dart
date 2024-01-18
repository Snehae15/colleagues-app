import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentEditProfile extends StatefulWidget {
  final String studentId;

  StudentEditProfile({required this.studentId, Key? key}) : super(key: key);

  @override
  State<StudentEditProfile> createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
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
    _studentId = widget.studentId;
    _fetchStudentEditData();
  }

  Future<void> _fetchStudentEditData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(_studentId)
              .get();

      if (studentSnapshot.exists) {
        setState(() {
          name.text = studentSnapshot['name'] ?? '';
          department.text = studentSnapshot['department'] ?? '';
          registerno.text = studentSnapshot['registerno'] ?? '';
          phone.text = studentSnapshot['phone'] ?? '';
          email.text = studentSnapshot['email'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching student details: $e');
    }
  }

  Future<void> _updateStudentData() async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(_studentId)
          .update({
        'name': name.text,
        'department': department.text,
        'registerno': registerno.text,
        'phone': phone.text,
        // You may want to exclude email from being updated here
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully!'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print('Error updating student details: $e');
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
          text: "Edit Profile",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                AppText(
                  text: "Name",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                  child: TextFormField(
                    controller: name,
                    // You can now edit the name
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
                        borderSide: const BorderSide(color: maincolor),
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
                  padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                  child: TextFormField(
                    controller: department,
                    // You can now edit the department
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
                        borderSide: const BorderSide(color: maincolor),
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
                  padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                  child: TextFormField(
                    controller: registerno,
                    // You can now edit the register number
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
                        borderSide: const BorderSide(color: maincolor),
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
                  padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                  child: TextFormField(
                    controller: phone,
                    // You can now edit the phone number
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
                        borderSide: const BorderSide(color: maincolor),
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
                  padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                  child: TextFormField(
                    controller: email,
                    readOnly: true,
                    // You can now edit the email
                    validator: (value) {
                      if (value!.isEmpty || value == null) return "Email";
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
                        borderSide: const BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50).r,
                  child: CustomButton(
                    btnname: "Submit",
                    click: () {
                      if (formKey.currentState!.validate()) {
                        _updateStudentData();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
