import 'package:fammily/api/user.dart';
import 'package:fammily/screens/login_screen.dart';
import 'package:fammily/screens/my_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  User currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> user;
  String avatarUrl;

  _SideBarState() {
    String uid = currentUser.uid;
    FirestoreUserController.getUserDataById(uid).then((value) {
      this.setState(() {
        user = value;
      });
    });
    FirestoreUserController.getURL(uid).then((value) {
      this.setState(() {
        avatarUrl = value;
      });
    });
  }

  Function logout(BuildContext context) {
    return () async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl)
                  : AssetImage('assets/images/default.png'),
              radius: 28,
            ),
            accountName: Text(user != null ? user['name'] : ''),
            accountEmail: Text(currentUser.email),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              'My Profile',
              style: TextStyle(color: Colors.grey[700]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return MyProfileScreen();
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.grey[700]),
            ),
            onTap: () {
              print('@TODO Redirect to settings screen');
              Navigator.pop(context); // close the drawer
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.pink,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.pink),
            ),
            onTap: logout(context),
          ),
        ],
      ),
    );
  }
}
