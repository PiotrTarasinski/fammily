import 'package:fammily/api/user.dart';
import 'package:fammily/components/background.dart';
import 'package:fammily/components/input.dart';
import 'package:fammily/components/or_divider.dart';
import 'package:fammily/components/social_icon.dart';
import 'package:fammily/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterData {
  String name = '';
  String email = '';
  String password = '';

  void setEmail(String value) {
    this.email = value;
  }

  void setPassword(String value) {
    this.password = value;
  }

  void setName(String value) {
    this.name = value;
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  bool _showPassword = false;
  _RegisterData _registerData = new _RegisterData();

  void register() async {
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();
      try {
        User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _registerData.email, password: _registerData.password))
            .user;
        await FirestoreUserController.addUser(
            user.uid, _registerData.name);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
      try {
       await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _registerData.email, password: _registerData.password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Background(
              child: SingleChildScrollView(
                child: Form(
                    key: _registerFormKey,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 32),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: Image.asset(
                        "assets/images/fammily_logo.png",
                      ),
                    ),
                    SizedBox(height: 48),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        child: Input(
                          label: 'Name',
                          icon: Icon(Icons.person),
                          onSaveFunc: this._registerData.setName,
                          keyboardType: TextInputType.name,
                        )
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        child: Input(
                          label: 'Email',
                          icon: Icon(Icons.email),
                          onSaveFunc: this._registerData.setEmail,
                          keyboardType: TextInputType.emailAddress,
                        )
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        child: Input(
                          label: 'Password',
                          icon: Icon(Icons.lock),
                          obscureText: !_showPassword,
                          onSaveFunc: this._registerData.setPassword,
                          keyboardType: TextInputType.visiblePassword,
                        )
                    ),
                    SizedBox(height: 28),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      width: _size.width,
                      child: FlatButton(
                        color: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18
                          ),
                        ),
                        onPressed: this.register,
                      )
                    ),
                    SizedBox(height: 28),
                    OrDivider(),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocialIcon(
                          iconSrc: "assets/icons/facebook.svg",
                          press: () {
                            print('@TODO Sign up with Facebook');
                          },
                        ),
                        SocialIcon(
                          iconSrc: "assets/icons/google.svg",
                          press: () {
                            print('@TODO Sign up with Google');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 36),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an Account? ",
                            style: TextStyle(
                                color: Colors.grey[700]
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                )),
              ),
            )
        )
    );
  }
}