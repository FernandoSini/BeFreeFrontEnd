import 'package:be_free_front/Models/Gender.dart';
import 'package:be_free_front/Providers/RegisterProvider.dart';
import 'package:flutter/material.dart';

class GenderScreen extends StatelessWidget {
  GenderScreen({this.registerProvider});
  final RegisterProvider registerProvider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "BeFree",
          style: TextStyle(
            fontFamily: "Segoe",
            color: Color(0xFF9a00e6),
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: Row(
                children: [
                  Text("Male"),
                  Radio(
                    value: Gender.MALE,
                    groupValue: Gender,
                    onChanged: (value) => registerProvider.gender,
                  ),
                ],
              ),
            ),
            Radio(
              value: Gender.FEMALE,
              groupValue: Gender,
              onChanged: (value) => registerProvider.gender,
            ),
            Radio(
              value: Gender.NONBINARY,
              groupValue: Gender,
              onChanged: (value) => registerProvider.gender,
            ),
          ],
        ),
      ),
    );
  }
}
