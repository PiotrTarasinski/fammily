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

  static Future<QuerySnapshot> getUser(String uid) { // Get user instance from firestore with given id
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
  }

  static Future<Map<String, dynamic>> getUserDataById(String uid) async { // Get user data with given id
    return (await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get())
        .docs[0]
        .data();
  }

  static Future<String> getUserDisplayNameById(String uid) async { // Get users display name (Name + Surname)
    Map<String, dynamic> data = (await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get())
        .docs[0]
        .data();
    return data['name'];
  }
}
