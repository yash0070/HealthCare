import 'package:flutter/material.dart';
import 'package:health_app/authDr.dart/loginauth.dart';

import '../auth/login.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              "Health Care ",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.orange),
            ),
            SizedBox(
              height: size.height * 0.2,
            ),
            const Text(
              "You want to Login  ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Material(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(15),
              child: MaterialButton(
                minWidth: double.infinity,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorLogin()));
                },
                child: Text("As a Doctor "),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Material(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(15),
              child: MaterialButton(
                minWidth: double.infinity,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("As a User "),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
