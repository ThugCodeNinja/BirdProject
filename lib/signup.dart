import 'package:firebase_auth/firebase_auth.dart';
import 'package:psfinal/species.dart';
import 'package:psfinal/widget.dart';
import 'package:psfinal/homescreen.dart';
import 'package:psfinal/color_utils.dart';
import 'package:flutter/material.dart';
import 'authserve.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("8BC6EC"),
                hexStringToColor("9599E2"),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter UserName", Icons.person_outline, false,
                        _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email Id", Icons.person_outline, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outlined, true,
                        _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                              .then((value) {
                            print("Created New Account");
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomeScreen()));
                          }).onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                        },
                        child: Text( "Sign Up",
                          style: const TextStyle(
                              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.black26;
                              }
                              return Colors.white;
                            }),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
                      ),),
                    Container(
                        child: ElevatedButton(onPressed: () { AuthService().signInWithGoogle();Navigator.push(context, MaterialPageRoute(builder: (context)=>speciesPage())); }, child: Text("Sign in with Google",style: const TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 10),), style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black26;
                            }
                            return Colors.white;
                          }),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),)
                        )

                    )],
                ),
              ))),
    );
  }
}