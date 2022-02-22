// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, empty_constructor_bodies

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/models/contact.dart';
import 'package:freedomchat/resources/firebase_methods.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/pageviews/widgets/contact_view.dart';
import 'package:freedomchat/widgets/appbar.dart';
import 'package:freedomchat/utils/utilities.dart';
import 'package:freedomchat/widgets/custom_tile.dart';
import 'package:freedomchat/widgets/user_circle.dart';

import 'widgets/quiet_box.dart';

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
      : ChatListContainer(currentUserId: currentUserId),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  ChatListContainer({required this.currentUserId});

  @override
  _ChatListContainerState createState() => _ChatListContainerState(currentUserId);
}

class _ChatListContainerState extends State<ChatListContainer> {
  String currentUserId;
  _ChatListContainerState(this.currentUserId);
  final FirebaseMethods _methods = FirebaseMethods();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _methods.fetchContacts(
          userId: currentUserId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data?.docs;
            if (docList == null || docList.isEmpty) {
              return const QuietBox(
                heading: "This is where all the contacts are listed",
                subtitle:
                    "Search for your friends and family to start calling or chatting with them",
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: docList.length,
              itemBuilder: (context, index) {
                Contact contact = Contact.fromMap(
                    docList[index].data() as Map<String, dynamic>);
                return ContactView(contact,currentUserId);
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
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
