

import 'package:be_free_front/Models/Gender.dart';
import 'package:be_free_front/Providers/RegisterProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class GenderScreen extends StatelessWidget {
  // GenderScreen({this.registerProvider});
  // final RegisterProvider? registerProvider;

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
              fontSize: (defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS)
                  ? 30
                  : 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Select your gender: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              // padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(left: 50, right: 50),
              height: 55,
              decoration: BoxDecoration(
                color: Color(0xFF9a00e6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Consumer<RegisterProvider>(
                builder: (_, registerProvider, __) => RadioListTile(
                  title: Text(
                    "Male",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: Gender.MALE,
                  activeColor: Colors.white,
                  groupValue: registerProvider.genderValue,
                  // onChanged: (dynamic value) {
                  //   registerProvider.gender = value;
                  //   print("name: ${registerProvider.genderValue}");
                  // },
                  onChanged: (dynamic value) {
                    registerProvider.gender = value;
                    registerProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              height: 55,
              decoration: BoxDecoration(
                color: Color(0xFF9a00e6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Consumer<RegisterProvider>(
                builder: (_, registerProvider, child) => RadioListTile(
                  title: Text(
                    "Female",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: Gender.FEMALE,
                  activeColor: Colors.white,
                  groupValue: registerProvider.genderValue,
                  // onChanged: (dynamic value) {
                  //   registerProvider.gender = value;
                  //   print("${registerProvider.genderValue}}");
                  // },
                  onChanged: (dynamic value) {
                    registerProvider.gender = value;
                    registerProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              // padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(left: 50, right: 50),
              height: 55,
              decoration: BoxDecoration(
                color: Color(0xFF9a00e6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Consumer<RegisterProvider>(
                builder: (context, registerProvider, __) => RadioListTile(
                  toggleable: true,
                  title: Text(
                    "Nonbinary",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: Gender.NONBINARY,
                  activeColor: Colors.white,
                  groupValue: registerProvider.gender,
                  // onChanged: (dynamic value) {
                  //   registerProvider.gender = value;
                  //   print("maconha das brabdas " +
                  //       "${registerProvider.genderValue}");
                  // },
                  onChanged: (dynamic value) {
                    registerProvider.gender = value;
                    registerProvider.notifyListeners();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
