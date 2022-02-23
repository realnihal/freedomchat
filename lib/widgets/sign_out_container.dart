// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/enum/user_state.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/resources/firebase_methods.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/login_screen.dart';
import 'package:freedomchat/utils/utilities.dart';
import 'package:page_transition/page_transition.dart';

import 'custom_tile.dart';

class UserDetailsContainer extends StatefulWidget {
  @override
  State<UserDetailsContainer> createState() => _UserDetailsContainerState();
}

class _UserDetailsContainerState extends State<UserDetailsContainer> {
  FirebaseRepository _repository = FirebaseRepository();
  FirebaseMethods _methods = FirebaseMethods();
  late User currentUser;
  bool loadState = true;

  void loadData() {
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
        loadState = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    signOut() async {
      final bool isLoggedOut = await _repository.signOut();

      if (isLoggedOut) {
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                ctx: (context),
                child: LoginScreen(),
                type: PageTransitionType.fade),
            (Route<dynamic> route) => false);
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
                    onPressed: (){
                      signOut();
                      _methods.setUserState(userId: currentUser.uid, userState: UserState.Offline);
                      },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.purple,
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
            ),
            (loadState)
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple[200],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            maxRadius: MediaQuery.of(context).size.width / 5,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(currentUser.photoURL!),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            currentUser.displayName!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width / 1.5,
                          color: Colors.purple[900],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            currentUser.email!,
                            style: TextStyle(
                                color: Colors.purple[200],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "UID: " + currentUser.uid,
                            style: TextStyle(
                                color: Colors.purple[300],
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
