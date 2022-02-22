import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/enum/user_state.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/resources/firebase_methods.dart';
import 'package:freedomchat/utils/utilities.dart';


class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final FirebaseMethods _authMethods = FirebaseMethods();

  OnlineDotIndicator({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.orange;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.red;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(uid: uid),
        builder: (context, snapshot) {
          Person _user = Person();
          if (snapshot.hasData && snapshot.data?.data != null) {
            _user = Person.fromMap(snapshot.data?.data() as Map<String, dynamic>);
          }

          return Container(
            height: 10,
            width: 10,
            margin: const EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              color: getColor(_user.state ?? 3),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}
