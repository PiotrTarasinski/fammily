import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/user.dart';
import 'package:fammily/components/side_bar.dart';
import 'package:fammily/screens/family_not_found_screen.dart';
import 'package:fammily/screens/family_screen.dart';
import 'package:fammily/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Future<Map<String, dynamic>> user;

  _HomeScreenState() {
    User user = FirebaseAuth.instance.currentUser;
    this.user = FirestoreUserController.getUserDataById(user.uid);
  }

  static List<Widget> _widgetOptions = <Widget>[
    FamilyScreen(),
    MapScreen(),
    Center(
      child: Text('Chat'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget loading() {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: this.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data['family'] != null) {
              return Scaffold(
                drawer: SideBar(),
                drawerEnableOpenDragGesture: true,
                body: Container(
                  width: double.infinity,
                  height: _size.height,
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 10,
                  backgroundColor: Colors.white,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.family_restroom),
                      label: 'Family',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.location_on),
                      label: 'Tracking',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      label: 'Chat',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              );
            }
            return FamilyNotFoundScreen();
          }
          return loading();
        });
  }
}