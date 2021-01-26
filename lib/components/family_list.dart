import 'package:fammily/api/family.dart';
import 'package:flutter/material.dart';

import 'family_member.dart';

class FamilyList extends StatefulWidget {
  @override
  _FamilyListState createState() => _FamilyListState();
}

class _FamilyListState extends State<FamilyList> {
  Future<List<Map<String, dynamic>>> users;
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
                for (var element in snapshot.data)
                  FamilyMember(
                    name: element['name'],
                    uid: element['uid'],
                    role: element['role'],
                  )
              ],
            );
          }
          return loading();
        });
  }
}
