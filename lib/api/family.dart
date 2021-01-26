import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/user.dart';
import 'package:fammily/utils/code_generator.dart';
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

  static Future<void> addFamily(String name) async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference userDocument = await FirestoreUserController.getUserDocument(user.uid);
    CollectionReference families = FirebaseFirestore.instance.collection('family');
    DocumentReference newFamily = await families.add({ 'code': FamilyCodeGenerator.generateCode(), 'name': name });
    await newFamily.collection('users').add({ 'user': userDocument });
    await userDocument.update({ 'family': newFamily });
  }

  static Future<void> joinFamily(String code) async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference userDocument = await FirestoreUserController.getUserDocument(user.uid);
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('family').where('code', isEqualTo: code).get();
    if (snapshot.docs.length > 0) {
      String familyCollectionId = snapshot.docs[0].id;
      DocumentReference family = FirebaseFirestore.instance.collection('family')
          .doc(familyCollectionId);
      await family.collection('users').add({ 'user': userDocument});
      await userDocument.update({ 'family': family});
    }
  }

  static Future<String> getFamilyCode() async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference family = (await FirestoreUserController.getUserDataById(user.uid))['family'];
    return (await family.get()).data()['code'];
  }

  static Future<String> getFamilyName() async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference family = (await FirestoreUserController.getUserDataById(user.uid))['family'];
    return (await family.get()).data()['name'];
  }

  static Future<void> leaveFamily(String uid) async {
    DocumentReference userDocument = await FirestoreUserController.getUserDocument(uid);
    DocumentReference familyDocument = (await userDocument.get()).data()['family'];
    String collectionId = (await familyDocument.collection('users').where('user', isEqualTo: userDocument).get()).docs[0].id;
    await familyDocument.collection('users').doc(collectionId).delete();
    if ((await userDocument.get()).data()['role'] == 'OWNER') {
      List<Map<String, dynamic>> users = await FirestoreFamilyController.getFamilyUsers();
      if (users.length > 0) {
         DocumentReference newOwnerDocument = await FirestoreUserController.getUserDocument(users[0]['uid']);
         await newOwnerDocument.update({ 'role': 'OWNER'});
      } else {
        await familyDocument.delete();
      }
    }
    await userDocument.update({ 'family': null, 'role': null });
  }
}
