import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserController {
  static Future<void> addUser(String uid, String name) { // Add new user to firestore
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user
    return users
        .add({'uid': uid, 'name': name})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
