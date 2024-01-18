import 'package:college_app/Screens/admin/AdminHome.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatelessWidget {
  AdminLogin({Key? key});

  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customWhite,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 340,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.blue.shade50,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Login",
                    size: 20,
                    fontWeight: FontWeight.w500,
                    color: maincolor,
                  ),
                  TextFormField(
                    controller: username,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.people_alt, color: Colors.grey),
                    ),
                  ),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    btnname: "Login",
                    click: () {
                      // Check if the credentials match 'admin' and 'admin'
                      if (username.text == 'admin@gmail.com' &&
                          password.text == 'Admin@123') {
                        // Navigate to Admin Home page if credentials match
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminHome(),
                          ),
                        );
                      } else {
                        // Show an error dialog or message for incorrect credentials
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Invalid Credentials'),
                              content: Text(
                                  'Please enter correct username and password.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
