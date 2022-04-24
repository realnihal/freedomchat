// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Post_container extends StatelessWidget {
  const Post_container({
    Key? key,
    required this.currentUser,
    required this.text,
  }) : super(key: key);

  final User currentUser;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.purple.shade50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      maxRadius: MediaQuery.of(context).size.width / 15,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(currentUser.photoURL!),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "22:47 PM",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentUser.displayName!,
                          style: TextStyle(
                              color: Colors.purple[700],
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text(
                        "200m away",
                        style: TextStyle(
                          color: Colors.purple.shade200,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 0.2,
                        width: MediaQuery.of(context).size.width / 1.5,
                        color: Colors.purple[600],
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
