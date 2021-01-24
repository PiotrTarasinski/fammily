import 'package:fammily/components/side_bar.dart';
import 'package:fammily/screens/family_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  static List<Widget> _widgetOptions = <Widget>[
    FamilyScreen(),
    Center(
      child: Text('Map'),
    ),
    Center(
      child: Text('Chat'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

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
}