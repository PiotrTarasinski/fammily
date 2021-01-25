import 'dart:async';

import 'package:fammily/api/family.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Future<List<Map<String, dynamic>>> users;
  Set<Marker> _markers = {
    // Marker(
    //   markerId: MarkerId('id-1'),
    //   position: LatLng(51.2363, 22.5910),
    // ),
  };

  _MapScreenState() {
    users = FirestoreFamilyController.getFamilyUsers();
  }

  loading() =>
      Center(
        child: SizedBox(
            height: 80.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ]
            )
        ),
      );

  // Future<void> _initCameraPosition() async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   LatLng latLngPosition = LatLng(position.latitude, position.longitude);
  //   CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
  //
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  // }
  
  getInitCameraPosition(List<Map<String, dynamic>> users) {
    LatLng _initCameraPosition = LatLng(51.2352, 22.5488);
    
    for (Map<String, dynamic> element in users) {
      if(element['uid'] == FirebaseAuth.instance.currentUser.uid && element['location'] != null) {
        _initCameraPosition = LatLng(element['location'].latitude, element['location'].longitude);
      }
    }

    return CameraPosition(
      target: _initCameraPosition,
      zoom: 14,
    );
  }

  Set<Marker> getMarkers(List<Map<String, dynamic>> users) {
    Set<Marker> markers = {};

    for (Map<String, dynamic> element in users) {
      if(element['location'] != null) {
        markers.add(Marker(
            markerId: MarkerId(element['uid']),
            position: LatLng(element['location'].latitude, element['location'].longitude),
        ));
      }
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              markers: getMarkers(snapshot.data),
              initialCameraPosition: getInitCameraPosition(snapshot.data),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          }
          return loading();
        }
    );
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