// ignore_for_file: deprecated_member_use, unused_local_variable, prefer_collection_literals
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freedomchat/enum/user_state.dart';
import 'package:freedomchat/models/contact.dart';
import 'package:freedomchat/models/message.dart';
import 'package:freedomchat/provider/image_upload_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
   String url = "";
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Person user = Person();

  Future<User> getCurrentUser() async {
    User currentUser;
    // ignore: await_only_futures
    currentUser = await _auth.currentUser!;
    return currentUser;
  }

  Future getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('persons').doc(id).get();
      return Person.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
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

  Future<bool> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Person>> fetchAllUsers(User currentUser) async {
    List<Person> userList = [];

    QuerySnapshot querySnapshot = await firestore.collection('persons').get();

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

    addToContacts(senderId: sender.uid, receiverId: receiver.uid);

    return await firestore
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
  }

  DocumentReference getContactsDocument(
          {required String of, required String forContact}) =>
      firestore
          .collection('persons')
          .doc(of)
          .collection('contacts')
          .doc(forContact);

  addToContacts({String? senderId, String? receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId!, receiverId!, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchContacts(
          {required String userId}) =>
      firestore
          .collection('persons')
          .doc(userId)
          .collection('contacts')
          .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    required String senderId,
    required String receiverId,
  }) =>
      firestore
          .collection('messages')
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  void setUserState({required String userId, required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    firestore.collection('persons').doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({required String uid}) =>
      firestore.collection('persons').doc(uid).snapshots();

  Future<void> addNotifTokenToDb(String userID, String token) async {
    firestore.collection('tokens').doc(userID).set(
      {'uid': userID, 'token': token},
    );
  }

  Future uploadImageToStorage(File image, String receiverId,
   String senderId,ImageUploadProvider imageUploadProvider) async {
    Reference ref = _firebaseStorage
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() {
      ref.getDownloadURL().then((value)async {
        url = value;
        await setImageMsg(url,receiverId,senderId,imageUploadProvider);
      });
    }).catchError((onError) {
    });
  }


  Future<void> setImageMsg(String url, String receiverId, String senderId,ImageUploadProvider imageUploadProvider) async {
    Message message;
    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await firestore
        .collection('messages')
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map);

    firestore
        .collection('messages')
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
    imageUploadProvider.setToIdle();
  }


  void uploadImage(File image, String receiverId, String senderId,
  ImageUploadProvider imageUploadProvider)async {
    
    imageUploadProvider.setToLoading();
    await uploadImageToStorage(image,receiverId,senderId,imageUploadProvider);
  }

}