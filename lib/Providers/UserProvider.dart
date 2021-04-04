import 'dart:io';

import 'package:be_free_front/Models/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as universal;
import 'package:localstorage/localstorage.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  User? user = User();
  final storage = new FlutterSecureStorage();

  void setUser(User? value) {
    user = value;
    saveDataOnSecurePlace(user);
  }
  // Future<User?> loadData() async {
  //   if (defaultTargetPlatform == TargetPlatform.android ||
  //       defaultTargetPlatform == TargetPlatform.iOS) {

  //     await storage.read(key: "token");
  //    return await storage.read(key: "user");
  //   } else {

  //       html.window.localStorage.containsKey("user");
  //       html.window.localStorage.containsKey("token");
  //     }
  //   }

  void saveDataOnSecurePlace(User? user) async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      Map<String, dynamic> userData = {
        "id_user": user!.idUser!,
        "user_name": user.userName!,
        "first_name": user.firstName!,
        "last_name": user.lastName!,
        "birthday": user.birthday!,
        "gender": user.gender!,
        "email": user.email!,
        "avatar": user.avatar == null ? "null" : user.avatar!,
        "images": user.images?.toList(),
        "userGraduations": user.userGraduations?.toList(),
        "matches": user.matches?.toList(),
        "likeReceived": user.likeReceived?.toList(),
        "likesSended": user.likesSended?.toList(),
        "token": user.token!,
      };
      userData.forEach((key, value) async {
        await storage.write(key: key, value: value);
      });
    } else {
      if (user?.token != null) {
        // universal.window.localStorage["user"] = user.toString();
        // universal.window.localStorage["token"] = user!.token!;
        Map<String, String> userData = {
          "id_user": user!.idUser!,
          "user_name": user.userName!,
          "first_name": user.firstName!,
          "last_name": user.lastName!,
          "birthday": user.birthday!,
          "gender": user.gender!,
          "email": user.email!,
          "avatar": user.avatar == null ? "null" : user.avatar!,
          "images": user.images!.toList().toString(),
          "userGraduations": user.userGraduations!.toList().toString(),
          "matches": user.matches!.toList().toString(),
          "likeReceived": user.likeReceived!.toList().toString(),
          "likesSended": user.likesSended!.toList().toString(),
          "token": user.token!,
        };
        universal.window.sessionStorage.addEntries(userData.entries);
        // universal.window.localStorage["user"] = user.toString();
        // universal.window.localStorage["token"] = user?.token;
        // final LocalStorage localStorage = new LocalStorage("userData");
        userData.forEach((key, value) {
          // localStorage.setItem(key, value);
          universal.window.localStorage[key] = value;

          // Cookie cookie = new Cookie("flemis:$key", value);
          // universal.window.cookieStore?.set(cookie.name, cookie.value);

          // universal.window.cookieStore!.set(key, value);
        });

        // user.toJson().forEach((key, value) {
        //   // localStorage.setItem(key, value);
        //   universal.window.localStorage[key] = value;
        // });
      }
    }
  }
}
