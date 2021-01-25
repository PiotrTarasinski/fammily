import 'package:fammily/api/family.dart';
import 'package:fammily/api/user.dart';
import 'package:fammily/components/family_list.dart';
import 'package:fammily/components/family_member.dart';
import 'package:fammily/components/invite_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class FamilyScreen extends StatefulWidget {
  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  Future<Map<String, dynamic>> _userData;

  _FamilyScreenState() {
    FirestoreUserController.getUserDataById(
        FirebaseAuth.instance.currentUser.uid).then((value) {
          // print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    String _familyName = 'Super Rodzinka';
    String _inviteCode = 'Q5RST';

    // Move it to list
    String _userAvatarUrl = 'https://lh3.google.com/u/2/ogw/ADGmqu-1qFo7IGTMem4XaXpxU-5SVycTjnutzBwsOYw=s83-c-mo';

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  // color: Colors.grey[600],
                  onPressed: () {
                    print('@TODO Go to family settings');
                  },
                ),
              ],
              title: Text(
                _familyName
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Invite Code',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
           InviteCode(),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Family Members',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            FamilyList(),
          ],
      ),
    );
  }
}