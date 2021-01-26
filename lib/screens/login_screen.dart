import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/user.dart';
import 'package:fammily/components/background.dart';
import 'package:fammily/components/input.dart';
import 'package:fammily/components/or_divider.dart';
import 'package:fammily/components/social_icon.dart';
import 'package:fammily/screens/home_screen.dart';
import 'package:fammily/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginData {
  String email = '';
  String password = '';
  void setEmail(String value) {
    this.email = value;
  }

  void setPassword(String value) {
    this.password = value;
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  _LoginData _data = new _LoginData();
  bool _showPassword = false;

  void submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _data.email, password: _data.password);
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

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      User user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      QuerySnapshot userData = await FirestoreUserController.getUser(user.uid);
      if (userData.docs.length == 0) {
        await FirestoreUserController.addUser(
            user.uid, user.displayName);
      }
    } catch (e) {
      print (e);
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
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
                    key: _formKey,
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
                              label: 'Email',
                              icon: Icon(Icons.email),
                              onSaveFunc: this._data.setEmail,
                              keyboardType: TextInputType.emailAddress,
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            child: Input(
                              label: 'Password',
                              icon: Icon(Icons.lock),
                              obscureText: !_showPassword,
                              onSaveFunc: this._data.setPassword,
                              keyboardType: TextInputType.visiblePassword,
                            )),
                        SizedBox(height: 28),
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
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                              onPressed: submit,
                            )),
                        SizedBox(height: 28),
                        OrDivider(),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SocialIcon(
                              iconSrc: "assets/icons/facebook.svg",
                              press: () {
                                print('@TODO Sign in with Facebook');
                              },
                            ),
                            SocialIcon(
                              iconSrc: "assets/icons/google.svg",
                              press: signInWithGoogle,
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
                                "Don't have an Account? ",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return RegisterScreen();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
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
            )));
  }
}
