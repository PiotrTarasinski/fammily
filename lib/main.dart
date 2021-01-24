import 'package:fammily/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
      home: LoginScreen(),
    );
  }
}