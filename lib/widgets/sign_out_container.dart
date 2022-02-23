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
  bool _isElevated = true;

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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isElevated = !_isElevated;
                          signOut();
                          _methods.setUserState(
                              userId: currentUser.uid,
                              userState: UserState.Offline);
                        });
                      },
                      child: AnimatedContainer(
                        width: 100,
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.purple[700],
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: _isElevated
                              ? [
                                  const BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0, 0),
                                    blurRadius: 10,
                                    spreadRadius: 0.0,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "Sign Out",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ]),
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
                    child: (MediaQuery.of(context).orientation !=
                            Orientation.portrait)
                        ? LandscapeColumn(currentUser: currentUser)
                        : PortraitColumn(currentUser: currentUser),
                  )
          ],
        ),
      ),
    );
  }
}

class PortraitColumn extends StatelessWidget {
  const PortraitColumn({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CircleAvatar(
            maxRadius: MediaQuery.of(context).size.width / 5,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(currentUser.photoURL!),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            currentUser.displayName!,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
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
    );
  }
}

class LandscapeColumn extends StatelessWidget {
  const LandscapeColumn({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
            maxRadius: MediaQuery.of(context).size.height / 10,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(currentUser.photoURL!),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  currentUser.displayName!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Text(
                  currentUser.email!,
                  style: TextStyle(
                      color: Colors.purple[200],
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
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
        ),
      ],
    );
  }
}
