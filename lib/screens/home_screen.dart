import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/user.dart';
import 'package:fammily/components/side_bar.dart';
import 'package:fammily/screens/family_not_found_screen.dart';
import 'package:fammily/screens/family_screen.dart';
import 'package:fammily/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  final LatLng initialPosition;
  final int initialIndex;

  const HomeScreen({Key key, this.initialPosition, this.initialIndex})
      : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState(
      initialIndex: initialIndex, initialPosition: initialPosition);
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng initialPosition;
  int initialIndex;
  int _selectedIndex = 0;
  Future<Map<String, dynamic>> user;
  List<Widget> _widgetOptions;

  _HomeScreenState({Key key, this.initialPosition, this.initialIndex}) {
    User user = FirebaseAuth.instance.currentUser;
    this.user = FirestoreUserController.getUserDataById(user.uid);
    _widgetOptions = <Widget>[
      FamilyScreen(),
      MapScreen(initialPosition: this.initialPosition),
      Center(
        child: Text('Chat'),
      ),
    ];
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
          if (snapshot.hasData) {
            if (snapshot.data['family'] != null) {
              return Scaffold(
                drawer: SideBar(),
                drawerEnableOpenDragGesture: true,
                body: Container(
                  width: double.infinity,
                  height: _size.height,
                  child: _widgetOptions.elementAt(
                      initialIndex != null ? initialIndex : _selectedIndex),
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
                  currentIndex:
                      initialIndex != null ? initialIndex : _selectedIndex,
                  onTap: (int index) {
                    setState(() {
                      _selectedIndex = index;
                      initialIndex = null;
                      initialPosition = null;
                    });
                    _widgetOptions = <Widget>[
                      FamilyScreen(),
                      MapScreen(),
                      Center(
                        child: Text('Chat'),
                      ),
                    ];
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
