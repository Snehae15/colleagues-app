import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/Screens/teacher/TSignIn.dart'; // Import TSignIn
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TRegistration extends StatefulWidget {
  const TRegistration({super.key});

  @override
  State<TRegistration> createState() => _TRegistrationState();
}

class _TRegistrationState extends State<TRegistration> {
  final namectrl = TextEditingController();
  final departmnetctrl = TextEditingController();
  final phonectrl = TextEditingController();
  final emailctrl = TextEditingController();
  final passwordctrl = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addToFirestore() async {
    try {
      await _firestore.collection('teachers').add({
        'name': namectrl.text,
        'department': departmnetctrl.text,
        'phone': phonectrl.text,
        'email': emailctrl.text,
        'password': passwordctrl.text,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'accepted'
      });

      // Show toast message
      Fluttertoast.showToast(
        msg: "Successfully registered",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to TSignIn
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TSignIn()),
      );
    } catch (e) {
      print('Error adding to Firestore: $e');
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
            color: customBlack),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 60).r,
                child: const AppText(
                    text: "Name",
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: customBlack),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: namectrl,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor))),
                ),
              ),
              const AppText(
                  text: "Department",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: departmnetctrl,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor))),
                ),
              ),
              const AppText(
                  text: "Phone No",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: phonectrl,
                  validator: (value) {
                    if (value?.length != 10) {
                      return 'Please enter a 10-digit phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor))),
                ),
              ),
              const AppText(
                  text: "Email",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: emailctrl,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                      return 'Enter a valid email!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor))),
                ),
              ),
              const AppText(
                  text: "Password",
                  size: 14,
                  fontWeight: FontWeight.w400,
                  color: customBlack),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                child: TextFormField(
                  controller: passwordctrl,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100).r,
                child: CustomButton(
                  btnname: "Submit",
                  click: _submitForm,
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
