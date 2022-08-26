import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/screens/bottomNavBar.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        padding: EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.1),
              const Text(
                "SignUp",
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
                borderRadius: BorderRadius.circular(32),
                color: Color.fromARGB(255, 65, 175, 203),
                child: MaterialButton(
                  minWidth: double.infinity,
                  child: Text("SignUp"),
                  onPressed: () async {
                    try {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromARGB(255, 65, 175, 203),
                                ),
                              ),
                              SizedBox(width: 18),
                              Text(
                                "Working....",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 65, 175, 203),
                                ),
                              )
                            ],
                          ),
                        ),
                      );

                      var auth = FirebaseAuth.instance;
                      UserCredential user =
                          await auth.createUserWithEmailAndPassword(
                              email: _email.text, password: _password.text);
                      assert(user != null);
                      if (user != null) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Successfully created");

                        // FirebaseFirestore.instance
                        //     .collection('Users')
                        //     .add({"email": _email});
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Email already taken");
                      } else if (e.code == 'invalid-email') {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "invalid Email");
                      } else if (e.code == 'weak-password') {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "Passwor should be atleast 6 characters");
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
                  Text(" Already have an acoount? "),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        });
                      },
                      child: Text(
                        "LogIn",
                        style: TextStyle(
                          color: Color.fromARGB(255, 65, 175, 203),
                        ),
                      )),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Divider(
                color: Colors.black.withOpacity(0.3),
              ),
              Text("OR"),
              SizedBox(height: size.height * 0.03),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     GestureDetector(
              //       onTap: () async {
              //         final GoogleSignIn googleSignIn = GoogleSignIn();

              //         FirebaseAuth auth = FirebaseAuth.instance;

              //         User? user;

              //         final GoogleSignInAccount? googleSignInAccount =
              //             await googleSignIn.signIn();

              //         if (googleSignInAccount != null) {
              //           final GoogleSignInAuthentication
              //               googleSignInAuthentication =
              //               await googleSignInAccount.authentication;

              //           final AuthCredential credential =
              //               GoogleAuthProvider.credential(
              //             accessToken: googleSignInAuthentication.accessToken,
              //             idToken: googleSignInAuthentication.idToken,
              //           );

              //           try {
              //             final UserCredential userCredential =
              //                 await auth.signInWithCredential(credential);
              //             user = userCredential.user;

              //             print(user?.displayName);

              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => HomePage()));
              //           } catch (e) {
              //             print(e.toString());
              //           }
              //         }
              //       },
              //       child: Image.asset(
              //         "images/google.png",
              //         height: 50,
              //       ),
              //     ),
              //     SizedBox(width: 30),
              //     Image.asset("images/twitter.png", height: 50)
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
