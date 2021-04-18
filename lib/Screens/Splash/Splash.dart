import 'dart:async';
import 'package:be_free_front/Models/EventOwner.dart';
import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Screens/Base/BaseScreen.dart';
import 'package:be_free_front/Screens/EventOwner/Base/BaseScreenEventOwner.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
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
  // final LocalStorage localStorage = new LocalStorage("userData");
  //
  @override
  void didChangeDependencies() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      var token = await storage.read(key: "token");
      var data = await storage.readAll();
      var eventOwnerToken = await storage.read(key: "event_owner_token");

      if (await storage.containsKey(key: "token")) {
        if (token != null) {
          if (!JwtDecoder.isExpired(token)) {
            // await storage.deleteAll();
            print(data);
            print("token não expirou");
            Map<String, dynamic> fromLocalToUser = {};
            fromLocalToUser.addEntries(data.entries);
            User? user = User.fromJson(fromLocalToUser);
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
              "userGraduations": "",
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
          print("object");
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
      } else if (await storage.containsKey(key: "event_owner_token")) {
        if (eventOwnerToken != null) {
          if (!JwtDecoder.isExpired(eventOwnerToken)) {
            Map<String, dynamic> fromLocalToUser = {};
            fromLocalToUser.addEntries(data.entries);
            EventOwner? eventOwner = EventOwner.fromJson(fromLocalToUser);
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) =>
                      BaseScreenEventOwner(eventOwner: eventOwner)));
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
    } else {
      if (universal.window.localStorage.containsKey("token")) {
        // print(universal.window.cookieStore!.getAll());
        print(universal.window.sessionStorage.containsValue("token"));

        if (!JwtDecoder.isExpired(universal.window.localStorage["token"]!)) {
          Map<String, dynamic> fromLocalToUser = {};
          fromLocalToUser.addEntries(universal.window.localStorage.entries);
          User user = User.fromJson(fromLocalToUser);
          print(user.toString());
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
          universal.window.localStorage.clear();
          print("token expirou");
          Timer(
            Duration(seconds: 5),
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
        print(universal.window.localStorage.containsKey("user"));
        print(universal.window.localStorage.containsKey("token"));

        Timer(
          Duration(seconds: 5),
          () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => LoginScreen(),
              ),
            );
          },
        );
      }
      super.didChangeDependencies();
    }
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
