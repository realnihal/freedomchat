import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: PageView(
        children: [
          Center(child: Text("Chat List Screen")),
          Center(child: Text("Call losg")),
          Center(child: Text("Contact Screen")),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: Colors.purple.shade50,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat,
                    color: (_page == 0)
                        ? Colors.purple.shade300
                        : Colors.purple.shade200),
                title: Text(
                    "Chat",
                    style: TextStyle(
                        fontSize: 10,
                        color: (_page == 0) ? Colors.black : Colors.grey),
                  ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.call,
                      color: (_page == 1)
                          ? Colors.purple.shade300
                          : Colors.purple.shade200),
                  title: Text(
                    "Call",
                    style: TextStyle(
                        fontSize: 10,
                        color: (_page == 1) ? Colors.black : Colors.grey),
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
                        color: (_page == 2) ? Colors.black : Colors.grey),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
