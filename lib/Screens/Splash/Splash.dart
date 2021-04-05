import 'dart:async';
import 'dart:convert';

import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Providers/UserProvider.dart';
import 'package:be_free_front/Screens/Base/BaseScreen.dart';
import 'package:be_free_front/Screens/Home/HomeScreen.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:universal_html/html.dart' as universal;

import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final storage = new FlutterSecureStorage();
  // final LocalStorage localStorage = new LocalStorage("userData");
  @override
  void didChangeDependencies() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      var token = await storage.read(key: "token");
      var data = await storage.readAll();

      if (token != null) {
        print("proxima tela1:" + data.toString());
        print("token1:" + token.toString());
        if (!JwtDecoder.isExpired(token)) {
          // await storage.deleteAll();
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
          await storage.deleteAll();
          print("token expirou");
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
        print("proxima tela 2: " + data.toString());
        print("token2:" + token.toString());
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
