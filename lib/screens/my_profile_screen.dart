import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/user.dart';
import 'package:fammily/components/input.dart';
import 'package:fammily/components/side_bar.dart';
import 'package:fammily/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _UserData {
  String name = '';
  void setName(String value) {
    this.name = value;
  }
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  _UserData _data = new _UserData();
  Future<Map<String, dynamic>> user;
  String avatarUrl;
  File _image;
  final picker = ImagePicker();

  _MyProfileScreenState() {
    User user = FirebaseAuth.instance.currentUser;
    this.user = FirestoreUserController.getUserDataById(user.uid);
    FirestoreUserController.getURL(FirebaseAuth.instance.currentUser.uid)
        .then((value) {
      this.setState(() {
        avatarUrl = value;
      });
    });
  }

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Add Image',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  getImage(ImageSource.camera);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.camera_alt, color: Colors.grey[700]),
                      SizedBox(width: 12),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.photo, color: Colors.grey[700]),
                      SizedBox(width: 12),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future getImage(ImageSource imgSrc) async {
    final pickedFile = await picker.getImage(source: imgSrc);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  submit() async {
    _formKey.currentState.save();
    if (_image != null) {
      String fileName = FirebaseAuth.instance.currentUser.uid + '.jpg';
      try {
        await FirebaseStorage.instance.ref('images/$fileName').putFile(_image);
      } on FirebaseException catch (e) {
        print('Something went wrong');
      }
    }

    String docId = (await FirestoreUserController.getUser(
            FirebaseAuth.instance.currentUser.uid))
        .docs[0]
        .id;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update({'name': _data.name});

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
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
                    onPressed: () => Navigator.pop(context)),
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
                      onTap: _showDialog,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        backgroundImage: _image != null
                            ? FileImage(_image)
                            : avatarUrl != null
                                ? NetworkImage(avatarUrl)
                                : AssetImage('assets/images/default.png'),
                        radius: _size.width * 0.2,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                          key: _formKey,
                          child: Input(
                            label: 'Name',
                            icon: Icon(Icons.person),
                            keyboardType: TextInputType.name,
                            initValue: snapshot.data['name'],
                            onSaveFunc: _data.setName,
                          )),
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
                            onPressed: submit)),
                  ],
                ),
              ),
            );
          }
          return loading();
        });
  }
}
