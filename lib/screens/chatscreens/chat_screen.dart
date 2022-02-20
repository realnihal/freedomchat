// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/widgets/appbar.dart';
import 'package:freedomchat/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final Person receiver;
  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState(receiver: receiver);
}

class _ChatScreenState extends State<ChatScreen> {
  final Person receiver;
  _ChatScreenState({required this.receiver});
  TextEditingController textFieldController = TextEditingController();

  bool isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: customAppBar(context, receiver.name!),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 6,
      itemBuilder: (context, index) {
        return chatMessageItem();
      },
    );
  }

  Widget chatMessageItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: Alignment.centerRight,
        child: senderLayout(),
      ),
    );
  }

  Widget senderLayout() {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.purple[300],
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget receiverLayout() {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.purple,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                      ),
                      ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab),
                    ModalTile(
                        title: "Contact",
                        subtitle: "Share contacts",
                        icon: Icons.contacts),
                    ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location),
                    ModalTile(
                        title: "Schedule Call",
                        subtitle: "Arrange a skype call and get reminders",
                        icon: Icons.schedule),
                    ModalTile(
                        title: "Create Poll",
                        subtitle: "Share polls",
                        icon: Icons.poll)
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.black]),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add,color: Colors.white,),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.purple[100],
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: Colors.purple,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.face,color: Colors.purple[200],),
                ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over,color: Colors.purple.shade900,),
                ),
          isWriting ? Container() : Icon(Icons.camera_alt,color: Colors.purple.shade900,),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.purple, Colors.black]),
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () => {},
                  ))
              : Container()
        ],
      ),
    );
  }



          
  CustomAppBar customAppBar(context,String receiver) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        receiver,
        style: TextStyle(
          fontSize: 20
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call_outlined,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.phone_outlined,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color:Colors.purple[900],
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.purple[100],
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ), onTap: () {},
      ),
    );
  }
}