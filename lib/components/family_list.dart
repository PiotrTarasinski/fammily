import 'package:fammily/api/family.dart';
import 'package:flutter/material.dart';

import 'family_member.dart';
import 'family_member.dart';

class FamilyList extends StatefulWidget {
  @override
  _FamilyListState createState() => _FamilyListState();
}

class _FamilyListState extends State<FamilyList> {
  Future<List<Map<String, dynamic>>> users;
  final String _userAvatarUrl =
      'https://lh3.google.com/u/2/ogw/ADGmqu-1qFo7IGTMem4XaXpxU-5SVycTjnutzBwsOYw=s83-c-mo';
  _FamilyListState() {
    users = FirestoreFamilyController.getFamilyUsers();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                for (var element in snapshot.data) FamilyMember(
                  avatarSrc: _userAvatarUrl,
                  name: element['name'],
                  uid: element['uid'],
                )
              ],
            );
          }
          return loading();
        });
  }
}
