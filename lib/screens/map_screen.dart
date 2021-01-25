import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/family.dart';
import 'package:fammily/api/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialPosition;
  MapScreen({
    this.initialPosition,
  });
  @override
  _MapScreenState createState() =>
      _MapScreenState(initialPosition: initialPosition);
}

class _MapScreenState extends State<MapScreen> {
  final LatLng initialPosition;
  Timer t;
  Future<Map<String, dynamic>> currentUserMarkerPosition;
  Completer<GoogleMapController> _controller = Completer();
  Future<List<Map<String, dynamic>>> users;
  Set<Marker> _markers;

  futureMockPosition() async {
    return {
      'location': GeoPoint(
          this.initialPosition.latitude, this.initialPosition.longitude)
    };
  }

  _MapScreenState({this.initialPosition}) {
    fetchUsersTimeout();
    if (initialPosition == null) {
      currentUserMarkerPosition = FirestoreUserController.getUserDataById(
          FirebaseAuth.instance.currentUser.uid);
    } else {
      currentUserMarkerPosition = futureMockPosition();
    }
  }

  @override
  void dispose() {
    if (t != null) {
      t.cancel();
    }
    super.dispose();
  }

  fetchUsersTimeout() {
    this.fetchUsers();
    t = Timer(Duration(seconds: 5), () {
      this.fetchUsersTimeout();
    });
  }

  fetchUsers() {
    FirestoreFamilyController.getFamilyUsers().then((users) async {
      Set<Marker> markers = {};
      for (Map<String, dynamic> user in users) {
        if (user['location'] != null) {
          markers.add(Marker(
            markerId: MarkerId(user['uid']),
            position: LatLng(user['location'].latitude, user['location'].longitude),
          ));
        }
      }
      this.setState(() {
        _markers = markers;
      });
    });
  }

  loading() => Center(
        child: SizedBox(
            height: 80.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ])),
      );


  getInitCameraPosition(Map<String, dynamic> position) {
    LatLng _initCameraPosition =
        LatLng(position['location'].latitude, position['location'].longitude);

    return CameraPosition(
      target: _initCameraPosition,
      zoom: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currentUserMarkerPosition,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              markers: _markers,
              initialCameraPosition: getInitCameraPosition(snapshot.data),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          }
          return loading();
        });
  }
}

//   Widget build(BuildContext context) {
//     return GoogleMap(
//       markers: _markers,
//       initialCameraPosition: CameraPosition(
//         target: LatLng(51.2352, 22.5488),
//         zoom: 14,
//       ),
//       onMapCreated: (GoogleMapController controller) {
//         _controller.complete(controller);
//         // _initCameraPosition();
//       },
//     );
//   }
// }
