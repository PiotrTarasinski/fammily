import 'dart:async';

import 'package:fammily/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'screens/home_screen.dart';

// void main() => runApp(MaterialApp(
//   home: LoginScreen(),
// ));
//
// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: FlatButton(
//                 color: Colors.deepPurple,
//                 onPressed: () => {Geolocator.getCurrentPosition().then((Position position) => print(position))},
//                 child: Text('Get Current Location', style: TextStyle(color: Colors.white),)
//             )
//         )
//     );
//   }
// }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fammily',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<FirebaseApp> _initialization;
  User _user;
  StreamSubscription<User> stream;

  _MyHomePageState() {
    _initialization = Firebase.initializeApp().then((FirebaseApp firebaseApp) {
      _user = FirebaseAuth.instance.currentUser;
      stream = FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          _user = event;
        });
      });
      return firebaseApp;
    });

  }

  @override
  void dispose() {
    if (stream != null) {
      stream.cancel();
    }
    super.dispose();
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
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if (_user != null) {
            return  HomeScreen();
          }
          return LoginScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading();
      },
    );
  }
}