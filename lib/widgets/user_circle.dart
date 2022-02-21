// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'sign_out_container.dart';


class UserCircle extends StatelessWidget {
  final String text;
  UserCircle(this.text);

  @override
  Widget build(BuildContext context) {
  UserDetailsContainer userDetailsContainer = UserDetailsContainer();


    return GestureDetector(
      onTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.purple[700],
          builder: (context) => userDetailsContainer),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.purple.shade900,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    color: Colors.green),
              ),
            )
          ],
        ),
      ),
    );
  }
}


