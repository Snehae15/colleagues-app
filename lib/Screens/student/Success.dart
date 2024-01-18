import 'package:college_app/Screens/student/StudentHome.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegSuccess extends StatelessWidget {
  const RegSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 250).r,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green[400],
                    size: 100,
                  ),
                  AppText(
                      text: "Thank you!",
                      size: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.green.shade400),
                  const AppText(
                      text: "Registration is successfull",
                      size: 25,
                      fontWeight: FontWeight.w400,
                      color: customBlack)
                ],
              ),
              CustomButton(
                  btnname: "Done",
                  click: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentHome(),
                        ));
                  })
            ]),
      ),
    );
  }
}
