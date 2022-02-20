// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/resources/firebase_repository.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isLoginPressed
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.purple,
                    ))
                  : Column(
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Freedom to communicate faster, better and safer",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/Illustration.png'))),
              ),
              Container(
                child: Stack(children: [
                  MaterialButton(
                    color: Colors.white,
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () => performLogin(),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Login with Google",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  void performLogin() async {
    UserCredential userCredential = await _repository.signIn();
    authenticateUser(userCredential);

    setState(() {
      isLoginPressed = true;
    });
  }

  void authenticateUser(UserCredential userCredential) {
    _repository.authenticateUser(userCredential).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (isNewUser) {
        _repository.addDataToDb(userCredential).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
