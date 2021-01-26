import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

class FirestoreUserController {
  static Future<void> addUser(String uid, String name) async {
    // Add new user to firestore
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((Position position) => users
            .add({
              'uid': uid,
              'name': name,
              'location': GeoPoint(position.latitude, position.longitude)
            })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error")));
  }

  static Future<QuerySnapshot> getUser(String uid) {
    // Get user instance from firestore with given id
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
  }

  static Future<DocumentReference> getUserDocument(String uid) async {
    String docId = (await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .get())
        .docs[0]
        .id;
    return FirebaseFirestore.instance.collection('users').doc(docId);
  }

  static Future<Map<String, dynamic>> getUserDataById(String uid) async {
    // Get user data with given id
    return (await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .get())
        .docs[0]
        .data();
  }

  static Future<String> getUserDisplayNameById(String uid) async {
    // Get users display name (Name + Surname)
    Map<String, dynamic> data = (await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .get())
        .docs[0]
        .data();
    return data['name'];
  }

  static Future<String> getURL(String uid) async {
    Reference images;
    try {
      images =
          FirebaseStorage.instance.ref().child('images').child(uid + '.jpg');
    } catch (e) {}
    return images.getDownloadURL();
  }
}
