import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/message.dart';

class LastMessageContainer extends StatelessWidget {
  final dynamic stream;

  const LastMessageContainer({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data?.docs;
          if (docList != null && docList.isNotEmpty) {
            Message message =
                Message.fromMap(docList.last.data() as Map<String, dynamic>);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                message.message!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            );
          }
          return const Text(
            "No Message",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
        return const Text(
          "..",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }
}
