import 'package:flutter/material.dart';

class CancelButton{
  Widget cancelButton(context) {
    return FlatButton(
      child: Text("Cancel"),
      onPressed: ()=> Navigator.pop(context),
    );
  }
}