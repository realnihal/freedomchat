// ignore_for_file: deprecated_member_use, unused_local_variable, prefer_collection_literals

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freedomchat/models/message.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //user class
  Person user = Person();

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser!;
    return currentUser;
  }

  Future<UserCredential> signIn() async {
    GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);
    return await _auth.signInWithCredential(credential);
  }

  Future<bool> authenticateUser(UserCredential userCredential) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(UserCredential userCredential) async {
    String username = Utils.getUsername(userCredential.user?.email ?? "");
    firestore.collection('persons').doc(userCredential.user?.uid).set(
          {
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email,
        'name': userCredential.user?.displayName,
        'profilePhoto': userCredential.user?.photoURL,
        'username': username
          },
        );
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<Person>> fetchAllUsers(User currentUser) async {
    List<Person> userList = [];

    QuerySnapshot querySnapshot =
        await firestore.collection('persons').get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(
          Person.fromMap(querySnapshot.docs[i].data() as Map<String, dynamic>),
        );
      }
    }
    return userList;
  }

  Future<DocumentReference<Map<String, dynamic>>> addMessageToDb(
      Message message, Person sender, Person receiver) async {
    var map = message.toMap();

    await firestore
        .collection("messages")
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map);
    
    return await firestore
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
  }
  
}
