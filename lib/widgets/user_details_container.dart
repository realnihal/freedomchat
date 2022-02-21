// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/login_screen.dart';


class UserDetailsContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseRepository _repository = FirebaseRepository();

    signOut()async{
     final bool isLoggedOut = await _repository.signOut();

     if (isLoggedOut){
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder:(context)=>LoginScreen()),
        (Route<dynamic>route) => false);
     }
    }

    return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "User Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                MaterialButton(
                      color: Colors.purple.shade200,
                      height: 40,
                      onPressed: () => signOut(),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            height: 1,
          )
        ],
      ),
    ),
  );
  }
}
