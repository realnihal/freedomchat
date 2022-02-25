// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/enum/user_state.dart';
import 'package:freedomchat/resources/firebase_methods.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/pageviews/calllist_screen.dart';
import 'package:freedomchat/screens/pageviews/chatlist_screen.dart';
import 'package:freedomchat/screens/pageviews/contact_list_screen.dart';
import 'package:freedomchat/screens/pageviews/widgets/quiet_box.dart';

class HomeScreen extends StatefulWidget {
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
      this.firebaseCloudMessagingListeners(context);
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
        child: CupertinoTabBar(
          border: const Border(
            top: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          backgroundColor: Colors.purple.shade100,
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Icon(Icons.chat,
                      color: (_page == 0)
                          ? Colors.purple.shade300
                          : Colors.purple.shade200),
                ),
                label: "Chat"),
            BottomNavigationBarItem(
              icon: Icon(Icons.call,
                  color: (_page == 1)
                      ? Colors.purple.shade400
                      : Colors.purple.shade200),
              label: "Call",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone,
                    color: (_page == 2)
                        ? Colors.purple.shade300
                        : Colors.purple.shade200),
                label: "Contact List"),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}
