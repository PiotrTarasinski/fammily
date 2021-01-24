import 'package:flutter/material.dart';

class FamilyMember extends StatelessWidget {
  final String avatarSrc;
  final String name;

  const FamilyMember({
    Key key,
    this.avatarSrc,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1, color: Colors.grey[300])
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(avatarSrc),
                radius: 28,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Family owner',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
              icon: Icon(
                Icons.person_remove_rounded,
                color: Colors.grey[600],
              ),
              onPressed: () {
                print('@TODO Remove person');
              }
          ),
        ],
      ),
    );
  }
}
