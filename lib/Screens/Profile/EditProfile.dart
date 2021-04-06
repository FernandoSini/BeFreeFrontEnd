import 'package:be_free_front/Models/User.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  EditProfile({this.userData});
  User? userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("${userData?.userName}")),
      ),
    );
  }
}
