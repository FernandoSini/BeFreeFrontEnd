import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Your Profile",
          style: TextStyle(
            fontFamily: "Segoe",
            fontWeight: FontWeight.bold,
            color: Colors.pink[400],
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF9a00e6),
        ),
      ),
    );
  }
}
