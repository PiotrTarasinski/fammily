import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String label;
  final String hintText;
  final Icon icon;
  final String initValue;
  final IconButton suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String) onSaveFunc;
  Input(
      {this.label,
      this.hintText,
      this.icon,
      this.initValue = '',
      this.obscureText = false,
      this.onSaveFunc,
      this.keyboardType,
      this.suffixIcon});
  @override
  _InputState createState() => _InputState(
      hintText: hintText,
      icon: icon,
      initValue: initValue,
      label: label,
      obscureText: obscureText,
      onSaveFunc: onSaveFunc,
      keyboardType: keyboardType,
      suffixIcon: suffixIcon);
}

class _InputState extends State<Input> {
  final String label;
  final String hintText;
  final Icon icon;
  final String initValue;
  final IconButton suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String) onSaveFunc;
  String error;

  _InputState(
      {this.label,
      this.hintText,
      this.icon,
      this.initValue,
      this.obscureText = false,
      this.onSaveFunc,
      this.keyboardType,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 24.0),
      Container(
          child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              this.error = 'This field is required';
            });
          } else {
            setState(() {
              error = null;
            });
          }
          return null;
        },
        onSaved: (String value) {
          onSaveFunc(value);
        },
        obscureText: obscureText,
        initialValue: initValue,
        keyboardType: this.keyboardType,
        decoration: InputDecoration(
          labelText: this.label,
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          prefixIcon: this.icon,
          suffixIcon: this.suffixIcon,
        ),
      )),
      if (this.error != null)
        Container(
          child: Text(this.error,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic)),
          padding: EdgeInsets.only(top: 4.0, left: 8.0),
        ),
    ]);
  }
}
