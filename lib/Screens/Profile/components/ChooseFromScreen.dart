import 'package:flutter/material.dart';

class ChooseFromScreen extends StatefulWidget {
  @override
  _ChooseFromScreenState createState() => _ChooseFromScreenState();
}

class _ChooseFromScreenState extends State<ChooseFromScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF9a00e6)),
        title: Text(
          "BeFree",
          style: TextStyle(
            fontFamily: "Segoe",
            color: Colors.pink[400],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
