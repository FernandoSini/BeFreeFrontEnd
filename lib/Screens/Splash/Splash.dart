import 'dart:async';
import 'dart:convert';
import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Screens/Base/BaseScreen.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<bool> verifyIfUserExists(String userId) async {
    String? url = "${api.url}forgot-password/verify";

    var data = {"userId": userId};
    var body = json.encode(data);

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void didChangeDependencies() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      // await storage.delete(key: api.key);
      try {
        if (await storage.containsKey(key: "user")) {
          var userData = await storage.read(key: "user");
          if (userData != null) {
            Map<String, dynamic> fromLocalToUser = {};
            fromLocalToUser.addAll(jsonDecode(userData));
            User? user = User.fromJson(fromLocalToUser);
            bool userExists = await verifyIfUserExists(user.id!);
            if (!userExists) {
              await storage.deleteAll();
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
            } else {
              if (!JwtDecoder.isExpired(user.token!)) {
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
                  await storage.delete(key: element);
                });
                await storage.deleteAll();
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
            }
          } else {
            await storage.deleteAll();
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
          await storage.deleteAll();
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
      } catch (e) {
        await storage.deleteAll();
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
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
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
