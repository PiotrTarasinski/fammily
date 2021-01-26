import 'package:fammily/api/user.dart';
import 'package:fammily/components/input.dart';
import 'package:fammily/components/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Future<Map<String, dynamic>> user;
  String avatarUrl;

  _MyProfileScreenState() {
    User user = FirebaseAuth.instance.currentUser;
    this.user = FirestoreUserController.getUserDataById(user.uid);
    FirestoreUserController.getURL(FirebaseAuth.instance.currentUser.uid).then((value) {
      this.setState(() {
        avatarUrl = value;
      });
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
          if (snapshot.hasData) {
            return Scaffold(
              drawer: SideBar(),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)
                ),
                title: Text(
                  'My Profile',
                ),
              ),
              drawerEnableOpenDragGesture: true,
              body: Container(
                width: double.infinity,
                height: _size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 42),
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : AssetImage('assets/images/default.png'),
                        radius: _size.width * 0.2,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        child: Input(
                          label: 'Name',
                          icon: Icon(Icons.person),
                          keyboardType: TextInputType.name,
                          initValue: snapshot.data['name'],
                        )
                    ),
                    SizedBox(height: 32),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        width: _size.width,
                        child: FlatButton(
                          color: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                          onPressed: () {},
                        )),
                  ],
                ),
              ),
            );
          }
          return loading();
        });
  }
}