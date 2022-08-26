import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/screens/bottomNavBar.dart';

import '../auth/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final emailField = TextFormField(
      autofocus: false,
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email required";
        } else {
          return null;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Color.fromARGB(255, 65, 175, 203),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 65, 175, 203), width: 2),
          borderRadius: BorderRadius.circular(32),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 65, 175, 203), width: 1),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );

    // passwordField
    final passField = TextFormField(
      autofocus: false,
      controller: _password,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password required";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Color.fromARGB(255, 65, 175, 203),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 65, 175, 203), width: 2),
          borderRadius: BorderRadius.circular(32),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 65, 175, 203), width: 1),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.1),
                const Text(
                  "LogIn",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.04),
                Image.asset(
                  "images/logo.png",
                  height: 150,
                ),
                SizedBox(height: size.height * 0.03),
                emailField,
                SizedBox(height: size.height * 0.03),
                passField,
                SizedBox(height: size.height * 0.03),
                Material(
                  elevation: 5,
                  color: Color.fromARGB(255, 65, 175, 203),
                  borderRadius: BorderRadius.circular(32),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    child: Text("LogIn"),
                    onPressed: () async {
                      try {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 65, 175, 203),
                                  ),
                                ),
                                SizedBox(width: 18),
                                Text(
                                  "Checking",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 65, 175, 203),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                        var _auth = FirebaseAuth.instance;
                        UserCredential user =
                            await _auth.signInWithEmailAndPassword(
                                email: _email.text, password: _password.text);
                        assert(user != null);
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Successfully logged in");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-email') {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: "Invalid Email");
                        } else if (e.code == 'user-not-found') {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: "User not found");
                        } else if (e.code == 'wrong-password') {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: "Wrong Password");
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" Don't have an acoount? "),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          });
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            color: Color.fromARGB(255, 65, 175, 203),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
