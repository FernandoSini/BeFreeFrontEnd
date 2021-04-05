import 'package:be_free_front/Models/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({this.user});
  final User? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                "${user?.userName}",
                style: TextStyle(
                  fontFamily: "Segoe",
                  color: Colors.pink[400],
                  fontSize: (defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform == TargetPlatform.iOS)
                      ? 30
                      : 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actionsIconTheme: IconThemeData(
                color: Color(0xFF9a00e6),
              ),
            )
          : AppBar(),
    );
  }
}
