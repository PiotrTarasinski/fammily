import 'package:fammily/components/family_member.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class FamilyScreen extends StatefulWidget {
  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {

  Function logout(BuildContext context) {
    return () async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MyHomePage();
      }));
      print('Logged out');
    };
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
                IconButton(
                  icon: Icon(Icons.logout),
                  // color: Colors.grey[600],
                  onPressed: logout(context),
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
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _inviteCode));
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invite code copied to clipboard')));
              },
              child: Text(
                _inviteCode,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 42,
                  letterSpacing: 10,
                ),
              ),
            ),
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
            FamilyMember(
              avatarSrc: _userAvatarUrl,
              name: 'Piotr Tarasiński',
            ),
            FamilyMember(
              avatarSrc: _userAvatarUrl,
              name: 'Szymon Tokarzewski',
            ),
            FamilyMember(
              avatarSrc: _userAvatarUrl,
              name: 'Adam Małysz',
            ),
          ],
      ),
    );
  }
}