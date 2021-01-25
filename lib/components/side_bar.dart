import 'package:fammily/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String _name = 'Piotr Tarasiński';
  String _email = 'piotrt337@gmail.com';
  String _avatarUrl = 'https://lh3.google.com/u/2/ogw/ADGmqu-1qFo7IGTMem4XaXpxU-5SVycTjnutzBwsOYw=s83-c-mo';

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
              backgroundImage: NetworkImage(_avatarUrl),
            ),
              accountName: Text(_name),
              accountEmail: Text(_email),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              'My Profile',
              style: TextStyle(
                  color: Colors.grey[700]
              ),
            ),
            onTap: () {
              print('@TODO Redirect to profile screen');
              Navigator.pop(context); // close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(
                  color: Colors.grey[700]
              ),
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
              style: TextStyle(
                  color: Colors.pink
              ),
            ),
            onTap: logout(context),
          ),
        ],
      ),
    );
  }
}