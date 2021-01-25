import 'package:fammily/components/background.dart';
import 'package:fammily/components/input.dart';
import 'package:fammily/components/or_divider.dart';
import 'package:flutter/material.dart';

class FamilyNotFoundScreen extends StatefulWidget {
  @override
  _FamilyNotFoundScreenState createState() => _FamilyNotFoundScreenState();
}

class _FamilyNotFoundScreenState extends State<FamilyNotFoundScreen> {

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    _showDialog(bool isCreateAction) async {
      String _titleText = isCreateAction ? 'Create Family' : 'Join To Family';
      String _inputLabel = isCreateAction ? 'Family Name' : 'Invite Code';
      String _submitButtonText = isCreateAction ? 'Create' : 'Join';
      IconData _inputIcon = isCreateAction ? Icons.group : Icons.vpn_key;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              _titleText,
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Input(
                    label: _inputLabel,
                    icon: Icon(_inputIcon),
                    keyboardType: TextInputType.name,
                  )
              ),
              SizedBox(height: 24),
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
                    _submitButtonText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    print('@TODO');
                  },
                ),
              ),
            ],
          );
        }
      );
    }

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 32),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  child: Image.asset(
                    "assets/images/family.png",
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  "You are yet to join a family",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple
                  ),
                ),
                SizedBox(height: 36),
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
                      'Create Family',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                    ),
                    onPressed: () {
                      _showDialog(true);
                    },
                  ),
                ),
                SizedBox(height: 20),
                OrDivider(),
                SizedBox(height: 20),
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
                      'Join With Code',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      _showDialog(false);
                    },
                  ),
                ),
                SizedBox(height: 32),
              ],
          ),
        ),
      ),
    );
  }
}
