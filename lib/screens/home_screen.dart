import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/enum/user_state.dart';
import 'package:freedomchat/resources/firebase_methods.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/pageviews/chatlist_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController = PageController();
  int _page = 0;
  final FirebaseRepository _repository = FirebaseRepository();
  final FirebaseMethods _methods = FirebaseMethods();
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
          Container(child: ChatListScreen()),
          Center(child: Text("Call logs")),
          Center(child: Text("Contact Screen")),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            border: Border(
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
                title: Text(
                  "Chat",
                  style: TextStyle(
                      fontSize: 10,
                      color: (_page == 0)
                          ? Colors.purple[900]
                          : Colors.purple[400]),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call,
                    color: (_page == 1)
                        ? Colors.purple.shade400
                        : Colors.purple.shade200),
                title: Text(
                  "Call",
                  style: TextStyle(
                      fontSize: 10,
                      color: (_page == 1)
                          ? Colors.purple[900]
                          : Colors.purple[400]),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone,
                    color: (_page == 2)
                        ? Colors.purple.shade300
                        : Colors.purple.shade200),
                title: Text(
                  "Contact List",
                  style: TextStyle(
                      fontSize: 10,
                      color: (_page == 2)
                          ? Colors.purple[900]
                          : Colors.purple[400]),
                ),
              ),
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
