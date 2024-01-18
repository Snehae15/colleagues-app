import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/student/SignIn.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentRegister extends StatefulWidget {
  const StudentRegister({Key? key});

  @override
  State<StudentRegister> createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  final TextEditingController name = TextEditingController();
  final TextEditingController department = TextEditingController();
  final TextEditingController registerno = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addToFirestore() async {
    try {
      await _firestore.collection('students').add({
        'name': name.text,
        'department': department.text,
        'registerno': registerno.text,
        'phone': phone.text,
        'email': email.text,
        'password': password.text,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      Fluttertoast.showToast(
        msg: "Successfully registered!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StudentSignIn()), // Replace 'SignIn' with your actual SignIn screen
      );
    } catch (e) {
      print('Error adding to Firestore: $e');
      Fluttertoast.showToast(
        msg: "Registration failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _submitForm() {
    if (formkey.currentState!.validate()) {
      _addToFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "Registration",
          size: 18.sp,
          fontWeight: FontWeight.w500,
          color: customBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: AppText(
                    text: "Name",
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: customBlack,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.length != 10) {
                        return 'Please enter a 10-digit phone number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
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
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ),
                AppText(
                  text: "Password",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: maincolor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: CustomButton(
                    btnname: "Submit",
                    click: _submitForm,
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
