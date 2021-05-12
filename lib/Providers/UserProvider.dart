import 'dart:convert';
import 'dart:io';
import 'package:localstorage/localstorage.dart';

import 'package:be_free_front/Models/ImageModel.dart';
import 'package:be_free_front/Models/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:universal_html/html.dart' as universal;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  User? user = User();
  final storage = new FlutterSecureStorage();
  final localStorage = new LocalStorage("data");
  void setUser(User? value) {
    user = value;
    notifyListeners();
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
      
      await storage.write(key: "user", value: jsonEncode(user!.toJson()));
      notifyListeners();
    } 
  }
}
