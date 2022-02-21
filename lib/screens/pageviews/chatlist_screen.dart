// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/widgets/appbar.dart';
import 'package:freedomchat/utils/utilities.dart';
import 'package:freedomchat/widgets/custom_tile.dart';
import 'package:freedomchat/widgets/user_circle.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  late String currentUserId;
  late String initials;
  bool loadState = true;

  void loadData(){
    _repository.getCurrentUser().then((user) {
      setState(() {
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
      title: loadState ? Center(child:CircularProgressIndicator(color: Colors.purple,)) 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: loadState ? Center(child:CircularProgressIndicator(color: Colors.purple,))
      : ChatListContainer(currentUserId),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onTap: () {},
            title: Text(
              "Nihal Puram",
              style: TextStyle(
                  color: Colors.black, fontFamily: "Arial", fontSize: 19),
            ),
            subtitle: Text(
              "Hello There",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: [
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        "https://lh3.googleusercontent.com/a-/AOh14Gguey-VN3ennU_FMVcIVF1kyYP3XjZbbqZn4pUl-c8=s96-c"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



class NewChatButton extends StatelessWidget {
  const NewChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.edit_outlined),
      backgroundColor: Colors.purple[300],
      elevation: 5,
      onPressed: () {},
    );
  }
}
