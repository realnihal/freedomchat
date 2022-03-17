import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/screens/chatscreens/chat_screen.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:page_transition/page_transition.dart';
import '../../models/person.dart';
import '../../resources/firebase_methods.dart';
import '../../widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseMethods _repository = FirebaseMethods();
  bool loadingState = true;
  List<Person> userList = [];
  String query = "";
  TextEditingController searchController = TextEditingController();

  void loadData() async {
    await _repository.getCurrentUser().then((User user) async {
      await _repository.fetchAllUsers(user).then((List<Person> list) {
        setState(() {
          userList = list;
          loadingState = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  searchAppBar(BuildContext context) {
    return NewGradientAppBar(
      gradient: const LinearGradient(colors: [Colors.purple, Colors.black]),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: Colors.white,
            autofocus: true,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 35),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white)),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<Person> suggestionList = query.isEmpty
        ? []
        : userList.where((Person user) {
            String _getUsername = user.username!.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name!.toLowerCase();
            bool matchUserName = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);
            return (matchUserName || matchesName);
          }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        Person searchedUser = Person(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username);
        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                ctx: (context),
                type: PageTransitionType.rightToLeft,
                child: ChatScreen(
                  receiver: searchedUser,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto!),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.name!,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            searchedUser.username!,
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: searchAppBar(context),
      body: (loadingState)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildSuggestions(query),
            ),
    );
  }
}
