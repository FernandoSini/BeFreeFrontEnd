import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:be_free_front/Models/EventOwner.dart';
import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Screens/Base/BaseScreen.dart';
import 'package:be_free_front/Screens/EventOwner/Base/BaseScreenEventOwner.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:universal_html/html.dart' as universal;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final storage = new FlutterSecureStorage();
  @override
  void didChangeDependencies() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      // var userData = await storage.read(key: "user");
      // print(userData);
      //  await storage.deleteAll();
      if (await storage.containsKey(key: "user")) {
        var userData = await storage.read(key: "user");
        if (userData != null) {
          // token = localData["token"];
          Map<String, dynamic> fromLocalToUser = {};
          fromLocalToUser.addAll(jsonDecode(userData));
          User? user = User.fromJson(fromLocalToUser);
          if (!JwtDecoder.isExpired(user.token!)) {
            print("token não expirou");
            Timer(
              Duration(seconds: 5),
              () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BaseScreen(
                      userData: user,
                    ),
                  ),
                );
              },
            );
          } else {
            Map<String, String> userData = {
              "id_user": "",
              "user_name": "",
              "first_name": "",
              "last_name": "",
              "birthday": "",
              "gender": "",
              "email": "",
              "avatar": "",
              "images": "",
              "matches": "",
              "likeReceived": "",
              "likesSended": "",
              "token": "",
              "job_title": "",
              "company": ""
            };
            userData.keys.forEach((element) async {
              print(element);
              await storage.delete(key: element);
            });
            Timer(
              Duration(seconds: 3),
              () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              },
            );
          }
        } else {
          Timer(
            Duration(seconds: 3),
            () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
          );
        }
      } else if (await storage.containsKey(key: "event_owner")) {
        var eventOwnerData = await storage.read(key: "event_owner");
        if (eventOwnerData != null) {
          Map<String, dynamic> fromLocalToUser = {};
          fromLocalToUser.addAll(jsonDecode(eventOwnerData));
          EventOwner? eventOwner = EventOwner.fromJson(fromLocalToUser);
          if (!JwtDecoder.isExpired(eventOwner.token!)) {
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BaseScreenEventOwner(eventOwner: eventOwner),
                ),
              );
            });
          } else {
            Map<String, String> eventOwnerData = {
              "event_owner_id": "",
              "event_owner_name": "",
              "document_number": "",
              "event_owner_email": "",
              "event_owner_avatar": "",
              "events": "",
              "event_owner_token": ""
            };
            eventOwnerData.keys.forEach((element) async {
              await storage.delete(key: element);
            });
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen()));
            });
          }
        }
      } else {
        await storage.deleteAll();
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()));
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.red),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Text(
            "BeFree",
            style: TextStyle(
              color: Color(0xFF9a00e6),
              fontFamily: "Segoe",
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
