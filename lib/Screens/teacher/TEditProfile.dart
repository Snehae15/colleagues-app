import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TEditProfile extends StatefulWidget {
  TEditProfile({super.key});

  @override
  State<TEditProfile> createState() => _TEditProfileState();
}

class _TEditProfileState extends State<TEditProfile> {
  final name = TextEditingController();
  final department = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final formkey = GlobalKey<FormState>();

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

  void _submitForm() async {
    if (formkey.currentState!.validate()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String teacherId = prefs.getString('teacherId') ?? '';
        await FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .update({
          'name': name.text,
          'department': department.text,
          'phone': phone.text,
          'email': email.text,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile successfully updated!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (error) {
        print('Error updating teacher data: $error');
      }
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
        child: Form(
          key: formkey,
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
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
                      _submitForm();
                    },
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
