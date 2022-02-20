import 'package:firebase_auth/firebase_auth.dart';
import 'package:freedomchat/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<UserCredential> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(UserCredential userCredential) =>
      _firebaseMethods.authenticateUser(userCredential);

  Future<void> addDataToDb(UserCredential userCredential) => _firebaseMethods.addDataToDb(userCredential);
  Future<void> signOut() => _firebaseMethods.signOut();
}
