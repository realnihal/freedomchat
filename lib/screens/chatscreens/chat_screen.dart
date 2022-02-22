// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freedomchat/models/message.dart';
import 'package:freedomchat/widgets/appbar.dart';
import 'package:freedomchat/widgets/custom_tile.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/widgets/user_circle.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final Person receiver;

  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  FirebaseRepository _repository = FirebaseRepository();
  ScrollController _listScrollController = ScrollController();
  late Person sender;
  late String _currentUserId;
  FocusNode _textFieldFocus = FocusNode();
  bool loadState = true;
  bool isWriting = false;
  bool showEmojiPicker = false;

  void loadData() async {
    await _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = Person(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
        loadState = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: customAppBar(context),
      body: loadState
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            )
          : Column(
              children: <Widget>[
                Flexible(
                  child: messageList(),
                ),
                chatControls(),
                showEmojiPicker
                    ? Container(
                        height: 300,
                        child: emojiContainer(),
                      )
                    : Container()
              ],
            ),
    );
  }

  bool emojiShowing = false;

  emojiContainer() {
    return EmojiPicker(
      onEmojiSelected: (Category category, Emoji emoji) {
        setState(() {
          isWriting = true;
        });
        textFieldController.text += emoji.emoji;
      },
      config: const Config(
        columns: 7,
        bgColor: Colors.purple,
        iconColorSelected: Colors.white,
        iconColor: Colors.black,
        indicatorColor: Colors.purpleAccent,
      ),
    );
  }

  showKeyboard() => _textFieldFocus.requestFocus();

  hideKeyboard() => _textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(_currentUserId)
          .collection(widget.receiver.uid!)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        SchedulerBinding.instance!.addPostFrameCallback((_) {
          _listScrollController.animateTo(
            _listScrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        });

        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.all(10),
          controller: _listScrollController,
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        alignment: snapshot['senderId'] == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['senderId'] == _currentUserId
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  String getdate(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String? month;
    switch (tm.month) {
      case 1:
        month = "january";
        break;
      case 2:
        month = "february";
        break;
      case 3:
        month = "march";
        break;
      case 4:
        month = "april";
        break;
      case 5:
        month = "may";
        break;
      case 6:
        month = "june";
        break;
      case 7:
        month = "july";
        break;
      case 8:
        month = "august";
        break;
      case 9:
        month = "september";
        break;
      case 10:
        month = "october";
        break;
      case 11:
        month = "november";
        break;
      case 12:
        month = "december";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "yesterday";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "monday";
        case 2:
          return "tuesday";
        case 3:
          return "wednesday";
        case 4:
          return "thursday";
        case 5:
          return "friday";
        case 6:
          return "saturday";
        case 7:
          return "sunday";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return '';
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);
    DateTime date = (snapshot['timestamp'] as Timestamp).toDate();
    String d24 = DateFormat('HH:mm').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            getdate(date),
            style: TextStyle(
              color: Colors.purple[300],
              fontSize: 10,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 0),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65),
          decoration: BoxDecoration(
            color: Colors.purple[200],
            borderRadius: BorderRadius.only(
              topLeft: messageRadius,
              bottomRight: messageRadius,
              bottomLeft: messageRadius,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: getMessage(snapshot),
          ),
        ),
        Container(
          child: Text(
            d24,
            style: TextStyle(
              color: Colors.purple[300],
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  getMessage(DocumentSnapshot snapshot) {
    return Text(
      snapshot['message'],
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);
    DateTime date = (snapshot['timestamp'] as Timestamp).toDate();
    String d24 = DateFormat('HH:mm').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            getdate(date),
            style: TextStyle(
              color: Colors.purple[800],
              fontSize: 10,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 0),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65),
          decoration: BoxDecoration(
            color: Colors.purple[600],
            borderRadius: BorderRadius.only(
              topLeft: messageRadius,
              bottomRight: messageRadius,
              bottomLeft: messageRadius,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: getMessage(snapshot),
          ),
        ),
        Container(
          child: Text(
            d24,
            style: TextStyle(
              color: Colors.purple[800],
              fontSize: 12,
            ),
          ),
        ),
      ],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          context: context,
          elevation: 0,
          backgroundColor: Colors.purple[400],
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
                          color: Colors.purple[1900],
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
                Container(
                  height: 2,
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width - 30,
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

    sendMessage() {
      var text = textFieldController.text;

      Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text',
      );

      setState(() {
        isWriting = false;
      });
      textFieldController.text = "";

      _repository.addMessageToDb(_message, sender, widget.receiver);
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
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: _textFieldFocus,
                  onTap: () {
                    hideEmojiContainer();
                  },
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
                    fillColor: Colors.purple[300],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      if (!showEmojiPicker) {
                        showEmojiContainer();
                        hideKeyboard();
                      } else {
                        hideEmojiContainer();
                        showKeyboard();
                      }
                    },
                    icon: Icon(
                      Icons.face,
                      color: Colors.purple[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.mic_outlined,
                    color: Colors.purple[900],
                  ),
                ),
          isWriting
              ? Container()
              : Icon(
                  Icons.camera_alt,
                  color: Colors.purple[900],
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.purple, Colors.black]),
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
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
      title: loadState
          ? Text("Loading")
          : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                            maxRadius: 15,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(widget.receiver.profilePhoto!),
                          ),
                          Container(
                            width: 10,
                          ),
              Text(
                  widget.receiver.name!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
            ],
          ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomTile(
          mini: false,
          leading: Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.purple[900],
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
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
