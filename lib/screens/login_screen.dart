import 'package:fammily/components/background.dart';
import 'package:fammily/components/or_divider.dart';
import 'package:fammily/components/social_icon.dart';
import 'package:fammily/screens/home_screen.dart';
import 'package:fammily/screens/register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;

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
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              prefixIcon: Icon(
                                  Icons.email
                              )
                          ),
                        )
                    ),
                    SizedBox(height: 32),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(!_showPassword ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              )
                          ),
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
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18
                            ),
                          ),
                          onPressed: () {
                            print('@TODO Sign in');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HomeScreen();
                                },
                              ),
                            );
                          },
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
                            print('@TODO Sign in with Facebook');
                          },
                        ),
                        SocialIcon(
                          iconSrc: "assets/icons/google.svg",
                          press: () {
                            print('@TODO Sign in with Google');
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
                            "Don't have an Account? ",
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
                ),
              ),
            )
        )
    );
  }
}