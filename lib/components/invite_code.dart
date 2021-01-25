import 'package:fammily/api/family.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InviteCode extends StatefulWidget {
  @override
  _InviteCodeState createState() => _InviteCodeState();
}

class _InviteCodeState extends State<InviteCode> {
  Future<String> code;
  _InviteCodeState() {
    code = FirestoreFamilyController.getFamilyCode();
  }

  loading() => Center(
    child: SizedBox(
        height: 50.0,
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
        future: code,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return  GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: snapshot.data));
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invite code copied to clipboard')));
              },
              child: Text(
                snapshot.data,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 42,
                  letterSpacing: 10,
                ),
              ),
            );
          }
          return loading();
        });
  }
}