import 'dart:math';

import 'package:be_free_front/Models/Gender.dart';
import 'package:be_free_front/Models/Graduation.dart';
import 'package:be_free_front/Providers/RegisterProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PasswordScreen.dart';

class GraduationScreen extends StatefulWidget {
  // GenderScreen({this.registerProvider});
  // final RegisterProvider? registerProvider;

  @override
  _GraduationScreenState createState() => _GraduationScreenState();
}

class _GraduationScreenState extends State<GraduationScreen> {
  Future<List<Graduation?>>? _fetchingGraduations;
  @override
  void didChangeDependencies() {
    _fetchingGraduations = Provider.of<RegisterProvider>(context, listen: false)
        .fetchGraduations();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _fetchingGraduations = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Consumer<RegisterProvider>(
            builder: (_, registerProvider, __) {
              return Text(
                "${registerProvider.graduationData?.courseName ?? "BeFree"}",
                style: TextStyle(
                  fontFamily: "Segoe",
                  color: Color(0xFF9a00e6),
                  fontSize: (defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform == TargetPlatform.iOS)
                      ? 30
                      : 50,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
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
                "Select your graduation(if you have): ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              child: FutureBuilder(
                future: _fetchingGraduations,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Graduation?> graduation = snapshot.data;
                    print(graduation.length);
                    return Consumer<RegisterProvider>(
                      builder: (_, registerProvider, __) {
                        return DropdownButtonFormField<Graduation?>(
                          value: registerProvider.yourGraduationSelected == null
                              ? null
                              : graduation.firstWhere((element) =>
                                  element?.id ==
                                  registerProvider.yourGraduationSelected?.id),
                          elevation: 0,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          //value: graduationStore.graduationList.first,
                          // items: registerProvider.graduations?.map(
                          //   (Graduation? graduationValue) {
                          //     return DropdownMenuItem(
                          //       value: graduationValue,
                          //       child: Text("${graduationValue?.courseName}"),
                          //     );
                          //   },
                          // ).toList(),
                          items: graduation
                              .map((Graduation? graduationValue) =>
                                  DropdownMenuItem(
                                    value: graduationValue,
                                    child:
                                        Text("${graduationValue?.courseName}"),
                                  ))
                              .toList(),
                          onChanged: (Graduation? value) {
                            print("${value?.courseName}");
                            registerProvider.setYourGraduation(value);
                          },
                          hint: Text("Find People by he/her graduation"),
                          icon: Icon(Icons.school),
                          isExpanded: true,
                          isDense: true,
                          iconSize: 40,

                          //autofocus: true,
                          //focusNode: FocusNode(canRequestFocus: true),
                          dropdownColor: Colors.white,
                        );
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text("${snapshot.error}"),
                    );
                  }
                  return Container();
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(left: 50, right: 50),
                height: 55,
                child: Consumer<RegisterProvider>(
                  builder: (_, registerProvider, __) {
                    return ElevatedButton(
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff9a00e6),
                        elevation: 5,
                        // backgroundColor: Color(0xff9a00e6) ?? Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: registerProvider.yourGraduationSelected != null
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PasswordScreen(),
                                ),
                              );
                            }
                          : null, /* ??
                    null, */
                    );
                  },
                )),
            const SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Or",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 50, right: 50),
              height: 55,
              child: ElevatedButton(
                child: Text(
                  "Skip this step",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff9a00e6),
                  elevation: 5,
                  // backgroundColor: Color(0xff9a00e6) ?? Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: null ??
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PasswordScreen(),
                        ),
                      );
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
