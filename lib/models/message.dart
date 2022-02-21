import "package:cloud_firestore/cloud_firestore.dart";

class Message {
  String? senderId;
  String? receiverId;
  String? type;
  String? message;
  Timestamp timestamp = Timestamp.now();
  String? photoUrl = "";

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.type,
      required this.message,
      required this.timestamp});

  Message.imageMessage(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.type,
      required this.timestamp,
      required this.photoUrl});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["senderId"] = senderId;
    map["receiverId"] = receiverId;
    map["type"] = type;
    map["message"] = message;
    map["timestamp"] = timestamp;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    message = map["message"];
    senderId = map["senderId"];
    receiverId = map["receiverId"];
    type = map["type"];
    timestamp = map["timestamp"];
    photoUrl = map["photoUrl"];
  }

  Map<String, dynamic> toImageMap() {
    Map<String, dynamic> map = {};
    map["senderId"] = senderId;
    map["receiverId"] = receiverId;
    map["type"] = type;
    map["message"] = message;
    map["timestamp"] = timestamp;
    map["photoUrl"] = photoUrl;
    return map;
  }
}