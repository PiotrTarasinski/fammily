import 'package:fammily/api/family.dart';
import 'package:fammily/components/family_list.dart';
import 'package:fammily/components/invite_code.dart';
import 'package:flutter/material.dart';

class FamilyScreen extends StatefulWidget {
  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  String _familyName = '';

  _FamilyScreenState() {
    FirestoreFamilyController.getFamilyName().then((value) {
      this.setState(() {
        _familyName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(_familyName),
          ),
          SizedBox(height: 12),
          Text(
            'Invite Code',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          InviteCode(),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.group,
                  color: Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  'Family Members',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          FamilyList(),
        ],
      ),
    );
  }
}
