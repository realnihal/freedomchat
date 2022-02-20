import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
