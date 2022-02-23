// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/models/contact.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/resources/firebase_methods.dart';
import 'package:freedomchat/screens/chatscreens/chat_screen.dart';
import 'package:freedomchat/screens/chatscreens/widget/cached_image.dart';
import 'package:freedomchat/screens/pageviews/widgets/last_message_container.dart';
import 'package:freedomchat/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:freedomchat/widgets/custom_tile.dart';
import 'package:page_transition/page_transition.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final String currentUserId;
  final FirebaseMethods _methods = FirebaseMethods();

  ContactView(this.contact,this.currentUserId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _methods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Person user = snapshot.data as Person;
          return ViewLayout(
            contact: user,
            currentUserId: currentUserId,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Person contact;
  final String currentUserId;
  ViewLayout({required this.contact,required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final FirebaseMethods _methods = FirebaseMethods();
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
        context,
        PageTransition(
                ctx: (context),
                type: PageTransitionType.rightToLeftWithFade,
                child: ChatScreen(
                receiver:contact,
              ))
      ),
      title: Text(
        contact.name ?? "..",
        style:
            TextStyle(color: Colors.black, fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _methods.fetchLastMessageBetween(senderId: currentUserId, receiverId: contact.uid!),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: [
            CachedImage(
              contact.profilePhoto!,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(uid: contact.uid!)
          ],
        ),
      ),
    );
  }
}
