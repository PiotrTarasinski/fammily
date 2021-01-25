import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreFamilyController {

  static Future<List<Map<String, dynamic>>> getFamilyUsers() async {
    User user = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> users = [];
    DocumentReference family = (await FirestoreUserController.getUserDataById(user.uid))['family'];
    for(QueryDocumentSnapshot element in (await family.collection('users').get()).docs) {
      Map<String, dynamic> user = (await (element.data()['user'] as DocumentReference).get()).data();
      users.add(user);
    }
    return users;
  }

  static Future<String> getFamilyCode() async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference family = (await FirestoreUserController.getUserDataById(user.uid))['family'];
    return (await family.get()).data()['code'];
  }
}
