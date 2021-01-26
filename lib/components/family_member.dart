import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/family.dart';
import 'package:fammily/api/user.dart';
import 'package:fammily/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FamilyMember extends StatefulWidget {
  final String avatarSrc;
  final String name;
  final String uid;
  final String role;
  final GeoPoint initialGeoPoint;
  FamilyMember(
      {this.avatarSrc, this.name, this.uid, this.role, this.initialGeoPoint});
  @override
  _FamilyMemberState createState() => _FamilyMemberState(
        avatarSrc: avatarSrc,
        name: name,
        uid: this.uid,
        role: this.role,
        initialGeoPoint: this.initialGeoPoint,
      );
}

class _FamilyMemberState extends State<FamilyMember> {
  final String avatarSrc;
  final String name;
  final String uid;
  final String role;
  final GeoPoint initialGeoPoint;
  bool isCurrentUser = false;
  bool isCurrentUserOwner = false;
  String url;

  _FamilyMemberState({
    this.avatarSrc,
    this.name,
    this.uid,
    this.role,
    this.initialGeoPoint,
  }) {
    this.isCurrentUser = FirebaseAuth.instance.currentUser.uid == this.uid;
    FirestoreUserController.getURL(uid)
        .then((value) => {
              this.setState(() {
                this.url = value;
              })
            })
        .catchError((error) {
      print(error);
    });
    FirestoreUserController.getUserDataById(
            FirebaseAuth.instance.currentUser.uid)
        .then((value) {
      this.setState(() {
        isCurrentUserOwner = value['role'] == 'OWNER';
      });
    });
  }

  Future<void> _showMyDialog() async {
    String message = isCurrentUser
        ? 'Are you sure you want to leave this family?'
        : 'Are you sure you want to remove this user from the family?';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: handleRemoveOnPress,
            ),
          ],
        );
      },
    );
  }

  handleRemoveOnPress() async {
    if (isCurrentUser) {
      await FirestoreFamilyController.leaveFamily(
          FirebaseAuth.instance.currentUser.uid);
    } else {
      await FirestoreFamilyController.leaveFamily(uid);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
  }

  handleShowLocation() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(
          initialPosition:
              LatLng(initialGeoPoint.latitude, initialGeoPoint.longitude),
          initialIndex: 1);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: url != null
                    ? NetworkImage(url)
                    : AssetImage('assets/images/default.png'),
                radius: 28,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  SizedBox(height: 4),
                  Text(
                    role == 'OWNER' ? 'Family owner' : 'Family member',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (isCurrentUser || isCurrentUserOwner)
                IconButton(
                  icon: Icon(
                    Icons.person_remove_rounded,
                    color: Colors.grey[600],
                  ),
                  onPressed: _showMyDialog,
                ),
              if (initialGeoPoint != null)
                IconButton(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.grey[600],
                  ),
                  onPressed: handleShowLocation,
                )
            ],
          ),
        ],
      ),
    );
  }
}
