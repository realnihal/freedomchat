// ignore_for_file: camel_case_types, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/pageviews/widgets/post_container.dart';
import 'package:freedomchat/utils/utilities.dart';
import 'package:freedomchat/widgets/appbar.dart';
import 'package:freedomchat/widgets/user_circle.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  _Call_List_ScreenState createState() => _Call_List_ScreenState();
}

class _Call_List_ScreenState extends State<Profile_Screen> {
  final FirebaseRepository _repository = FirebaseRepository();
  String currentUserId = '';
  late String initials;
  bool loadState = true;
  late User currentUser;

  void loadData() async {
    await _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName!);
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
    return Scaffold(
        appBar: customAppBar(context),
        backgroundColor: Colors.purple[50],
        body: (currentUserId == '')
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.purple[100]),
                child: ListView(
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CircleAvatar(
                          maxRadius: MediaQuery.of(context).size.width / 8,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(currentUser.photoURL!),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          currentUser.displayName!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "My Bio, My Rules",
                          style: TextStyle(
                              color: Colors.purple[300],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 2,
                        width: MediaQuery.of(context).size.width / 1.5,
                        color: Colors.purple[900],
                      ),
                    ]),
                    Post_container(
                      currentUser: currentUser,
                      text:
                          "Virat Kohli is an Indian international cricketer and former captain of the India national cricket team. He plays for Delhi in domestic cricket and Royal Challengers Bangalore in the Indian Premier League as a right-handed batsman.",
                    ),
                    Post_container(
                      currentUser: currentUser,
                      text: 'Hello world hihicnas',
                    ),
                    Post_container(
                      currentUser: currentUser,
                      text:
                          'Saadat Hasan Manto, an established writer in Bombay, is devastated when his family is forced to flee to Pakistan due to the rising tensions between Hindus and Muslims.',
                    ),
                    Post_container(
                      currentUser: currentUser,
                      text:
                          'Arsenal Football Club is a professional football club based in Islington, London, England. Arsenal plays in the Premier League, the top flight of English football.',
                    ),
                  ],
                ),
              ));
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications_outlined,
          color: Colors.purple[50],
        ),
        onPressed: () {},
      ),
      centerTitle: true,
      title: loadState
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.purple,
            ))
          : UserCircle(initials),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.purple[50],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/third');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.purple[50],
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
