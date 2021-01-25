import 'package:fammily/api/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FamilyMember extends StatefulWidget {
  final String avatarSrc;
  final String name;
  final String uid;
  FamilyMember({
    this.avatarSrc,
    this.name,
    this.uid,
  });
  @override
  _FamilyMemberState createState() => _FamilyMemberState(
    avatarSrc: avatarSrc,
    name: name,
    uid: this.uid,
  );
}

class _FamilyMemberState extends State<FamilyMember> {
  final String avatarSrc;
  final String name;
  final String uid;
  bool isCurrentUser = false;
  String url;

  _FamilyMemberState({
    this.avatarSrc,
    this.name,
    this.uid,
  }) {
    this.isCurrentUser = FirebaseAuth.instance.currentUser.uid == this.uid;
    FirestoreUserController.getURL(uid).then((value) => {
      this.setState(() {
        this.url = value;
      })
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1, color: Colors.grey[300])
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: url != null ? NetworkImage(url) : AssetImage('assets/images/default.png'),
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
                        color: Colors.deepPurple
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    isCurrentUser ? 'It\'s a me' : 'Family owner',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
              icon: Icon(
                Icons.person_remove_rounded,
                color: Colors.grey[600],
              ),
              onPressed: () {
                print('@TODO Remove person');
              }
          ),
        ],
      ),
    );
  }
}
