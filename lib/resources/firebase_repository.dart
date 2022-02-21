import 'package:firebase_auth/firebase_auth.dart';
import 'package:freedomchat/models/message.dart';
import 'package:freedomchat/models/person.dart';
import 'package:freedomchat/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<UserCredential> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(UserCredential userCredential) =>
      _firebaseMethods.authenticateUser(userCredential);

  Future<void> addDataToDb(UserCredential userCredential) => _firebaseMethods.addDataToDb(userCredential);
  Future<void> signOut() => _firebaseMethods.signOut();
  Future<List<Person>> fetchAllUsers(User user) => _firebaseMethods.fetchAllUsers(user);
  Future<void> addMessageToDb(Message message, Person sender, Person receiver) =>
      _firebaseMethods.addMessageToDb(message, sender, receiver);
}
