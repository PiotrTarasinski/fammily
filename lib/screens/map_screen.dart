import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fammily/api/family.dart';
import 'package:fammily/api/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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

  _MapScreenState({this.initialPosition}) {
    fetchUsersTimeout();
      currentUserMarkerPosition = FirestoreUserController.getUserDataById(
          FirebaseAuth.instance.currentUser.uid);
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

  paintImage(Uint8List bytes, bool isDefault) async {
    final Codec markerImageCodec = await instantiateImageCodec(
      bytes,
      targetWidth: 100,
    );
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    PictureRecorder recorder = new PictureRecorder();
    Canvas canvas = new Canvas(recorder);
    final size = Size(100, 100);
    if (isDefault) {
      Paint paintCircle = Paint()..color = Colors.deepPurple;
      canvas.drawCircle(Offset(50, 50), 50, paintCircle);
  }
    Path path = Path()
      ..addOval(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    canvas.clipPath(path);
    canvas.drawImage(frameInfo.image, new Offset(0.0, 0.0), new Paint());
    Picture picture = recorder.endRecording();
    final ByteData byteData = await (await picture.toImage(100, 100)).toByteData(
      format: ImageByteFormat.png,
    );
    return byteData.buffer.asUint8List();
  }
  
  getIcon(String uid) async {
    BitmapDescriptor icon;
    String url;
    try {
      url = await FirestoreUserController.getURL(uid);
    }
    catch (e) {}
    if (url != null) {
      final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
      if (markerImageFile != null) {
        final Uint8List markerImageBytes = await markerImageFile.readAsBytes();


        icon = BitmapDescriptor.fromBytes(await paintImage(markerImageBytes, false));
      } else {
        final http.Response response = await http.get(url);
        icon = BitmapDescriptor.fromBytes(await paintImage(response.bodyBytes, false));
      }
    } else {
      icon = BitmapDescriptor.fromBytes(await paintImage((await rootBundle.load('assets/images/default.png')).buffer.asUint8List(), true));
    }
    return icon;
  }

  fetchUsers() {
    FirestoreFamilyController.getFamilyUsers().then((users) async {
      Set<Marker> markers = {};
      for (Map<String, dynamic> user in users) {
        if (user['location'] != null) {
          markers.add(Marker(
            markerId: MarkerId(user['uid']),
            position:
                LatLng(user['location'].latitude, user['location'].longitude),
            icon: await getIcon(user['uid']),
            infoWindow: InfoWindow(
              title: user['name']
            )
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
    if (this.initialPosition != null) {
      return CameraPosition(
        target: this.initialPosition,
        zoom: 14,
      );
    }
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
