// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/enum/user_state.dart';
import 'package:freedomchat/resources/firebase_methods.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/pageviews/calllist_screen.dart';
import 'package:freedomchat/screens/pageviews/chatlist_screen.dart';
import 'package:freedomchat/screens/pageviews/contact_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController = PageController();
  int _page = 0;
  final FirebaseRepository _repository = FirebaseRepository();
  final FirebaseMethods _methods = FirebaseMethods();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String currentUserId;

  gettingCurrentUser() async {
    User currentUser = await _repository.getCurrentUser();
    currentUserId = currentUser.uid;
    _methods.setUserState(userId: currentUserId, userState: UserState.Online);
  }

  @override
  void initState() {
    super.initState();
    gettingCurrentUser();
    WidgetsBinding.instance?.addObserver(this);

    Future.delayed(Duration.zero, () {
      firebaseCloudMessagingListeners(context);
    });
  }

  void firebaseCloudMessagingListeners(BuildContext context) {
    _firebaseMessaging.getToken().then((deviceToken) async {
      await _methods.addNotifTokenToDb(currentUserId, deviceToken!);
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _methods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resumed state");
        break;

      case AppLifecycleState.inactive:
        currentUserId != null
            ? _methods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;

      case AppLifecycleState.paused:
        currentUserId != null
            ? _methods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;

      case AppLifecycleState.detached:
        currentUserId != null
            ? _methods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("paused state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: PageView(
        children: [
          const ChatListScreen(),
          const Call_List_Screen(),
          const Contact_List_Screen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CurvedNavigationBar(
            color: Colors.purple,
            height: 40,
            index: _page,
            animationDuration: const Duration(milliseconds: 500),
            backgroundColor: Colors.transparent,
            items: [
              Icon(Icons.chat, size: 30, color: Colors.purple[200]),
              Icon(Icons.call, size: 30, color: Colors.purple[200]),
              Icon(Icons.contact_phone, size: 30, color: Colors.purple[200]),
            ],
            onTap: (_page) => setState(() {
              onPageChanged(_page);
              pageController.animateToPage(_page,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease,);
            }),
          )
          ),
    );
  }
}
