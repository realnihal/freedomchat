// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:freedomchat/models/contact.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/resources/firebase_methods.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/chatscreens/chat_screen.dart';
import 'package:freedomchat/screens/chatscreens/widget/cached_image.dart';
import 'package:freedomchat/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final FirebaseMethods _methods = FirebaseMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _methods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Person user = snapshot.data as Person;
          return ViewLayout(
            contact: user,
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
  final FirebaseMethods _methods = FirebaseMethods();

  ViewLayout({required this.contact});

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(receiver: contact),
          )),
      title: Text(
        contact.name ?? "..",
        style:
            TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: Text(
        "Hello There",
        style: TextStyle(color: Colors.grey, fontSize: 14),
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
  }
}
